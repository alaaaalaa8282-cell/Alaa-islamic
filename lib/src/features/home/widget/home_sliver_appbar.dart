import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

import '../../../core/util/constants.dart';
import '../bloc/appbar_bloc/appbar_bloc.dart';
import 'appbar_expanded.dart';

class HomeSliverAppbar extends StatelessWidget {
  const HomeSliverAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppbarBloc, AppbarState>(
      builder: (context, state) {
        final brightness = Theme.of(context).brightness;
        final baseOverlay = brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
        final collapsedColor = Theme.of(context).scaffoldBackgroundColor;
        final overlay = baseOverlay.copyWith(
          statusBarColor:
              state.displayAppbar ? collapsedColor : Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
          statusBarBrightness: brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
        );

        return SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          systemOverlayStyle: overlay,
          centerTitle: false,
          titleSpacing: 16.w,
          title: AnimatedSwitcher(
            duration: kAnimationDuration,
            switchInCurve: kAnimationCurve,
            reverseDuration: Duration.zero,
            child: state.displayAppbar
                ? Text(
                    'Sirate Mustaqeem',
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : Text(''),
          ),
          actions: [
            if (state.displayAppbar)
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/images/home_icon/svg/noti.svg',
                    width: 24.w,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).textTheme.bodyMedium!.color!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
          ],
          toolbarHeight: 50,
          collapsedHeight: 50,
          expandedHeight: 0.30.sh,
          elevation: 0,
          pinned: true,
          floating: false,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: AppBarExpanded(),
          ),
        );
      },
    );
  }
}
