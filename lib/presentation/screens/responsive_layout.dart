import 'package:flutter/material.dart';

class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  static double getFormWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 600;
    return 800;
  }

  static EdgeInsets getFormPadding(BuildContext context) {
    final padding = getPadding(context);
    return EdgeInsets.all(padding);
  }

  static double getFontSize(
    BuildContext context, {
    double mobile = 14,
    double tablet = 16,
    double desktop = 18,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  static double getIconSize(BuildContext context) {
    if (isMobile(context)) return 20;
    if (isTablet(context)) return 24;
    return 28;
  }

  // Method untuk responsive grid layout
  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  // Method untuk responsive card height
  static double getCardHeight(BuildContext context) {
    if (isMobile(context)) return 120;
    if (isTablet(context)) return 140;
    return 160;
  }
}

class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;
  final bool? forceRow;

  const ResponsiveRow({
    Key? key,
    required this.children,
    this.spacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.forceRow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shouldUseColumn =
        ResponsiveLayout.isMobile(context) && (forceRow == null || !forceRow!);

    if (shouldUseColumn) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children
            .asMap()
            .entries
            .map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  top: entry.key == 0 ? 0 : spacing / 2,
                  bottom: entry.key == children.length - 1 ? 0 : spacing / 2,
                ),
                child: entry.value,
              ),
            )
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .asMap()
          .entries
          .map(
            (entry) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: entry.key == 0 ? 0 : spacing / 2,
                  right: entry.key == children.length - 1 ? 0 : spacing / 2,
                ),
                child: entry.value,
              ),
            ),
          )
          .toList(),
    );
  }
}
