import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/sirat_card.dart';
import '../model/general_option.dart';
import 'general_option_card.dart';

class GeneralCard extends StatelessWidget {
  const GeneralCard();

  @override
  Widget build(BuildContext context) {
    return SiratCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          ...List.generate(
            generalOptions.length,
            (index) => Column(
              children: [
                if (index != 0) Divider(),
                GeneralOptionCard(
                  imagePath: generalOptions[index].imagePath,
                  onTap: generalOptions[index].onTap ??
                      () {
                        Navigator.of(context)
                            .pushNamed(generalOptions[index].routeName!);
                      },
                  title: generalOptions[index].title,
                  subtitle: generalOptions[index].subtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
