import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/util/constants.dart';
import 'ayat_card.dart';
import 'collection_card.dart';
import 'hadees_card.dart';

class HomeSliverList extends StatelessWidget {
  const HomeSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: kPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CollectionCard(),
            SizedBox(height: 10.h),
            AyatCard(),
            SizedBox(height: 10.h),
            HadessCard(),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}
