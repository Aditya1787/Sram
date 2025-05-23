// lib/screens/worker/workers_task.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WorkersTaskScreen extends StatefulWidget {
  const WorkersTaskScreen({Key? key}) : super(key: key);

  @override
  State<WorkersTaskScreen> createState() => _WorkersTaskScreenState();
}

class _WorkersTaskScreenState extends State<WorkersTaskScreen> {
  final _currentUserId = FirebaseAuth.instance.currentUser?.uid;
  final _firestore = FirebaseFirestore.instance;
  String _selectedFilter = 'all'; // 'all', 'pending', 'in-progress', 'completed'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          _buildFilterDropdown(),
        ],
      ),
      body: _buildTaskList(),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedFilter,
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Tasks')),
        DropdownMenuItem(value: 'pending', child: Text('Pending')),
        DropdownMenuItem(value: 'in-progress', child: Text('In Progress')),
        DropdownMenuItem(value: 'completed', child: Text('Completed')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedFilter = value!;
        });
      },
    );
  }

  Widget _buildTaskList() {
    Query<Map<String, dynamic>> taskQuery = _firestore
        .collection('tasks')
        .where('assignedTo', isEqualTo: _currentUserId)
        .orderBy('dueDate', descending: false);

    if (_selectedFilter != 'all') {
      taskQuery = taskQuery.where('status', isEqualTo: _selectedFilter);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: taskQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No tasks assigned yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final task = doc.data() as Map<String, dynamic>;
            return _buildTaskCard(doc.id, task);
          },
        );
      },
    );
  }

  Widget _buildTaskCard(String taskId, Map<String, dynamic> task) {
    final dueDate = (task['dueDate'] as Timestamp).toDate();
    final isOverdue = dueDate.isBefore(DateTime.now()) && task['status'] != 'completed';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: isOverdue ? Colors.red[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(task['status']),
              ],
            ),
            const SizedBox(height: 8),
            Text(task['description'] ?? 'No Description'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due: ${DateFormat('MMM dd, yyyy').format(dueDate)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                _buildActionButtons(taskId, task['status']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'in-progress':
        chipColor = Colors.blue;
        break;
      case 'pending':
      default:
        chipColor = Colors.orange;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildActionButtons(String taskId, String currentStatus) {
    return Row(
      children: [
        if (currentStatus == 'pending')
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.blue),
            onPressed: () => _updateTaskStatus(taskId, 'in-progress'),
            tooltip: 'Start Task',
          ),
        if (currentStatus == 'in-progress')
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () => _updateTaskStatus(taskId, 'completed'),
            tooltip: 'Mark Complete',
          ),
        IconButton(
          icon: const Icon(Icons.info, color: Colors.grey),
          onPressed: () => _showTaskDetails(taskId),
          tooltip: 'View Details',
        ),
      ],
    );
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  void _showTaskDetails(String taskId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('tasks').doc(taskId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Task not found'));
            }

            final task = snapshot.data!.data() as Map<String, dynamic>;
            final dueDate = (task['dueDate'] as Timestamp).toDate();
            final createdAt = (task['createdAt'] as Timestamp).toDate();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(task['description'] ?? 'No Description'),
                  const SizedBox(height: 16),
                  _buildDetailRow('Status', task['status']),
                  _buildDetailRow('Due Date', DateFormat.yMMMd().format(dueDate)),
                  _buildDetailRow('Created', DateFormat.yMMMd().format(createdAt)),
                  if (task.containsKey('location'))
                    _buildDetailRow('Location', task['location']),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CLOSE'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}