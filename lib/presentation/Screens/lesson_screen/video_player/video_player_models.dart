// models/video_player_models.dart

enum VideoSpeed {
  x0_25(0.25, "0.25x"),
  x0_5(0.5, "0.5x"),
  x0_75(0.75, "0.75x"),
  x1_0(1.0, "عادي"),
  x1_25(1.25, "1.25x"),
  x1_5(1.5, "1.5x"),
  x1_75(1.75, "1.75x"),
  x2_0(2.0, "2x");

  const VideoSpeed(this.value, this.displayName);
  final double value;
  final String displayName;
}

enum VideoQuality {
  low(240, "240p"),
  medium(480, "480p"),
  high(720, "720p"),
  hd(1080, "1080p");

  const VideoQuality(this.height, this.displayName);
  final int height;
  final String displayName;
}

class VideoPlayerState {
  final bool isPlaying;
  final bool isMuted;
  final double volume;
  final VideoSpeed playbackSpeed;
  final VideoQuality quality;
  final Duration position;
  final Duration duration;
  final bool isBuffering;
  final bool showControls;
  final bool showVolumeSlider;
  final bool showSettingsMenu;

  const VideoPlayerState({
    this.isPlaying = false,
    this.isMuted = false,
    this.volume = 1.0,
    this.playbackSpeed = VideoSpeed.x1_0,
    this.quality = VideoQuality.high,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isBuffering = false,
    this.showControls = true,
    this.showVolumeSlider = false,
    this.showSettingsMenu = false,
  });

  VideoPlayerState copyWith({
    bool? isPlaying,
    bool? isMuted,
    double? volume,
    VideoSpeed? playbackSpeed,
    VideoQuality? quality,
    Duration? position,
    Duration? duration,
    bool? isBuffering,
    bool? showControls,
    bool? showVolumeSlider,
    bool? showSettingsMenu,
  }) {
    return VideoPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      quality: quality ?? this.quality,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isBuffering: isBuffering ?? this.isBuffering,
      showControls: showControls ?? this.showControls,
      showVolumeSlider: showVolumeSlider ?? this.showVolumeSlider,
      showSettingsMenu: showSettingsMenu ?? this.showSettingsMenu,
    );
  }
}