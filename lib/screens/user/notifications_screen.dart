// import 'package:flutter/material.dart';

// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildNotificationItem(
//             'New Job Request',
//             'You have a new plumbing job request from Amit Patel',
//             '10:30 AM',
//             Icons.work,
//             Colors.blue,
//           ),
//           const SizedBox(height: 12),
//           _buildNotificationItem(
//             'Payment Received',
//             'You received ₹2,500 for the electrical work',
//             'Yesterday',
//             Icons.payment,
//             Colors.green,
//           ),
//           const SizedBox(height: 12),
//           _buildNotificationItem(
//             'Rating Received',
//             'You received a 5-star rating from Priya Sharma',
//             '2 days ago',
//             Icons.star,
//             Colors.amber,
//           ),
//           const SizedBox(height: 12),
//           _buildNotificationItem(
//             'System Update',
//             'New features have been added to the app',
//             '1 week ago',
//             Icons.system_update,
//             Colors.purple,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationItem(
//     String title,
//     String message,
//     String time,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: color),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     message,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     time,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 


// lib/screens/user/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  final _notificationsCollection = FirebaseFirestore.instance.collection('notifications');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsCollection
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notifications yet'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return _buildNotificationItem(
                id: doc.id,
                title: data['title'] ?? 'Notification',
                body: data['body'] ?? '',
                isRead: data['isRead'] ?? false,
                timestamp: (data['createdAt'] as Timestamp).toDate(),
                type: data['type'] ?? 'general',
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String id,
    required String title,
    required String body,
    required bool isRead,
    required DateTime timestamp,
    required String type,
  }) {
    return Dismissible(
      key: Key(id),
      background: Container(color: Colors.red),
      confirmDismiss: (direction) async {
        await _markAsRead(id);
        return direction == DismissDirection.endToStart;
      },
      onDismissed: (_) => _deleteNotification(id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: isRead ? Colors.white : Colors.blue[50],
        child: ListTile(
          leading: _getNotificationIcon(type),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(body),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM d, yyyy · hh:mm a').format(timestamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: isRead ? null : const Icon(Icons.circle, size: 12, color: Colors.blue),
          onTap: () => _handleNotificationTap(id, isRead),
        ),
      ),
    );
  }

  Widget _getNotificationIcon(String type) {
    switch (type) {
      case 'alert':
        return const Icon(Icons.warning, color: Colors.red);
      case 'message':
        return const Icon(Icons.message, color: Colors.blue);
      case 'task':
        return const Icon(Icons.task, color: Colors.green);
      default:
        return const Icon(Icons.notifications, color: Colors.amber);
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({'isRead': true});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking as read: $e')),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final unreadNotifications = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in unreadNotifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking all as read: $e')),
      );
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting notification: $e')),
      );
    }
  }

  void _handleNotificationTap(String notificationId, bool isRead) {
    if (!isRead) {
      _markAsRead(notificationId);
    }
    // Add navigation logic here if needed
  }
}