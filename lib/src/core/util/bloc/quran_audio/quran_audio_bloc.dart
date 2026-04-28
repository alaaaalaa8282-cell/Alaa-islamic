import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'quran_audio_event.dart';
part 'quran_audio_state.dart';

class QuranAudioBloc extends HydratedBloc<QuranAudioEvent, QuranAudioState> {
  QuranAudioBloc()
      : _player = AudioPlayer(),
        super(const QuranAudioState()) {
    _init();

    on<QuranAudioEvent>((event, emit) async {
      if (event is PlayAyah) {
        await _handlePlayAyah(event, emit);
      } else if (event is ToggleAyahPlayPause) {
        await _handleToggleAyah(event, emit);
      } else if (event is PlaySurah) {
        await _handlePlaySurah(event, emit);
      } else if (event is TogglePlayPause) {
        await _handleToggle(emit);
      } else if (event is StopAudio) {
        await _handleStop(emit);
      } else if (event is ClearAudioError) {
        emit(state.copyWith(errorMessage: null));
      } else if (event is _InternalTrackChanged) {
        emit(state.copyWith(
          currentAyatId: event.currentAyatId,
          status: state.status == QuranAudioStatus.loading
              ? QuranAudioStatus.playing
              : state.status,
        ));
      } else if (event is _InternalPlayerStateChanged) {
        emit(state.copyWith(status: event.status));
      } else if (event is _InternalError) {
        emit(state.copyWith(
          status: QuranAudioStatus.error,
          errorMessage: event.message,
        ));
      }
    });
  }

  final AudioPlayer _player;
  StreamSubscription<int?>? _indexSub;
  StreamSubscription<PlayerState>? _stateSub;

  Future<void> _init() async {
    _indexSub = _player.currentIndexStream.listen((index) {
      final ayatId =
          (index != null && index >= 0 && index < state.playlistAyatIds.length)
              ? state.playlistAyatIds[index]
              : state.currentAyatId;
      if (ayatId != null) {
        add(_InternalTrackChanged(ayatId));
      }
    });

    _stateSub = _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering) {
        add(const _InternalPlayerStateChanged(QuranAudioStatus.loading));
        return;
      }

      if (playerState.processingState == ProcessingState.completed) {
        add(const _InternalPlayerStateChanged(QuranAudioStatus.stopped));
        return;
      }

      add(_InternalPlayerStateChanged(
        playerState.playing ? QuranAudioStatus.playing : QuranAudioStatus.paused,
      ));
    });
  }

  Future<bool> _hasInternet() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }

  Uri _ayahAudioUri({
    required int ayatId,
    required String edition,
    required int bitrate,
  }) {
    return Uri.parse(
      'https://cdn.islamic.network/quran/audio/$bitrate/$edition/$ayatId.mp3',
    );
  }

  Future<void> _handlePlayAyah(PlayAyah event, Emitter<QuranAudioState> emit) async {
    emit(state.copyWith(
      mode: QuranAudioMode.ayah,
      status: QuranAudioStatus.loading,
      currentAyatId: event.ayatId,
      currentSurahId: event.surahId,
      playlistAyatIds: const [],
      errorMessage: null,
    ));

    if (!await _hasInternet()) {
      emit(state.copyWith(
        status: QuranAudioStatus.error,
        errorMessage: 'No internet connection. Please try again.',
      ));
      return;
    }

    try {
      await _player.setUrl(
        _ayahAudioUri(
          ayatId: event.ayatId,
          edition: event.edition,
          bitrate: event.bitrate,
        ).toString(),
      );
      await _player.play();
    } catch (e) {
      emit(state.copyWith(
        status: QuranAudioStatus.error,
        errorMessage: 'Unable to play audio right now.',
      ));
    }
  }

  Future<void> _handleToggleAyah(
      ToggleAyahPlayPause event, Emitter<QuranAudioState> emit) async {
    final isSameAyah = state.currentAyatId == event.ayatId;
    if (isSameAyah &&
        (state.status == QuranAudioStatus.playing ||
            state.status == QuranAudioStatus.loading)) {
      await _player.pause();
      return;
    }
    if (isSameAyah && state.status == QuranAudioStatus.paused) {
      if (!await _hasInternet()) {
        emit(state.copyWith(
          status: QuranAudioStatus.error,
          errorMessage: 'No internet connection. Please try again.',
        ));
        return;
      }
      await _player.play();
      return;
    }

    add(PlayAyah(
      ayatId: event.ayatId,
      surahId: event.surahId,
      edition: event.edition,
      bitrate: event.bitrate,
    ));
  }

  Future<void> _handlePlaySurah(PlaySurah event, Emitter<QuranAudioState> emit) async {
    emit(state.copyWith(
      mode: QuranAudioMode.surah,
      status: QuranAudioStatus.loading,
      currentSurahId: event.surahId,
      playlistAyatIds: event.ayatIds,
      currentAyatId: event.ayatIds.isNotEmpty ? event.ayatIds.first : null,
      errorMessage: null,
    ));

    if (!await _hasInternet()) {
      emit(state.copyWith(
        status: QuranAudioStatus.error,
        errorMessage: 'No internet connection. Please try again.',
      ));
      return;
    }

    try {
      final sources = event.ayatIds
          .map((id) => AudioSource.uri(_ayahAudioUri(
                ayatId: id,
                edition: event.edition,
                bitrate: event.bitrate,
              )))
          .toList();
      final playlist = ConcatenatingAudioSource(children: sources);
      await _player.setAudioSource(playlist, initialIndex: 0);
      await _player.play();
    } catch (e) {
      emit(state.copyWith(
        status: QuranAudioStatus.error,
        errorMessage: 'Unable to play surah audio right now.',
      ));
    }
  }

  Future<void> _handleToggle(Emitter<QuranAudioState> emit) async {
    if (state.status == QuranAudioStatus.playing ||
        state.status == QuranAudioStatus.loading) {
      await _player.pause();
      return;
    }
    if (state.status == QuranAudioStatus.paused) {
      if (!await _hasInternet()) {
        emit(state.copyWith(
          status: QuranAudioStatus.error,
          errorMessage: 'No internet connection. Please try again.',
        ));
        return;
      }
      await _player.play();
    }
  }

  Future<void> _handleStop(Emitter<QuranAudioState> emit) async {
    try {
      await _player.stop();
    } catch (_) {}
    emit(const QuranAudioState());
  }

  @override
  Future<void> close() async {
    await _indexSub?.cancel();
    await _stateSub?.cancel();
    await _player.dispose();
    return super.close();
  }

  @override
  QuranAudioState? fromJson(Map<String, dynamic> json) {
    // Audio playback should not restore on restart.
    return const QuranAudioState();
  }

  @override
  Map<String, dynamic>? toJson(QuranAudioState state) {
    return {};
  }
}

