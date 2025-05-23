// lib/utils/colors.dart
import 'package:flutter/material.dart';

// 1. App Color Palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6200EE);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);

  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color danger = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Additional Colors
  static const Color accent = Color(0xFF536DFE);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFEEEEEE);

  static var textSecondary;
}

// 2. Dark Theme Colors
class DarkColors {
  static const Color primary = Color(0xFFBB86FC);
  static const Color primaryVariant = Color(0xFF3700B3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color error = Color(0xFFCF6679);
  static const Color onPrimary = Color(0xFF000000);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onError = Color(0xFF000000);
}

// 3. Material Color Schemes
class AppColorSchemes {
  static final ColorScheme lightScheme = ColorScheme(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    background: AppColors.background,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.onSurface,
    onBackground: AppColors.onBackground,
    onError: AppColors.onError,
    brightness: Brightness.light,
  );

  static final ColorScheme darkScheme = ColorScheme(
    primary: DarkColors.primary,
    secondary: DarkColors.secondary,
    surface: DarkColors.surface,
    background: DarkColors.background,
    error: DarkColors.error,
    onPrimary: DarkColors.onPrimary,
    onSecondary: DarkColors.onSecondary,
    onSurface: DarkColors.onSurface,
    onBackground: DarkColors.onBackground,
    onError: DarkColors.onError,
    brightness: Brightness.dark,
  );
}

// 4. Theme Extensions
class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final Color success;
  final Color warning;
  final Color danger;
  final Color info;
  final Color accent;
  final Color disabled;

  const AppThemeExtensions({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.accent,
    required this.disabled,
  });

  @override
  ThemeExtension<AppThemeExtensions> copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? accent,
    Color? disabled,
  }) {
    return AppThemeExtensions(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      accent: accent ?? this.accent,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  ThemeExtension<AppThemeExtensions> lerp(
    ThemeExtension<AppThemeExtensions>? other,
    double t,
  ) {
    if (other is! AppThemeExtensions) {
      return this;
    }
    return AppThemeExtensions(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      info: Color.lerp(info, other.info, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
    );
  }

  static const light = AppThemeExtensions(
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    info: AppColors.info,
    accent: AppColors.accent,
    disabled: AppColors.disabled,
  );

  static const dark = AppThemeExtensions(
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFA726),
    danger: Color(0xFFEF5350),
    info: Color(0xFF42A5F5),
    accent: Color(0xFF7C4DFF),
    disabled: Color(0xFF757575),
  );
}

// 5. Helper Functions
class ColorUtils {
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity.clamp(0.0, 1.0));
  }
}