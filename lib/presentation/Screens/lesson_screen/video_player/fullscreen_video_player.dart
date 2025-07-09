// widgets/fullscreen_video_player.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_player_models.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_utils.dart';
import 'package:video_player/video_player.dart';
import 'volume_slider_widget.dart';
import 'video_settings_menu.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoController;
  final String videoTitle;

  const FullScreenVideoPlayer({
    Key? key,
    required this.videoController,
    this.videoTitle = "فيديو",
  }) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  VideoPlayerState _playerState = const VideoPlayerState();

  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _playerState = _playerState.copyWith(
      isPlaying: widget.videoController.value.isPlaying,
      volume: widget.videoController.value.volume,
      isMuted: widget.videoController.value.volume == 0.0,
    );

    // Auto-hide controls after 3 seconds
    _hideControlsAfterDelay();
  }

  @override
  void dispose() {
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Show system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _updatePlayerState(VideoPlayerState newState) {
    setState(() {
      _playerState = newState;
    });
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _updatePlayerState(_playerState.copyWith(
          showControls: false,
          showVolumeSlider: false,
          showSettingsMenu: false,
        ));
      }
    });
  }

  void _toggleControls() {
    _updatePlayerState(_playerState.copyWith(
      showControls: !_playerState.showControls,
      showVolumeSlider: false,
      showSettingsMenu: false,
    ));

    if (_playerState.showControls) {
      _hideControlsAfterDelay();
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (widget.videoController.value.isPlaying) {
        widget.videoController.pause();
      } else {
        widget.videoController.play();
      }
    });

    _updatePlayerState(_playerState.copyWith(
      isPlaying: !_playerState.isPlaying,
    ));

    HapticFeedback.lightImpact();
  }

  void _toggleVolumeSlider() {
    _updatePlayerState(_playerState.copyWith(
      showVolumeSlider: !_playerState.showVolumeSlider,
      showSettingsMenu: false,
    ));

    if (_playerState.showVolumeSlider) {
      _hideControlsAfterDelay();
    }
  }

  void _toggleSettingsMenu() {
    _updatePlayerState(_playerState.copyWith(
      showSettingsMenu: !_playerState.showSettingsMenu,
      showVolumeSlider: false,
    ));

    if (_playerState.showSettingsMenu) {
      _hideControlsAfterDelay();
    }
  }

  void _changeVolume(double value) {
    _updatePlayerState(_playerState.copyWith(
      volume: value,
      isMuted: value == 0.0,
    ));
    widget.videoController.setVolume(value);
  }

  void _toggleMute() {
    final newMuted = !_playerState.isMuted;
    _updatePlayerState(_playerState.copyWith(isMuted: newMuted));
    widget.videoController.setVolume(newMuted ? 0.0 : _playerState.volume);
    HapticFeedback.lightImpact();
  }

  void _changeSpeed(VideoSpeed speed) {
    _updatePlayerState(_playerState.copyWith(playbackSpeed: speed));
    widget.videoController.setPlaybackSpeed(speed.value);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video Player
            Center(
              child: AspectRatio(
                aspectRatio: widget.videoController.value.aspectRatio,
                child: VideoPlayer(widget.videoController),
              ),
            ),

            // Volume Slider Overlay
            if (_playerState.showVolumeSlider && _playerState.showControls)
              Positioned(
                right: 80,
                bottom: 120,
                child: VolumeSliderWidget(
                  volume: _playerState.volume,
                  isMuted: _playerState.isMuted,
                  onVolumeChange: _changeVolume,
                  onMuteToggle: _toggleMute,
                  isFullscreen: true,
                ),
              ),

// Settings Menu Overlay
            if (_playerState.showSettingsMenu && _playerState.showControls)
              Positioned(
                right: 20,
                bottom: 120,
                child: VideoSettingsMenu(
                  currentSpeed: _playerState.playbackSpeed,
                  currentQuality: _playerState.quality,
                  onSpeedChange: _changeSpeed,
                  onQualityChange: _changeQuality,
                  onDownload: _downloadVideo,
                  videoTitle: widget.videoTitle,
                  isFullscreen: true,
                  onClose: () {
                    _updatePlayerState(_playerState.copyWith(
                      showSettingsMenu: false,
                    ));
                  },
                ),
              ),

            // Controls Overlay
            if (_playerState.showControls)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    // Top Controls
                    _buildTopControls(),

                    // Center Play Button
                    _buildCenterPlayButton(),

                    // Bottom Controls
                    _buildBottomControls(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.videoTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return Center(
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: AnimatedOpacity(
          opacity: _playerState.isPlaying ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
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
              _playerState.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Bar
            VideoProgressIndicator(
              widget.videoController,
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
                  onTap: _togglePlayPause,
                  child: Icon(
                    _playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${VideoUtils.formatDuration(widget.videoController.value.position)} / ${VideoUtils.formatDuration(widget.videoController.value.duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _toggleVolumeSlider,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      VideoUtils.getVolumeIcon(_playerState.volume, _playerState.isMuted),
                      color: VideoUtils.getVolumeColor(_playerState.volume, _playerState.isMuted),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleSettingsMenu,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}