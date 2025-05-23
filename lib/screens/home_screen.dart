// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Greeting
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _getGreeting(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 24),

                  // Today's Summary
                  const Text(
                    "Today's Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSummaryCards(),
                  const SizedBox(height: 24),

                  // Upcoming Tasks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Upcoming Tasks",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/tasks');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  _buildTaskList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, ${_currentUser?.displayName?.split(' ')[0] ?? ''}';
    } else if (hour < 17) {
      return 'Good Afternoon, ${_currentUser?.displayName?.split(' ')[0] ?? ''}';
    } else {
      return 'Good Evening, ${_currentUser?.displayName?.split(' ')[0] ?? ''}';
    }
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildActionButton(
            icon: Icons.add_task,
            label: 'New Task',
            onTap: () => Navigator.pushNamed(context, '/create-task'),
            color: Colors.green,
          ),
          _buildActionButton(
            icon: Icons.calendar_today,
            label: 'Calendar',
            onTap: () => Navigator.pushNamed(context, '/calendar'),
            color: Colors.blue,
          ),
          _buildActionButton(
            icon: Icons.group,
            label: 'Team',
            onTap: () => Navigator.pushNamed(context, '/team'),
            color: Colors.purple,
          ),
          _buildActionButton(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () => Navigator.pushNamed(context, '/settings'),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: _currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final tasks = snapshot.data!.docs;
        final pendingTasks = tasks.where((t) => t['status'] == 'pending').length;
        final inProgressTasks =
            tasks.where((t) => t['status'] == 'in-progress').length;
        final overdueTasks = tasks.where((t) {
          final dueDate = (t['dueDate'] as Timestamp).toDate();
          return dueDate.isBefore(DateTime.now()) && t['status'] != 'completed';
        }).length;

        return Row(
          children: [
            _buildSummaryCard(
              value: tasks.length,
              label: 'Total Tasks',
              icon: Icons.list_alt,
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              value: pendingTasks,
              label: 'Pending',
              icon: Icons.access_time,
              color: Colors.orange,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              value: inProgressTasks,
              label: 'In Progress',
              icon: Icons.play_circle_fill,
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            _buildSummaryCard(
              value: overdueTasks,
              label: 'Overdue',
              icon: Icons.warning,
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required int value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('tasks')
          .where('assignedTo', isEqualTo: _currentUser?.uid)
          .where('status', whereIn: ['pending', 'in-progress'])
          .orderBy('dueDate')
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No upcoming tasks'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final task = snapshot.data!.docs[index];
            final data = task.data() as Map<String, dynamic>;
            final dueDate = (data['dueDate'] as Timestamp).toDate();
            final isOverdue = dueDate.isBefore(DateTime.now());

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(data['status']),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['description'] ?? 'No Description',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd').format(dueDate),
                          style: TextStyle(
                            color: isOverdue ? Colors.red : Colors.grey[600],
                            fontWeight:
                                isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/task-detail',
                      arguments: task.id,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.blue;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}