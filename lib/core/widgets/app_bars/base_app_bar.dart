import 'package:clean_architecture_template/core/style/colors.dart';
import 'package:clean_architecture_template/core/style/paddings.dart';
import 'package:clean_architecture_template/core/util/pixel_sizer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Widget? centerWidget;
  final Color? backgroundColor;

  const BaseAppBar({
    Key? key,
    this.leftWidget,
    this.rightWidget,
    this.centerWidget,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 100,
      leading: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: CPaddings.horizontal16,
          child: leftWidget,
        ),
      ),
      actions: [
        Center(
          child: Padding(
            padding: CPaddings.horizontal16,
            child: rightWidget,
          ),
        )
      ],
      title: centerWidget,
      backgroundColor: backgroundColor ?? CColors.white,
      elevation: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size(100.w, 50.ph);
}
