part of 'live_tv_bloc.dart';

class LiveTvState extends Equatable {
  final bool isLoading;
  final List<LiveTvChannel> channels;
  final Failure? failure;

  const LiveTvState._({
    required this.isLoading,
    required this.channels,
    required this.failure,
  });

  const LiveTvState.initial() : this._(isLoading: false, channels: const [], failure: null);
  const LiveTvState.loading() : this._(isLoading: true, channels: const [], failure: null);
  const LiveTvState.loaded(List<LiveTvChannel> channels)
      : this._(isLoading: false, channels: channels, failure: null);
  const LiveTvState.failed(Failure failure)
      : this._(isLoading: false, channels: const [], failure: failure);

  @override
  List<Object?> get props => [isLoading, channels, failure];
}

