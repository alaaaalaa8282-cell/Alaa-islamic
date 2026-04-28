import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة أصوات الأذكار - منفصلة تماماً عن خدمة الأذان
class AzkarAudioService {
  static final AzkarAudioService _instance = AzkarAudioService._internal();
  factory AzkarAudioService() => _instance;
  AzkarAudioService._internal();

  AudioPlayer? _player;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  static Future<double> getAzkarVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('azkar_volume') ?? 1.0;
  }

  static Future<void> setAzkarVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('azkar_volume', volume);
  }

  static Future<bool> isAzkarSoundEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('azkar_sound_enabled') ?? true;
  }

  static Future<void> setAzkarSoundEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('azkar_sound_enabled', enabled);
  }

  Future<void> playNotification() async {
    final enabled = await isAzkarSoundEnabled();
    if (!enabled) return;

    await stop();
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.notificationRingtone,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
      ));

      final volume = await getAzkarVolume();
      _player = AudioPlayer();
      await _player!.setVolume(volume);
      await _player!.setAsset('assets/sound/azkar_notif.mp3');
      _isPlaying = true;
      await _player!.play();
      _player!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
        }
      });
    } catch (e) {
      _isPlaying = false;
    }
  }

  Future<void> stop() async {
    if (_player != null) {
      await _player!.stop();
      await _player!.dispose();
      _player = null;
    }
    _isPlaying = false;
  }
}
