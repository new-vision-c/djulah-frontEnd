import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabItem extends StatelessWidget {
  final Widget icon;
  final String label;


  const TabItem({super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: icon,
      text: label
    );
  }
}