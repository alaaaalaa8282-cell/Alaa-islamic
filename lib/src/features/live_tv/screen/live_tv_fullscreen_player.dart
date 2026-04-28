import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class LiveTvFullscreenPlayer extends StatelessWidget {
  const LiveTvFullscreenPlayer({
    super.key,
    required this.channelName,
    required this.controller,
    required this.isReady,
    required this.onExitFullscreen,
  });

  final String channelName;
  final VideoPlayerController? controller;
  final bool isReady;
  final VoidCallback onExitFullscreen;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    if (c == null || !isReady) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = c.value.size;
    final hasSize = size.width > 0 && size.height > 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (hasSize)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: VideoPlayer(c),
                ),
              ),
            )
          else
            Center(child: VideoPlayer(c)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                      tooltip: 'Exit full screen',
                      onPressed: onExitFullscreen,
                    ),
                    Expanded(
                      child: Text(
                        channelName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  blurRadius: 8,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: LiveTvPlayerControls(
                  controller: c,
                  lightTheme: true,
                  showFullscreenButton: false,
                  onFullscreen: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveTvPlayerControls extends StatelessWidget {
  const LiveTvPlayerControls({
    super.key,
    required this.controller,
    this.lightTheme = false,
    this.showFullscreenButton = false,
    required this.onFullscreen,
  });

  final VideoPlayerController controller;
  final bool lightTheme;
  final bool showFullscreenButton;
  final VoidCallback onFullscreen;

  @override
  Widget build(BuildContext context) {
    final primary = lightTheme ? Colors.white : Theme.of(context).primaryColor;
    final textStyle = lightTheme
        ? Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)
        : Theme.of(context).textTheme.titleLarge;

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final isPlaying = value.isPlaying;
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                if (isPlaying) {
                  await controller.pause();
                } else {
                  await controller.play();
                }
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 44.sp,
                color: primary,
              ),
            ),
            Expanded(
              child: Text(
                isPlaying ? 'Live' : 'Paused',
                style: textStyle,
              ),
            ),
            if (showFullscreenButton)
              IconButton(
                icon: Icon(Icons.fullscreen, size: 28.sp, color: primary),
                tooltip: 'Full screen',
                onPressed: onFullscreen,
              ),
          ],
        );
      },
    );
  }
}
