// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection References
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _tasks => _firestore.collection('tasks');
  CollectionReference get _notifications => _firestore.collection('notifications');

  // 1. User Operations
  Future<void> createUserDocument({
    required String userId,
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    try {
      await _users.doc(userId).set({
        'uid': userId,
        'email': email,
        'displayName': name,
        'photoUrl': photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'emailVerified': false,
        'role': 'user', // Default role
      });
    } catch (e) {
      throw 'Failed to create user document: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Failed to get user data: $e';
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await _users.doc(userId).update({
        if (displayName != null) 'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update profile: $e';
    }
  }

  // 2. Task Operations
  Future<String> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required String assignedTo,
    String? assignedBy,
  }) async {
    try {
      final docRef = await _tasks.add({
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'assignedTo': assignedTo,
        'assignedBy': assignedBy ?? _auth.currentUser?.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw 'Failed to create task: $e';
    }
  }

  Stream<QuerySnapshot> getUserTasks(String userId, {String? status}) {
    try {
      Query query = _tasks
          .where('assignedTo', isEqualTo: userId)
          .orderBy('dueDate', descending: false);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      return query.snapshots();
    } catch (e) {
      throw 'Failed to get user tasks: $e';
    }
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required String newStatus,
  }) async {
    try {
      await _tasks.doc(taskId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update task status: $e';
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _tasks.doc(taskId).delete();
    } catch (e) {
      throw 'Failed to delete task: $e';
    }
  }

  // 3. Notification Operations
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    String? route,
  }) async {
    try {
      await _notifications.add({
        'userId': userId,
        'title': title,
        'body': body,
        'route': route,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create notification: $e';
    }
  }

  Stream<QuerySnapshot> getUserNotifications(String userId) {
    try {
      return _notifications
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e) {
      throw 'Failed to get notifications: $e';
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notifications.doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      throw 'Failed to mark notification as read: $e';
    }
  }

  // 4. Batch Operations
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final batch = _firestore.batch();
      final notifications = await _notifications
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      for (final doc in notifications.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
    } catch (e) {
      throw 'Failed to mark all notifications as read: $e';
    }
  }

  // 5. Generic Document Operations
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw 'Failed to get document: $e';
    }
  }

  Stream<DocumentSnapshot> documentStream(String collection, String docId) {
    try {
      return _firestore.collection(collection).doc(docId).snapshots();
    } catch (e) {
      throw 'Failed to get document stream: $e';
    }
  }

  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collection).doc(docId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update document: $e';
    }
  }
}