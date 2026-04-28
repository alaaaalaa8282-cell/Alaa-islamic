import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sirat_e_mustaqeem/src/core/util/controller/date_controller.dart';
import 'package:sirat_e_mustaqeem/src/features/home/widget/address_widget.dart';

import '../../../core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import '../../../core/util/bloc/theme/theme_bloc.dart';
import 'kiblat_card.dart';
import 'upcoming_prayer_text.dart';

class AppBarExpanded extends StatelessWidget {
  const AppBarExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 0.3.sh,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return SizedBox(
                width: 1.sw,
                height: 0.3.sh,
                child: SvgPicture.asset(
                  'assets/images/home_icon/svg/background.svg',
                  fit: BoxFit.cover,
                ),
                // child: Image.asset(
                //   'assets/images/quran_icon/images/background.png',
                //   fit: BoxFit.fill,
                //   width: 1.sw,
                // ),
              );
            },
          ),
          // Container(
          //   width: 1.sw,
          //   height: 0.3.sh,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [
          //         Theme.of(context).primaryColor.withValues(alpha: 0.5),
          //         Colors.transparent,
          //       ],
          //       stops: [0.2, 1],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),
          // ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const AddressWidget(),
                BlocBuilder<PrayerTimeConfigBloc, PrayerTimeConfigState>(
                  builder: (context, prayerConfig) {
                    return Text(
                      '${getIslamicDate(adjustmentDays: prayerConfig.hijriAdjustmentDays)} - ${getTodayDate()}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                    );
                  },
                ),
                Text(
                  DateFormat('hh:mm a').format(DateTime.now()),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 28.sp,
                      ),
                ),
                SizedBox(height: 6.h),
                const UpcomingPrayerText(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: KiblatCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
