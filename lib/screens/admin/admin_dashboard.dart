// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: const [
          _OverviewTab(),
          _UsersTab(),
          _TasksTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, usersSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, tasksSnapshot) {
            if (usersSnapshot.hasError || tasksSnapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            if (usersSnapshot.connectionState == ConnectionState.waiting || 
                tasksSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userCount = usersSnapshot.data?.size ?? 0;
            final taskCount = tasksSnapshot.data?.size ?? 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Statistics Cards
                  Row(
                    children: [
                      _StatCard(
                        title: 'Total Users',
                        value: userCount,
                        icon: Icons.people,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _StatCard(
                        title: 'Active Tasks',
                        value: taskCount,
                        icon: Icons.task,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Recent Tasks
                  const Text(
                    'Recent Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildTaskList(tasksSnapshot.data!.docs),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTaskList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: docs.length > 5 ? 5 : docs.length,
      itemBuilder: (context, index) {
        final task = docs[index];
        return ListTile(
          title: Text(task['title'] ?? 'No Title'),
          subtitle: Text(task['description'] ?? 'No Description'),
          trailing: Chip(
            label: Text(
              task['status']?.toString().split('.').last ?? 'Pending',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: _getStatusColor(task['status']),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toString().split('.').last) {
      case 'completed':
        return Colors.green;
      case 'inProgress':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                value.toString(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading users'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final user = snapshot.data!.docs[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['photoUrl'] != null 
                      ? NetworkImage(user['photoUrl']) 
                      : null,
                  child: user['photoUrl'] == null 
                      ? Text(user['displayName']?.toString().substring(0, 1) ?? '?') 
                      : null,
                ),
                title: Text(user['displayName'] ?? 'No Name'),
                subtitle: Text(user['email'] ?? 'No Email'),
                trailing: Text(user['role']?.toString().split('.').last ?? 'user'),
              ),
            );
          },
        );
      },
    );
  }
}

class _TasksTab extends StatelessWidget {
  const _TasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading tasks'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final task = snapshot.data!.docs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(task['description'] ?? 'No Description'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            task['status']?.toString().split('.').last ?? 'Pending',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: _getStatusColor(task['status']),
                        ),
                        const Spacer(),
                        Text(
                          'Due: ${_formatDate(task['dueDate'])}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'No date';
    return '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}';
  }

  Color _getStatusColor(String? status) {
    switch (status?.toString().split('.').last) {
      case 'completed':
        return Colors.green;
      case 'inProgress':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}