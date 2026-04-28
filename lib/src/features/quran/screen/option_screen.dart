import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/util/constants.dart';
import '../../utils/custom_switch.dart';
import '../../utils/bottom_sheet_select.dart';
import '../audio/quran_audio_catalog.dart';
import '../bloc/quran_theme/quran_theme_bloc.dart';

const List<String> _quranTypes = ['Normal', 'QCF'];
const List<String> _translationModes = [
  'Urdu',
  'English (Saheeh)',
  'English (Clear Quran)',
  'Turkish (Saheeh)',
  'Malayalam (Abdul Hameed)',
  'Persian (Hussein Dari)',
  'French (Hamidullah)',
  'Italian (Piccardo)',
  'Dutch (Siregar)',
  'Portuguese',
  'Russian (Kuliev)',
  'Bengali',
  'Indonesian',
  'Chinese',
  'Spanish',
  'Swedish',
];
const List<String> _normalQuranFonts = ['Uthman', 'arsura'];
const List<String> _qcfScrollDirections = ['Vertical', 'Horizontal'];
const List<String> _translationGoogleFonts = [
  'Poppins',
  'Roboto',
  'Noto Sans',
  'Lato',
  'Montserrat',
];
List<String> get _audioEditionIds => quranAudios.map((e) => e.id).toList();

class OptionScreen extends StatelessWidget {
  const OptionScreen();

  List<Widget> _buildSettingsItems(QuranThemeState state) {
    final items = <Widget>[
      const QuranTypeOption(),
      if (state.quranType == 'QCF') const QcfScrollDirectionOption(),
      const ShowTranslationOption(),
      const TranslationMode(),
      const AudioEditionOption(),
      if (state.quranType != 'QCF') const QuranFontSize(),
      if (state.quranType != 'QCF') const QuranFontFamily(),
      const TranslationFontSize(),
      const TranslationFontFamily(),
    ];

    final separated = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      separated.add(items[i]);
      if (i != items.length - 1) {
        separated.add(const Divider());
      }
    }
    return separated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quran Styling Option',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: kPagePadding,
            child: BlocBuilder<QuranThemeBloc, QuranThemeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    ..._buildSettingsItems(state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AudioEditionOption extends StatelessWidget {
  const AudioEditionOption();

  String _humanType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'versebyverse':
        return 'Verse by verse';
      case 'translation':
        return 'Translation';
      default:
        if (type.isEmpty) return '';
        return type[0].toUpperCase() + type.substring(1);
    }
  }

  String _humanLanguage(String language) {
    switch (language.trim().toLowerCase()) {
      case 'ar':
        return 'Arabic';
      case 'en':
        return 'English';
      case 'ur':
        return 'Urdu';
      case 'fa':
        return 'Persian';
      case 'fr':
        return 'French';
      case 'ru':
        return 'Russian';
      case 'zh':
        return 'Chinese';
      default:
        return language.isEmpty ? '' : language.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        final ids = _audioEditionIds;
        final fallbackId = ids.isNotEmpty ? ids.first : state.audioEdition;
        final value = ids.contains(state.audioEdition) ? state.audioEdition : fallbackId;

        QuranAudioOption? optionFor(String id) => findQuranAudioById(id);

        String selectedLabel(String id) {
          final a = optionFor(id);
          if (a == null) return id;
          return '${a.englishName} • ${a.quality} kbps';
        }

        Widget tileBuilder(BuildContext context, String id, bool isSelected) {
          final theme = Theme.of(context);
          final a = optionFor(id);
          if (a == null) {
            return Text(
              id,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: isSelected ? theme.primaryColor : null,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            );
          }

          final titleStyle = theme.textTheme.bodyMedium!.copyWith(
            color: isSelected ? theme.primaryColor : null,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          );
          final subtitleStyle = theme.textTheme.bodySmall!.copyWith(
            color: (isSelected ? theme.primaryColor : theme.hintColor)
                .withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(a.englishName, style: titleStyle),
              SizedBox(height: 4.h),
              Text(
                a.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: subtitleStyle,
              ),
              SizedBox(height: 4.h),
              Text(
                'Type: ${_humanType(a.type)} • Language: ${_humanLanguage(a.language)} • Quality: ${a.quality} kbps',
                style: subtitleStyle,
              ),
            ],
          );
        }

        return BottomSheetSelect<String>(
          label: 'Audio reciter',
          value: value,
          options: ids,
          selectedLabelBuilder: selectedLabel,
          optionBuilder: tileBuilder,
          onChanged: (edition) {
            BlocProvider.of<QuranThemeBloc>(context).add(SetAudioEdition(edition));
          },
        );
      },
    );
  }
}

