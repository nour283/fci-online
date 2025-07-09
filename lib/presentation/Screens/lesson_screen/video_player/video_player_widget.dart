// widgets/video_player_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/fullscreen_video_player.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_player_models.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_utils.dart';
import 'package:video_player/video_player.dart';
import 'volume_slider_widget.dart';
import 'video_settings_menu.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController? videoController;
  final bool isVideoInitialized;
  final bool isVideoLoading;
  final AnimationController playButtonController;
  final VoidCallback onPlayPause;
  final String videoTitle;

  const VideoPlayerWidget({
    Key? key,
    required this.videoController,
    required this.isVideoInitialized,
    required this.isVideoLoading,
    required this.playButtonController,
    required this.onPlayPause,
    this.videoTitle = "فيديو",
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerState _playerState = const VideoPlayerState();

  @override
  void initState() {
    super.initState();
    if (widget.videoController != null) {
      _playerState = _playerState.copyWith(
        volume: widget.videoController!.value.volume,
        isPlaying: widget.videoController!.value.isPlaying,
      );
    }
  }

  void _updatePlayerState(VideoPlayerState newState) {
    setState(() {
      _playerState = newState;
    });
  }

  void _toggleVolumeSlider() {
    _updatePlayerState(_playerState.copyWith(
      showVolumeSlider: !_playerState.showVolumeSlider,
      showSettingsMenu: false,
    ));
    if (_playerState.showVolumeSlider) {
      _hideOverlaysAfterDelay();
    }
  }

  void _toggleSettingsMenu() {
    _updatePlayerState(_playerState.copyWith(
      showSettingsMenu: !_playerState.showSettingsMenu,
      showVolumeSlider: false,
    ));
    // لا نخفي القائمة تلقائياً، بل نتركها مفتوحة حتى يغلقها المستخدم
  }

  void _closeSettingsMenu() {
    _updatePlayerState(_playerState.copyWith(
      showSettingsMenu: false,
    ));
  }

  void _hideOverlaysAfterDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _updatePlayerState(_playerState.copyWith(
          showVolumeSlider: false,
          // لا نخفي قائمة الإعدادات تلقائياً
        ));
      }
    });
  }

  void _changeVolume(double value) {
    _updatePlayerState(_playerState.copyWith(
      volume: value,
      isMuted: value == 0.0,
    ));
    widget.videoController?.setVolume(value);
  }

  void _toggleMute() {
    final newMuted = !_playerState.isMuted;
    _updatePlayerState(_playerState.copyWith(
      isMuted: newMuted,
    ));
    widget.videoController?.setVolume(newMuted ? 0.0 : _playerState.volume);
    HapticFeedback.lightImpact();
  }

  void _changeSpeed(VideoSpeed speed) {
    _updatePlayerState(_playerState.copyWith(playbackSpeed: speed));
    widget.videoController?.setPlaybackSpeed(speed.value);
    HapticFeedback.lightImpact();
  }

  void _changeQuality(VideoQuality quality) {
    _updatePlayerState(_playerState.copyWith(quality: quality));
    // Implementation for quality change would go here
    HapticFeedback.lightImpact();
  }

  void _downloadVideo() {
    // Implementation for video download would go here
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('بدء تحميل الفيديو...')),
    );
  }

  void _enterFullScreen(BuildContext context) {
    if (widget.videoController != null && widget.videoController!.value.isInitialized) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullScreenVideoPlayer(
            videoController: widget.videoController!,
            videoTitle: widget.videoTitle,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isVideoLoading) {
      return _buildLoadingContainer();
    }

    if (!widget.isVideoInitialized || widget.videoController == null) {
      return _buildEmptyContainer();
    }

    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Video Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: AspectRatio(
                  aspectRatio: widget.videoController!.value.aspectRatio,
                  child: VideoPlayer(widget.videoController!),
                ),
              ),
            ),

            // Play Button
            _buildPlayButton(),

            // Volume Slider
            if (_playerState.showVolumeSlider)
              Positioned(
                right: 60,
                bottom: 80,
                child: VolumeSliderWidget(
                  volume: _playerState.volume,
                  isMuted: _playerState.isMuted,
                  onVolumeChange: _changeVolume,
                  onMuteToggle: _toggleMute,
                ),
              ),

            // Settings Menu
            if (_playerState.showSettingsMenu)
              Positioned(
                right: 20,
                bottom: 80,
                child: VideoSettingsMenu(
                  currentSpeed: _playerState.playbackSpeed,
                  currentQuality: _playerState.quality,
                  onSpeedChange: _changeSpeed,
                  onQualityChange: _changeQuality,
                  onDownload: _downloadVideo,
                  onClose: _closeSettingsMenu,
                  videoTitle: widget.videoTitle,
                ),
              ),

            // Video Controls
            _buildVideoControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContainer() {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyContainer() {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.video_library_outlined,
              size: 60,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Center(
      child: GestureDetector(
        onTap: widget.onPlayPause,
        child: AnimatedBuilder(
          animation: widget.playButtonController,
          builder: (context, child) {
            return AnimatedOpacity(
              opacity: widget.videoController!.value.isPlaying ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Transform.scale(
                scale: 1.0 - (widget.playButtonController.value * 0.1),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Progress Bar
            VideoProgressIndicator(
              widget.videoController!,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white24,
              ),
            ),
            const SizedBox(height: 12),

            // Controls Row
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onPlayPause,
                  child: Icon(
                    widget.videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${VideoUtils.formatDuration(widget.videoController!.value.position)} / ${VideoUtils.formatDuration(widget.videoController!.value.duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleVolumeSlider,
                  child: Icon(
                    VideoUtils.getVolumeIcon(_playerState.volume, _playerState.isMuted),
                    color: VideoUtils.getVolumeColor(_playerState.volume, _playerState.isMuted),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleSettingsMenu,
                  child: Icon(
                    Icons.more_vert,
                    color: _playerState.showSettingsMenu ? Colors.blue : Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _enterFullScreen(context),
                  child: const Icon(Icons.fullscreen, color: Colors.white, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}