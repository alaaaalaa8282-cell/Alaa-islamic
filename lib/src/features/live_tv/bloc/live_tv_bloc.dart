import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/network_client.dart';
import '../model/live_tv_channel.dart';

part 'live_tv_event.dart';
part 'live_tv_state.dart';

class LiveTvBloc extends Bloc<LiveTvEvent, LiveTvState> {
  LiveTvBloc() : super(const LiveTvState.initial()) {
    on<LiveTvEvent>((event, emit) async {
      if (event is FetchLiveTvChannels) {
        emit(const LiveTvState.loading());

        final connectivity = await Connectivity().checkConnectivity();
        if (connectivity == ConnectivityResult.none) {
          emit(
            LiveTvState.failed(
              LocalFailure(message: 'No internet connection.', error: 0),
            ),
          );
          return;
        }

        try {
          final client = NetworkClient('https://www.mp3quran.net');
          final resp = await client.get('/api/v3/live-tv', {});

          final data = resp.data;
          final rawList = (data is Map && data['livetv'] is List)
              ? (data['livetv'] as List)
              : const [];

          final channels = rawList
              .whereType<Map>()
              .map((e) => LiveTvChannel.fromJson(e.cast<String, dynamic>()))
              .where((c) => c.url.isNotEmpty)
              .toList(growable: false);

          emit(LiveTvState.loaded(channels));
        } catch (_) {
          emit(
            LiveTvState.failed(
              RemoteFailure(
                message: 'Unable to load Live TV channels.',
                errorType: DioExceptionType.unknown,
              ),
            ),
          );
        }
      }
    });
  }
}

