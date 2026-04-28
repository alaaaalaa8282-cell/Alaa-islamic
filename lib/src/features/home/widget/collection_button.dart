import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Theme, Colors, BorderRadius, BoxDecoration, showDialog;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/coming_soon_dialog.dart';
import '../model/collection.dart';

class CollectionButton extends StatelessWidget {
  const CollectionButton(this.collection, {super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () {
        if (collection.routeName == 'Coming Soon') {
          showDialog(
            context: context,
            builder: (context) => ComingSoonDialog(),
          );
          return;
        }
        if (collection.routeName != '') {
          Navigator.of(context).pushNamed(collection.routeName);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              collection.assetName,
              width: 64.w,
              // height: 32.w,
              // colorFilter: ColorFilter.mode(
              //   primaryColor,
              //   BlendMode.srcIn,
              // ),
            ),
            SizedBox(height: 6.h),
            Text(
              collection.title,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
