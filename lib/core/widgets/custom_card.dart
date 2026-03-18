import 'package:flutter/material.dart';
import 'package:taskflow_pro/core/constants/app_constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget card = Card(
      color: color ?? theme.colorScheme.surface,
      elevation: elevation ?? 2,
      margin: margin ?? EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.borderRadiusMedium),
        side: border != null ? BorderSide.none : BorderSide.none,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.borderRadiusMedium),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppDimensions.paddingMedium),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppDimensions.borderRadiusMedium),
        child: card,
      );
    }

    return card;
  }
}
