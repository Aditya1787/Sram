// lib/utils/styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';

/// 1. Text Styles
class AppTextStyles {
  // Display Text
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    color: AppColors.onBackground,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  // Headline Text
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  // Title Text
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.onBackground,
  );

  // Label Text
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  // Custom Text Styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );
}

/// 2. Theme Extensions
class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  final TextStyle cardTitleStyle;
  final TextStyle cardSubtitleStyle;
  final TextStyle sectionHeaderStyle;
  final TextStyle successTextStyle;
  final TextStyle warningTextStyle;

  const AppThemeExtensions({
    required this.cardTitleStyle,
    required this.cardSubtitleStyle,
    required this.sectionHeaderStyle,
    required this.successTextStyle,
    required this.warningTextStyle,
  });

  @override
  ThemeExtension<AppThemeExtensions> copyWith({
    TextStyle? cardTitleStyle,
    TextStyle? cardSubtitleStyle,
    TextStyle? sectionHeaderStyle,
    TextStyle? successTextStyle,
    TextStyle? warningTextStyle,
  }) {
    return AppThemeExtensions(
      cardTitleStyle: cardTitleStyle ?? this.cardTitleStyle,
      cardSubtitleStyle: cardSubtitleStyle ?? this.cardSubtitleStyle,
      sectionHeaderStyle: sectionHeaderStyle ?? this.sectionHeaderStyle,
      successTextStyle: successTextStyle ?? this.successTextStyle,
      warningTextStyle: warningTextStyle ?? this.warningTextStyle,
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
      cardTitleStyle: TextStyle.lerp(cardTitleStyle, other.cardTitleStyle, t)!,
      cardSubtitleStyle: TextStyle.lerp(cardSubtitleStyle, other.cardSubtitleStyle, t)!,
      sectionHeaderStyle: TextStyle.lerp(sectionHeaderStyle, other.sectionHeaderStyle, t)!,
      successTextStyle: TextStyle.lerp(successTextStyle, other.successTextStyle, t)!,
      warningTextStyle: TextStyle.lerp(warningTextStyle, other.warningTextStyle, t)!,
    );
  }

  static const light = AppThemeExtensions(
    cardTitleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onBackground,
    ),
    cardSubtitleStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.grey,
    ),
    sectionHeaderStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.primary,
      letterSpacing: 0.5,
    ),
    successTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.success,
    ),
    warningTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.warning,
    ),
  );

  static const dark = AppThemeExtensions(
    cardTitleStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: DarkColors.onBackground,
    ),
    cardSubtitleStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: DarkColors.onBackground,
    ),
    sectionHeaderStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: DarkColors.primary,
      letterSpacing: 0.5,
    ),
    successTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF66BB6A),
    ),
    warningTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFFFFA726),
    ),
  );
}

/// 3. Input Decoration Styles
class InputStyles {
  static InputDecoration primaryInputDecoration({
    required String labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      labelStyle: AppTextStyles.inputLabel,
      errorStyle: AppTextStyles.errorText,
    );
  }
}

/// 4. Button Styles
class ButtonStyles {
  static ButtonStyle primaryButton({
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.onPrimary,
      elevation: elevation ?? 2,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.buttonText,
    );
  }

  static ButtonStyle secondaryButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.primary,
      elevation: 0,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.buttonText.copyWith(
        color: AppColors.primary,
      ),
    );
  }

  static ButtonStyle textButton() {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      textStyle: AppTextStyles.linkText,
    );
  }
}

/// 5. Card Styles
class CardStyles {
  static BoxDecoration primaryCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration flatCardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppColors.lightGrey,
      width: 1,
    ),
  );
}

/// 6. App Theme
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: AppColorSchemes.lightScheme,
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeExtensions.light,
      ],
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: AppTextStyles.appBarTitle,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
      ),
      scaffoldBackgroundColor: AppColors.background,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.surface,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: AppColorSchemes.darkScheme,
      extensions: const <ThemeExtension<dynamic>>[
        AppThemeExtensions.dark,
      ],
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: DarkColors.onBackground,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: DarkColors.onBackground,
        ),
        displaySmall: AppTextStyles.displaySmall.copyWith(
          color: DarkColors.onBackground,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: DarkColors.onBackground,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: DarkColors.onBackground,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: DarkColors.onBackground,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: DarkColors.onBackground,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: DarkColors.onBackground,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: DarkColors.onBackground,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: DarkColors.onBackground,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: DarkColors.onBackground,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: DarkColors.onBackground,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: DarkColors.onBackground,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: DarkColors.onBackground,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: DarkColors.onBackground,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        titleTextStyle: AppTextStyles.appBarTitle.copyWith(
          color: DarkColors.onPrimary,
        ),
        iconTheme: const IconThemeData(color: DarkColors.onPrimary),
      ),
      scaffoldBackgroundColor: DarkColors.background,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: DarkColors.surface,
      ),
    );
  }
}