class ShowTranslationOption extends StatelessWidget {
  const ShowTranslationOption();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Show translation',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).primaryColor),
          ),
          BlocBuilder<QuranThemeBloc, QuranThemeState>(
            builder: (context, state) {
              return CustomSwitch(
                  value: state.showTranslation,
                  onChanged: (val) {
                    BlocProvider.of<QuranThemeBloc>(context).add(
                      ShowTranslation(val),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}

class TranslationMode extends StatelessWidget {
  const TranslationMode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        return BottomSheetSelect<String>(
          label: 'Translation mode',
          value: state.translationMode,
          options: _translationModes,
          onChanged: (value) {
            BlocProvider.of<QuranThemeBloc>(context)
                .add(SwitchTranslationMode(value));
          },
        );
      },
    );
  }
}

class QuranFontSize extends StatelessWidget {
  const QuranFontSize();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        if (state.quranType == 'QCF') {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Quran font size',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (BlocProvider.of<QuranThemeBloc>(context)
                          .state
                          .quranFontSize >
                      1) {
                    BlocProvider.of<QuranThemeBloc>(context)
                        .add(ReduceQuranFontSize());
                  }
                },
                child: SvgPicture.asset(
                  'assets/images/quran_icon/svg/minus.svg',
                  color: Theme.of(context).primaryColor,
                  width: 24.w,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '${state.quranFontSize}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                width: 8.w,
              ),
              GestureDetector(
                onTap: () {
                  BlocProvider.of<QuranThemeBloc>(context)
                      .add(AddQuranFontSize());
                },
                child: SvgPicture.asset(
                  'assets/images/quran_icon/svg/add.svg',
                  color: Theme.of(context).primaryColor,
                  width: 24.w,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class QuranFontFamily extends StatelessWidget {
  const QuranFontFamily();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        if (state.quranType == 'QCF') {
          return const SizedBox.shrink();
        }

        return BottomSheetSelect<String>(
          label: 'Quran font family',
          value: state.quranFontFamily,
          options: _normalQuranFonts,
          onChanged: (value) {
            BlocProvider.of<QuranThemeBloc>(context)
                .add(SetQuranFontFamily(value));
          },
        );
      },
    );
  }
}

class TranslationFontSize extends StatelessWidget {
  const TranslationFontSize();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Translation font size',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (BlocProvider.of<QuranThemeBloc>(context)
                      .state
                      .translationFontSize >
                  1)
                BlocProvider.of<QuranThemeBloc>(context)
                    .add(ReduceTranslationFontSize());
            },
            child: SvgPicture.asset(
              'assets/images/quran_icon/svg/minus.svg',
              color: Theme.of(context).primaryColor,
              width: 24.w,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          BlocBuilder<QuranThemeBloc, QuranThemeState>(
            builder: (context, state) {
              return Text(
                '${state.translationFontSize}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              );
            },
          ),
          SizedBox(
            width: 8.w,
          ),
          GestureDetector(
            onTap: () {
              BlocProvider.of<QuranThemeBloc>(context)
                  .add(AddTranslationFontSize());
            },
            child: SvgPicture.asset(
              'assets/images/quran_icon/svg/add.svg',
              color: Theme.of(context).primaryColor,
              width: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}

class TranslationFontFamily extends StatelessWidget {
  const TranslationFontFamily();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        final bool isUrdu = state.translationMode == 'Urdu';
        final options = isUrdu ? const ['Jameel'] : _translationGoogleFonts;

        final selectedValue = options.contains(state.translationFontFamily)
            ? state.translationFontFamily
            : options.first;

        return BottomSheetSelect<String>(
          label: 'Translation font family',
          value: selectedValue,
          options: options,
          onChanged: (value) {
            BlocProvider.of<QuranThemeBloc>(context)
                .add(SetTranslationFontFamily(value));
          },
        );
      },
    );
  }
}

class QuranTypeOption extends StatelessWidget {
  const QuranTypeOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        return BottomSheetSelect<String>(
          label: 'Quran type',
          value: state.quranType,
          options: _quranTypes,
          onChanged: (value) {
            BlocProvider.of<QuranThemeBloc>(context).add(SetQuranType(value));
          },
        );
      },
    );
  }
}

class QcfScrollDirectionOption extends StatelessWidget {
  const QcfScrollDirectionOption();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranThemeBloc, QuranThemeState>(
      builder: (context, state) {
        if (state.quranType != 'QCF') {
          return const SizedBox.shrink();
        }

        return BottomSheetSelect<String>(
          label: 'QCF scroll direction',
          value: state.qcfScrollDirection,
          options: _qcfScrollDirections,
          onChanged: (value) {
            BlocProvider.of<QuranThemeBloc>(context)
                .add(SetQcfScrollDirection(value));
          },
        );
      },
    );
  }
}
