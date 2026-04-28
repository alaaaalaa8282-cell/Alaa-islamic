import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import '../bloc/tab/tab_bloc.dart';

class QuranTab extends StatelessWidget {
  const QuranTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, TabState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          margin: kPagePadding,
          decoration: BoxDecoration(
            borderRadius: kAppIconBorderRadius,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!state.firstTab) {
                      BlocProvider.of<TabBloc>(context)
                          .state
                          .controller
                          .animateToPage(
                            0,
                            duration: kAnimationDuration,
                            curve: kAnimationCurve,
                          );

                      BlocProvider.of<TabBloc>(context).add(ToggleTab(false));
                    }
                  },
                  child: AnimatedContainer(
                    duration: kAnimationDuration,
                    curve: kAnimationCurve,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    margin: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: state.firstTab
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: kAppIconBorderRadius,
                    ),
                    child: Center(
                      child: Text(
                        'Surah',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: state.firstTab ? Colors.white : null,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (state.firstTab) {
                      BlocProvider.of<TabBloc>(context)
                          .state
                          .controller
                          .animateToPage(
                            1,
                            duration: kAnimationDuration,
                            curve: kAnimationCurve,
                          );
                      BlocProvider.of<TabBloc>(context).add(ToggleTab(true));
                    }
                  },
                  child: AnimatedContainer(
                    duration: kAnimationDuration,
                    curve: kAnimationCurve,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    margin: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: !state.firstTab
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: kAppIconBorderRadius,
                    ),
                    child: Center(
                      child: Text(
                        'Juz',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: !state.firstTab ? Colors.white : null,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
