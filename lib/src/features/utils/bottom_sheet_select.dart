import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/util/constants.dart';

class BottomSheetSelect<T> extends StatelessWidget {
  const BottomSheetSelect({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.optionLabelBuilder,
    this.optionBuilder,
    this.selectedLabelBuilder,
    this.dense = false,
    this.shrinkWrapWidth = false,
  });

  final String label;
  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T value)? optionLabelBuilder;
  final Widget Function(BuildContext context, T option, bool isSelected)?
      optionBuilder;
  final String Function(T value)? selectedLabelBuilder;

  final bool dense;
  final bool shrinkWrapWidth;

  String _optionLabel(T item) => optionLabelBuilder?.call(item) ?? '$item';
  String _selectedLabel(T item) =>
      selectedLabelBuilder?.call(item) ?? _optionLabel(item);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseSelectedStyle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.primaryColor,
      fontWeight: FontWeight.w600,
    );
    final selectedTextStyle =
        dense ? baseSelectedStyle.copyWith(height: 1.15) : baseSelectedStyle;

    final outerVertical = dense ? 0.0 : 8.0.h;
    final innerPadding = dense
        ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h)
        : EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h);
    final iconGap = dense ? 6.w : 8.w;

    Widget valuePill() {
      final labelText = _selectedLabel(value);
      final maxPillTextWidth = MediaQuery.sizeOf(context).width * 0.52;

      Widget selectedValueText() {
        if (shrinkWrapWidth) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxPillTextWidth),
            child: Text(
              labelText,
              style: selectedTextStyle,
              maxLines: dense ? 2 : 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          );
        }
        return Text(
          labelText,
          style: selectedTextStyle,
          maxLines: dense ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      }

      return InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: kBottomSheetBorderRadius,
            ),
            builder: (context) {
              return _BottomSheetSelectContent<T>(
                label: label,
                value: value,
                options: options,
                optionLabelBuilder: optionLabelBuilder,
                optionBuilder: optionBuilder,
                onChanged: onChanged,
              );
            },
          );
        },
        child: Container(
          width: shrinkWrapWidth ? null : double.infinity,
          padding: innerPadding,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: theme.colorScheme.surface,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: shrinkWrapWidth ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (shrinkWrapWidth)
                selectedValueText()
              else
                Expanded(child: selectedValueText()),
              SizedBox(width: iconGap),
              SvgPicture.asset(
                'assets/images/dua_icon/svg/dropdown.svg',
                color: theme.primaryColor,
                width: dense ? 18.w : 20.w,
              ),
            ],
          ),
        ),
      );
    }

    if (shrinkWrapWidth && label.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: outerVertical),
        child: valuePill(),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: outerVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (label.isNotEmpty)
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleLarge!.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: valuePill(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSheetSelectContent<T> extends StatelessWidget {
  const _BottomSheetSelectContent({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.optionLabelBuilder,
    this.optionBuilder,
  });

  final String label;
  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final String Function(T value)? optionLabelBuilder;
  final Widget Function(BuildContext context, T option, bool isSelected)?
      optionBuilder;

  String _optionLabel(T item) => optionLabelBuilder?.call(item) ?? '$item';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedBgColor = theme.colorScheme.primary.withValues(alpha: 0.12);
    final maxHeight = MediaQuery.of(context).size.height * 0.6;
    final tileHeight = 52.h;
    final separatorHeight = 8.h;
    final listHeight = options.isEmpty
        ? 0.0
        : options.length * tileHeight + (options.length - 1) * separatorHeight;
    final effectiveListHeight = listHeight.clamp(0.0, maxHeight);
    final needsScroll = listHeight > maxHeight;

    return SafeArea(
      child: Padding(
        padding: kPagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge!.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Divider(),
            SizedBox(height: 4.h),
            SizedBox(
              height: effectiveListHeight,
              child: ListView.separated(
                physics: needsScroll
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                itemCount: options.length,
                separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == value;

                  return GestureDetector(
                    onTap: () {
                      onChanged(option);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedBgColor : null,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 1.1,
                        ),
                      ),
                      child: optionBuilder?.call(context, option, isSelected) ??
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _optionLabel(option),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: isSelected ? theme.primaryColor : null,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
