import 'package:flutter/material.dart';
import '../../core/adhan/adhan_service.dart';
import '../../core/adhan/azkar_audio_service.dart';

/// شاشة التحكم في الأصوات - الأذان والأذكار منفصلين
class SoundSettingsScreen extends StatefulWidget {
  const SoundSettingsScreen({super.key});

  @override
  State<SoundSettingsScreen> createState() => _SoundSettingsScreenState();
}

class _SoundSettingsScreenState extends State<SoundSettingsScreen> {
  // الأذان
  bool _adhanEnabled = true;
  double _adhanVolume = 1.0;
  String _defaultVoice = 'adhan_nasser';
  Map<String, String> _prayerVoices = {};
  Map<String, bool> _prayerEnabled = {};

  // الأذكار
  bool _azkarSoundEnabled = true;
  double _azkarVolume = 1.0;

  final _prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final adhanEnabled = await AdhanService.isAdhanEnabled();
    final adhanVol = await AdhanService.getAdhanVolume();
    final defVoice = await AdhanService.getVoiceForPrayer('_default_');
    final azkarEnabled = await AzkarAudioService.isAzkarSoundEnabled();
    final azkarVol = await AzkarAudioService.getAzkarVolume();

    final Map<String, String> voices = {};
    final Map<String, bool> enabled = {};
    for (final p in _prayers) {
      voices[p] = await AdhanService.getVoiceForPrayer(p);
      enabled[p] = await AdhanService.isPrayerAdhanEnabled(p);
    }

    if (mounted) {
      setState(() {
        _adhanEnabled = adhanEnabled;
        _adhanVolume = adhanVol;
        _defaultVoice = defVoice;
        _azkarSoundEnabled = azkarEnabled;
        _azkarVolume = azkarVol;
        _prayerVoices = voices;
        _prayerEnabled = enabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFFFD700);
    const green = Color(0xFF1B5E20);
    const bg = Color(0xFF0D1F12);
    const surface = Color(0xFF152B1A);
    const textPrimary = Color(0xFFF1F8E9);
    const textSecondary = Color(0xFFA5D6A7);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: green,
        title: const Text(
          'إعدادات الصوت',
          style: TextStyle(
            fontFamily: 'Uthman',
            color: gold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: gold),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ========= قسم الأذان =========
          _SectionHeader(title: '🔊 إعدادات الأذان', color: gold),
          const SizedBox(height: 8),

          // تفعيل/تعطيل الأذان العام
          _SettingCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تفعيل الأذان', style: TextStyle(fontFamily: 'Uthman', fontSize: 16, color: textPrimary)),
                Switch(
                  value: _adhanEnabled,
                  onChanged: (v) async {
                    setState(() => _adhanEnabled = v);
                    await AdhanService.setAdhanEnabled(v);
                  },
                  activeColor: gold,
                  trackColor: MaterialStateProperty.resolveWith((s) =>
                    s.contains(MaterialState.selected) ? green : Colors.grey.shade800),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // حجم الأذان
          _SettingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('حجم الأذان', style: TextStyle(fontFamily: 'Uthman', fontSize: 16, color: textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.volume_up, color: gold, size: 20),
                    Expanded(
                      child: Slider(
                        value: _adhanVolume,
                        onChanged: _adhanEnabled ? (v) async {
                          setState(() => _adhanVolume = v);
                          await AdhanService.setAdhanVolume(v);
                        } : null,
                        activeColor: gold,
                        inactiveColor: Colors.grey.shade800,
                      ),
                    ),
                    Text('${(_adhanVolume * 100).round()}%',
                        style: const TextStyle(color: textSecondary, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // صوت مختلف لكل صلاة
          _SectionHeader(title: '🕌 صوت الأذان لكل صلاة', color: textSecondary),
          const SizedBox(height: 8),

          ..._prayers.map((prayer) {
            final name = AdhanService.prayerNames[prayer] ?? prayer;
            final voice = _prayerVoices[prayer] ?? _defaultVoice;
            final enabled = _prayerEnabled[prayer] ?? true;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SettingCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          value: enabled,
                          onChanged: _adhanEnabled ? (v) async {
                            setState(() => _prayerEnabled[prayer] = v);
                            await AdhanService.setPrayerAdhanEnabled(prayer, v);
                          } : null,
                          activeColor: gold,
                          trackColor: MaterialStateProperty.resolveWith((s) =>
                            s.contains(MaterialState.selected) ? green : Colors.grey.shade800),
                        ),
                        Text(
                          'صلاة $name',
                          style: const TextStyle(fontFamily: 'Uthman', fontSize: 16, color: textPrimary),
                        ),
                      ],
                    ),
                    if (enabled) ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: voice,
                        isExpanded: true,
                        dropdownColor: surface,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade700),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'Uthman', color: textPrimary, fontSize: 14),
                        items: AdhanService.adhanVoices.entries.map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value, textDirection: TextDirection.rtl),
                        )).toList(),
                        onChanged: (v) async {
                          if (v == null) return;
                          setState(() => _prayerVoices[prayer] = v);
                          await AdhanService.setVoiceForPrayer(prayer, v);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          // ========= قسم الأذكار =========
          _SectionHeader(title: '📿 إعدادات أصوات الأذكار', color: gold),
          const SizedBox(height: 8),

          _SettingCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تفعيل صوت الأذكار', style: TextStyle(fontFamily: 'Uthman', fontSize: 16, color: textPrimary)),
                Switch(
                  value: _azkarSoundEnabled,
                  onChanged: (v) async {
                    setState(() => _azkarSoundEnabled = v);
                    await AzkarAudioService.setAzkarSoundEnabled(v);
                  },
                  activeColor: gold,
                  trackColor: MaterialStateProperty.resolveWith((s) =>
                    s.contains(MaterialState.selected) ? green : Colors.grey.shade800),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _SettingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('حجم الأذكار', style: TextStyle(fontFamily: 'Uthman', fontSize: 16, color: textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.volume_up, color: gold, size: 20),
                    Expanded(
                      child: Slider(
                        value: _azkarVolume,
                        onChanged: _azkarSoundEnabled ? (v) async {
                          setState(() => _azkarVolume = v);
                          await AzkarAudioService.setAzkarVolume(v);
                        } : null,
                        activeColor: gold,
                        inactiveColor: Colors.grey.shade800,
                      ),
                    ),
                    Text('${(_azkarVolume * 100).round()}%',
                        style: const TextStyle(color: textSecondary, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ملاحظة
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade800),
            ),
            child: const Text(
              '💡 صوت الأذان وصوت الأذكار منفصلان تماماً عن بعضهما وعن إعدادات صوت الهاتف. كما أن الأذان يتوقف تلقائياً عند الرد على مكالمة.',
              style: TextStyle(fontFamily: 'Uthman', fontSize: 13, color: textSecondary, height: 1.6),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontFamily: 'Uthman', fontSize: 17, fontWeight: FontWeight.bold, color: color),
      textDirection: TextDirection.rtl,
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;
  const _SettingCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF152B1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2E5735)),
      ),
      child: child,
    );
  }
}
