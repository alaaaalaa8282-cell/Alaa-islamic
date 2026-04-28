import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة الأذان - تتحكم في تشغيل الأذان منفصل عن صوت الهاتف وعن الأذكار
class AdhanService {
  static final AdhanService _instance = AdhanService._internal();
  factory AdhanService() => _instance;
  AdhanService._internal();

  AudioPlayer? _player;
  bool _isPlaying = false;

  // أسماء الصلوات بالعربية
  static const Map<String, String> prayerNames = {
    'fajr': 'الفجر',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
  };

  // ملفات الأذان المتاحة
  static const Map<String, String> adhanVoices = {
    'adhan_nasser': 'ناصر القطامي',
    'adhan_abdulbasit': 'عبد الباسط عبد الصمد',
    'adhan_refaat': 'محمد رفعت',
    'adhan_banna': 'محمود علي البنا',
    'adhan_mustafa': 'مصطفى إسماعيل',
    'adhan_mala': 'علي بن أحمد الملا',
    'adhan_shuaisha': 'أبو العنين شعيشع',
  };

  bool get isPlaying => _isPlaying;

  /// جلب صوت أذان صلاة معينة (أو الافتراضي)
  static Future<String> getVoiceForPrayer(String prayer) async {
    final prefs = await SharedPreferences.getInstance();
    // أولاً: هل في صوت مخصص لهذه الصلاة؟
    final specific = prefs.getString('adhan_voice_$prayer');
    if (specific != null && adhanVoices.containsKey(specific)) return specific;
    // ثانياً: الصوت الافتراضي العام
    return prefs.getString('adhan_voice_default') ?? 'adhan_nasser';
  }

  static Future<void> setVoiceForPrayer(String prayer, String voiceKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhan_voice_$prayer', voiceKey);
  }

  static Future<void> setDefaultVoice(String voiceKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adhan_voice_default', voiceKey);
  }

  /// جلب حجم الأذان (منفصل عن صوت الهاتف)
  static Future<double> getAdhanVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('adhan_volume') ?? 1.0;
  }

  static Future<void> setAdhanVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('adhan_volume', volume);
  }

  /// هل الأذان مفعّل؟
  static Future<bool> isAdhanEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('adhan_enabled') ?? true;
  }

  static Future<void> setAdhanEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_enabled', enabled);
  }

  /// هل أذان صلاة معينة مفعّل؟
  static Future<bool> isPrayerAdhanEnabled(String prayer) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('adhan_enabled_$prayer') ?? true;
  }

  static Future<void> setPrayerAdhanEnabled(String prayer, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_enabled_$prayer', enabled);
  }

  /// تشغيل الأذان
  Future<void> playAdhan(String prayer) async {
    final enabled = await isAdhanEnabled();
    if (!enabled) return;

    final prayerEnabled = await isPrayerAdhanEnabled(prayer);
    if (!prayerEnabled) return;

    await stop();

    try {
      // إعداد الجلسة الصوتية - يحترم المكالمات والوسائط الأخرى
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
        androidWillPauseWhenDucked: false,
      ));

      // طلب التركيز الصوتي - لو في مكالمة يتوقف
      final activated = await session.setActive(true);
      if (!activated) return;

      final voiceKey = await getVoiceForPrayer(prayer);
      final volume = await getAdhanVolume();

      _player = AudioPlayer();
      await _player!.setVolume(volume);
      await _player!.setAsset('assets/sound/adhan/$voiceKey.mp3');

      _isPlaying = true;
      await _player!.play();

      _player!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          session.setActive(false);
        }
      });
    } catch (e) {
      _isPlaying = false;
    }
  }

  /// إيقاف الأذان
  Future<void> stop() async {
    if (_player != null) {
      await _player!.stop();
      await _player!.dispose();
      _player = null;
    }
    _isPlaying = false;
    try {
      final session = await AudioSession.instance;
      await session.setActive(false);
    } catch (_) {}
  }
}
