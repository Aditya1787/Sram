// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { worker, supervisor, admin, client }

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final bool isEmailVerified;
  final List<String>? assignedTasks;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.role = UserRole.worker,
    this.createdAt,
    this.lastLogin,
    this.isEmailVerified = false,
    this.assignedTasks,
    this.metadata,
  });

  // Empty user
  static UserModel empty() => UserModel(
        uid: '',
        email: '',
      );

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'role': role.name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'isEmailVerified': isEmailVerified,
      'assignedTasks': assignedTasks,
      'metadata': metadata,
    };
  }

  // Create from Firebase User
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
      isEmailVerified: user.emailVerified,
    );
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.name == (map['role'] ?? 'worker'),
        orElse: () => UserRole.worker,
      ),
      createdAt: map['createdAt']?.toDate(),
      lastLogin: map['lastLogin']?.toDate(),
      isEmailVerified: map['isEmailVerified'] ?? false,
      assignedTasks: List<String>.from(map['assignedTasks'] ?? []),
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isEmailVerified,
    List<String>? assignedTasks,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      assignedTasks: assignedTasks ?? this.assignedTasks,
      metadata: metadata ?? this.metadata,
    );
  }

  // For role-based UI
  String get roleName {
    switch (role) {
      case UserRole.worker:
        return 'Worker';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.client:
        return 'Client';
    }
  }

  // Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  // Check if user is worker
  bool get isWorker => role == UserRole.worker;

  // Short name for display
  String get shortName {
    if (displayName == null || displayName!.isEmpty) {
      return email.split('@').first;
    }
    final names = displayName!.split(' ');
    return names.length > 1 
        ? '${names.first[0]}${names.last[0]}' 
        : names.first.substring(0, 2);
  }

  // Check if user is empty
  bool get isEmpty => uid.isEmpty;
}