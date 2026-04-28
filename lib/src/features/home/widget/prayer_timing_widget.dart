import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/util/bloc/time_format/time_format_bloc.dart';
import '../../../core/util/controller/timing_controller.dart';

class PrayerTimingWidget extends StatelessWidget {
  const PrayerTimingWidget(
      {super.key,
      required this.title,
      required this.time,
      required this.iconAsset,
      required this.selected});
  final String title;
  final String time;
  final String iconAsset;
  final bool selected;

  Widget _buildIcon(BuildContext context) {
    final tint = selected
        ? Theme.of(context).primaryColor
        : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white)
            .withValues(alpha: 0.55);

    if (iconAsset.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconAsset,
        width: 22.w,
        height: 22.w,
        colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      );
    }

    return Image.asset(
      iconAsset,
      width: 22.w,
      height: 22.w,
      color: tint,
      colorBlendMode: BlendMode.srcIn,
      filterQuality: FilterQuality.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleColor = selected
        ? Theme.of(context).primaryColor
        : (Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white)
            .withValues(alpha: 0.75);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: titleColor,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
          SizedBox(height: 6.h),
          _buildIcon(context),
          SizedBox(height: 6.h),
          BlocBuilder<TimeFormatBloc, TimeFormatState>(
            builder: (context, timeFormatState) {
              final formatted =
                  timeFormatState.is24 ? time : convertTimeTo12HourFormat(time);
              return Text(
                formatted,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: titleColor,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
