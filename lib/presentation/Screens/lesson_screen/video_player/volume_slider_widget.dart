// widgets/volume_slider_widget.dart

import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_utils.dart';

class VolumeSliderWidget extends StatelessWidget {
  final double volume;
  final bool isMuted;
  final Function(double) onVolumeChange;
  final VoidCallback onMuteToggle;
  final bool isFullscreen;

  const VolumeSliderWidget({
    Key? key,
    required this.volume,
    required this.isMuted,
    required this.onVolumeChange,
    required this.onMuteToggle,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final containerWidth = isFullscreen ? 60.0 : 50.0;
    final containerHeight = isFullscreen ? 180.0 : 150.0;

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.circular(containerWidth / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Volume Percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: VideoUtils.getVolumeColor(volume, isMuted).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              VideoUtils.getVolumePercentage(volume),
              style: TextStyle(
                color: Colors.white,
                fontSize: isFullscreen ? 10 : 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Volume Icon
          GestureDetector(
            onTap: onMuteToggle,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: VideoUtils.getVolumeColor(volume, isMuted).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                VideoUtils.getVolumeIcon(volume, isMuted),
                color: VideoUtils.getVolumeColor(volume, isMuted),
                size: isFullscreen ? 20 : 16,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Volume Slider
          Expanded(
            child: Container(
              width: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: RotatedBox(
                quarterTurns: -1,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: isFullscreen ? 8 : 6,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: isFullscreen ? 14 : 12,
                    ),
                    activeTrackColor: VideoUtils.getVolumeColor(volume, isMuted),
                    inactiveTrackColor: Colors.white38,
                    thumbColor: VideoUtils.getVolumeColor(volume, isMuted),
                    overlayColor: VideoUtils.getVolumeColor(volume, isMuted).withOpacity(0.2),
                  ),
                  child: Slider(
                    value: isMuted ? 0.0 : volume,
                    onChanged: onVolumeChange,
                    min: 0.0,
                    max: 1.0,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Mute Icon
          GestureDetector(
            onTap: onMuteToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.volume_off,
                color: Colors.white54,
                size: isFullscreen ? 16 : 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}