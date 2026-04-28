import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/util/constants.dart';
import '../widget/general_card.dart';
import '../widget/social_media_card.dart';
import '../widget/user_preference_card.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 46.h),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: kAppIconBorderRadius,
                        child: SvgPicture.asset(
                          'assets/images/core/svg/app_logo.svg',
                          width: 48.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            'Configure your experience',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GeneralCard(),
            SizedBox(
              height: 10,
            ),
            UserPreferenceCard(),
            SizedBox(
              height: 10,
            ),
            SocialMediaCard(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
