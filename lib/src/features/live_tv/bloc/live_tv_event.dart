part of 'live_tv_bloc.dart';

abstract class LiveTvEvent extends Equatable {
  const LiveTvEvent();
}

class FetchLiveTvChannels extends LiveTvEvent {
  const FetchLiveTvChannels();

  @override
  List<Object> get props => [];
}

