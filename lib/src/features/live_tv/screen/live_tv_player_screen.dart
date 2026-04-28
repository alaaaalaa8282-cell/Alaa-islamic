import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../core/util/constants.dart';
import '../model/live_tv_channel.dart';
import 'live_tv_fullscreen_player.dart';

class LiveTvPlayerScreen extends StatefulWidget {
  const LiveTvPlayerScreen({
    super.key,
    required this.channel,
  });

  final LiveTvChannel channel;

  @override
  State<LiveTvPlayerScreen> createState() => _LiveTvPlayerScreenState();
}

class _LiveTvPlayerScreenState extends State<LiveTvPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInit = false;
  String? _error;
  bool _isFullscreen = false;
  bool _stopped = false;

  Future<void> _setFullscreen(bool full) async {
    if (full) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    if (mounted) {
      setState(() => _isFullscreen = full);
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (!mounted || _stopped) return;

    final connectivity = await Connectivity().checkConnectivity();
    if (!mounted || _stopped) return;

    if (connectivity == ConnectivityResult.none) {
      if (mounted && !_stopped) {
        setState(() {
          _error = 'No internet connection.';
        });
      }
      return;
    }

    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.channel.url),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false),
      );
      if (!mounted || _stopped) {
        await controller.dispose();
        return;
      }
      _controller = controller;
      controller = null;

      await _controller!.initialize();
      if (!mounted || _stopped) {
        await _disposeController();
        return;
      }

      await _controller!.play();
      if (!mounted || _stopped) {
        await _disposeController();
        return;
      }

      if (mounted && !_stopped) {
        setState(() {
          _isInit = true;
        });
      }
    } catch (_) {
      if (controller != null) {
        await controller.dispose();
      } else {
        await _disposeController();
      }
      if (mounted && !_stopped) {
        setState(() {
          _error = 'Unable to play this channel right now.';
        });
      }
    }
  }

  Future<void> _disposeController() async {
    final c = _controller;
    _controller = null;
    if (c == null) return;
    await c.pause();
    await c.dispose();
  }

  @override
  void dispose() {
    _stopped = true;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final c = _controller;
    _controller = null;
    c?.pause();
    c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isFullscreen,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _isFullscreen) {
          await _setFullscreen(false);
        }
      },
      child: _isFullscreen
          ? LiveTvFullscreenPlayer(
              channelName: widget.channel.name,
              controller: _controller,
              isReady: _isInit,
              onExitFullscreen: () => _setFullscreen(false),
            )
          : _buildNormalScaffold(context),
    );
  }

  Widget _buildNormalScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: kPagePadding,
          child: _error != null
              ? _ErrorState(message: _error!, onRetry: _init)
              : !_isInit || _controller == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: kCardBorderRadius,
                          child: AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        LiveTvPlayerControls(
                          controller: _controller!,
                          showFullscreenButton: true,
                          onFullscreen: () => _setFullscreen(true),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 54.sp),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
