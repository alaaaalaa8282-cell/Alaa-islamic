import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Theme, Colors, BorderRadius, BoxDecoration, Divider, LinearGradient;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/sirat_card.dart';

class HadessCard extends StatelessWidget {
  const HadessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return SiratCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  CupertinoIcons.chat_bubble_2,
                  color: primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Hadees of the Day',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withValues(alpha: 0.1),
                  primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.quote_bubble,
                  color: primaryColor.withValues(alpha: 0.5),
                  size: 24.sp,
                ),
                SizedBox(height: 12.h),
                Text(
                  '"A Muslim is a brother of another Muslim, so he should not oppress him, nor should he '
                  'hand him over to an oppressor. Whoever has fulfilled the needs of his brother, Allah will '
                  'fulfil his needs; whoever has brought his (Muslim) brother out of a discomfort, Allah will bring '
                  'him out of the discomforts of the Day of Resurrection, and whoever has screened a Muslim, Allah will '
                  'screen him(of his faults) on the Day of Resurrection."',
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Divider(
                  color: primaryColor.withValues(alpha: 0.3),
                  height: 1,
                ),
                SizedBox(height: 12.h),
                Text(
                  '- Prophet Muhammad (PBUH)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Bukhari, Mazalim (Injustices), 3',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
