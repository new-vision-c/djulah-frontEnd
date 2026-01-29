import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/assets.dart';
import '../../../infrastructure/theme/client_theme.dart';

class ProfilAvatar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 96.r,
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox.square(
              dimension: 96.r,
              child: Image.asset(
                Assets.avatarAvatarProfil,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomRight,
            child: Container(
              height: 31.r,
              width: 31.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(100),
                color: ClientTheme.primaryColor,
              ),
              alignment: Alignment.center,
              child: Image.asset(Assets.profilIconsEditProfilImage),
            ),
          ),
        ],
      ),
    );
  }
}