// lib/models/task_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { pending, inProgress, completed, cancelled }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String assignedTo; // User ID
  final String assignedBy; // User ID
  final DateTime dueDate;
  final DateTime createdAt;
  final TaskStatus status;
  final String? location;
  final String? category;
  final List<String>? attachments;
  final int? priority; // 1-5 scale

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedBy,
    required this.dueDate,
    required this.createdAt,
    this.status = TaskStatus.pending,
    this.location,
    this.category,
    this.attachments,
    this.priority,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'dueDate': Timestamp.fromDate(dueDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status.name,
      'location': location,
      'category': category,
      'attachments': attachments,
      'priority': priority,
    };
  }

  // Create from Firestore document
  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      assignedBy: map['assignedBy'] ?? '',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => TaskStatus.pending,
      ),
      location: map['location'],
      category: map['category'],
      attachments: List<String>.from(map['attachments'] ?? []),
      priority: map['priority'],
    );
  }

  // Helper methods
  bool get isOverdue => dueDate.isBefore(DateTime.now()) && status != TaskStatus.completed;
  bool get isHighPriority => (priority ?? 0) >= 4;

  // Status change methods
  TaskModel markInProgress() {
    return copyWith(status: TaskStatus.inProgress);
  }

  TaskModel markCompleted() {
    return copyWith(status: TaskStatus.completed);
  }

  // Copy with method for updates
  TaskModel copyWith({
    String? title,
    String? description,
    String? assignedTo,
    String? assignedBy,
    DateTime? dueDate,
    TaskStatus? status,
    String? location,
    String? category,
    List<String>? attachments,
    int? priority,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      status: status ?? this.status,
      location: location ?? this.location,
      category: category ?? this.category,
      attachments: attachments ?? this.attachments,
      priority: priority ?? this.priority,
    );
  }

  // For UI status display
  String get statusText {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  // For priority display
  String get priorityText {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      case 4:
      case 5:
        return 'Critical';
      default:
        return 'Not Set';
    }
  }
}