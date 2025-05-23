// lib/utils/constants.dart

/// 1. App Configuration Constants
class AppConstants {
  static const String appName = 'WorkFlow Pro';
  static const String appVersion = '1.0.0';
  static const int minPasswordLength = 8;
  static const int otpTimeoutSeconds = 60;
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
}

/// 2. Firestore Collection Names
class FirestoreCollections {
  static const String users = 'users';
  static const String tasks = 'tasks';
  static const String notifications = 'notifications';
  static const String teams = 'teams';
  static const String projects = 'projects';
  static const String activities = 'activities';
}

/// 3. Firestore Field Names
class FirestoreFields {
  // User fields
  static const String userId = 'uid';
  static const String email = 'email';
  static const String displayName = 'displayName';
  static const String photoUrl = 'photoUrl';
  static const String createdAt = 'createdAt';
  
  // Task fields
  static const String taskTitle = 'title';
  static const String taskDescription = 'description';
  static const String taskStatus = 'status';
  static const String dueDate = 'dueDate';
  static const String assignedTo = 'assignedTo';
}

/// 4. App Routes
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String tasks = '/tasks';
  static const String createTask = '/tasks/create';
  static const String taskDetail = '/tasks/detail';
  static const String notifications = '/notifications';
  static const String settings = '/settings';
  static const String forgotPassword = '/forgot-password';
}

/// 5. Asset Paths
class AssetPaths {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String placeholder = 'assets/images/placeholder.jpg';
  static const String googleLogo = 'assets/images/google_logo.png';
  
  // Icons
  static const String homeIcon = 'assets/icons/home.svg';
  static const String tasksIcon = 'assets/icons/tasks.svg';
  static const String profileIcon = 'assets/icons/profile.svg';
  
  // Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
}

/// 6. SharedPreferences Keys
class PrefKeys {
  static const String isDarkMode = 'isDarkMode';
  static const String isFirstLaunch = 'isFirstLaunch';
  static const String userData = 'userData';
  static const String fcmToken = 'fcmToken';
}

/// 7. Task Status Constants
class TaskStatus {
  static const String pending = 'pending';
  static const String inProgress = 'in-progress';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  
  static List<String> get all => [pending, inProgress, completed, cancelled];
}

/// 8. Notification Types
class NotificationTypes {
  static const String taskAssigned = 'task_assigned';
  static const String taskUpdated = 'task_updated';
  static const String systemAlert = 'system_alert';
  static const String message = 'message';
}

/// 9. Date/Time Formats
class DateFormats {
  static const String defaultFormat = 'MMM dd, yyyy';
  static const String withTime = 'MMM dd, yyyy - hh:mm a';
  static const String timeOnly = 'hh:mm a';
  static const String dayMonth = 'dd MMM';
}

/// 10. API/Service Constants
class ApiConstants {
  static const String baseUrl = 'https://api.yourservice.com/v1';
  static const String loginEndpoint = '/auth/login';
  static const String tasksEndpoint = '/tasks';
  static const int connectTimeout = 5000; // 5 seconds
  static const int receiveTimeout = 15000; // 15 seconds
}

/// 11. UI Constants
class UIConstants {
  static const double appBarHeight = 56.0;
  static const double bottomNavBarHeight = 64.0;
  static const double defaultIconSize = 24.0;
  static const double buttonHeight = 48.0;
  static const double textFieldHeight = 56.0;
}

/// 12. Validation Messages
class ValidationMessages {
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String shortPassword = 'Password must be at least 8 characters';
  static const String nameRequired = 'Name is required';
  static const String fieldRequired = 'This field is required';
}