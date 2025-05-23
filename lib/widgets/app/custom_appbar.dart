// lib/widgets/custom_appbar.dart
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? leading;
  final double? titleSpacing;
  final bool automaticallyImplyLeading;
  final double toolbarHeight;
  final TextStyle? titleTextStyle;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? leadingWidth;
  final IconData? backIcon;
  final Color? backIconColor;
  final Color? iconThemeColor;
  final bool showDivider;

  const CustomAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.actions,
    this.onBackPressed,
    this.backgroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.leading,
    this.titleSpacing,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = kToolbarHeight,
    this.titleTextStyle,
    this.flexibleSpace,
    this.bottom,
    this.leadingWidth,
    this.backIcon = Icons.arrow_back_ios_new,
    this.backIconColor,
    this.iconThemeColor,
    this.showDivider = false,
  })  : assert(title == null || titleWidget == null,
            'Cannot provide both a title and a titleWidget'),
        super(key: key);

  // Primary AppBar with title
  const CustomAppBar.primary({
    Key? key,
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) : this(
          key: key,
          title: title,
          actions: actions,
          showBackButton: showBackButton,
          onBackPressed: onBackPressed,
          backgroundColor: AppColors.primary,
          titleTextStyle: AppTextStyles.appBarTitle,
          backIconColor: AppColors.onPrimary,
          iconThemeColor: AppColors.onPrimary,
        );

  // Transparent AppBar
  const CustomAppBar.transparent({
    Key? key,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) : this(
          key: key,
          title: title,
          titleWidget: titleWidget,
          actions: actions,
          showBackButton: showBackButton,
          onBackPressed: onBackPressed,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );

  // AppBar with gradient background
  CustomAppBar.gradient({
    Key? key,
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
  }) : this(
          key: key,
          title: title,
          actions: actions,
          showBackButton: showBackButton,
          onBackPressed: onBackPressed,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          titleTextStyle: AppTextStyles.appBarTitle,
          backIconColor: AppColors.onPrimary,
          iconThemeColor: AppColors.onPrimary,
        );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: titleTextStyle ?? AppTextStyles.appBarTitle,
                )
              : null),
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(
                    backIcon,
                    size: 20,
                  ),
                  color: backIconColor,
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      leadingWidth: leadingWidth,
      titleSpacing: titleSpacing,
      iconTheme: IconThemeData(
        color: iconThemeColor ?? Theme.of(context).iconTheme.color,
      ),
      shape: showDivider
          ? Border(
              bottom: BorderSide(
                color: AppColors.divider,
                width: 1,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0),
      );
}