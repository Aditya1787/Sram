// lib/models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? route;
  final bool isRead;
  final DateTime timestamp;
  final String? senderId;
  final String? receiverId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.route,
    this.isRead = false,
    required this.timestamp,
    this.senderId,
    this.receiverId,
  });

  // Convert model to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'route': route,
      'isRead': isRead,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }

  // Create model from Firestore document
  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'],
      route: map['route'],
      isRead: map['isRead'] ?? false,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      senderId: map['senderId'],
      receiverId: map['receiverId'],
    );
  }

  // For local notifications
  factory NotificationModel.local({
    required String title,
    required String body,
    String? imageUrl,
    String? route,
  }) {
    return NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      imageUrl: imageUrl,
      route: route,
      isRead: false,
      timestamp: DateTime.now(),
    );
  }

  // Copy with method for updates
  NotificationModel copyWith({
    String? title,
    String? body,
    String? imageUrl,
    String? route,
    bool? isRead,
    DateTime? timestamp,
    String? senderId,
    String? receiverId,
  }) {
    return NotificationModel(
      id: id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      route: route ?? this.route,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
    );
  }
}