import 'package:flutter/material.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_player_models.dart';
import 'package:tadrib_hub/presentation/Screens/lesson_screen/video_player/video_utils.dart';

class VideoSettingsMenu extends StatefulWidget {
  final VideoSpeed currentSpeed;
  final VideoQuality currentQuality;
  final Function(VideoSpeed) onSpeedChange;
  final Function(VideoQuality) onQualityChange;
  final VoidCallback onDownload;
  final VoidCallback onClose;
  final bool isFullscreen;
  final String videoTitle;

  const VideoSettingsMenu({
    Key? key,
    required this.currentSpeed,
    required this.currentQuality,
    required this.onSpeedChange,
    required this.onQualityChange,
    required this.onDownload,
    required this.onClose,
    required this.videoTitle,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  State<VideoSettingsMenu> createState() => _VideoSettingsMenuState();
}

class _VideoSettingsMenuState extends State<VideoSettingsMenu> {
  bool _showSpeedOptions = false;
  bool _showQualityOptions = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isFullscreen ? 280 : 240,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          _buildHeader(),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Download Option
                  _buildDownloadOption(),

                  const Divider(color: Colors.white24, height: 1),

                  // Speed Section
                  _buildSpeedSection(),

                  const Divider(color: Colors.white24, height: 1),

                  // Quality Section
                  _buildQualitySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.settings,
            color: Colors.white,
            size: widget.isFullscreen ? 20 : 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'إعدادات الفيديو',
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.isFullscreen ? 16 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Icon(
              Icons.close,
              color: Colors.white70,
              size: widget.isFullscreen ? 20 : 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadOption() {
    return InkWell(
      onTap: () {
        VideoUtils.showDownloadDialog(
          context,
          onDownload: () {
            // إغلاق قائمة الإعدادات بعد التحميل
            widget.onClose();
            // تنفيذ التحميل
            widget.onDownload();
          },
          videoTitle: widget.videoTitle,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.download,
              color: Colors.white,
              size: widget.isFullscreen ? 20 : 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تحميل الفيديو',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.isFullscreen ? 14 : 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'حفظ في المعرض',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: widget.isFullscreen ? 12 : 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: widget.isFullscreen ? 14 : 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedSection() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showSpeedOptions = !_showSpeedOptions;
              if (_showSpeedOptions) {
                _showQualityOptions = false;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.speed,
                  color: Colors.white,
                  size: widget.isFullscreen ? 20 : 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سرعة التشغيل',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.isFullscreen ? 14 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.currentSpeed.displayName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: widget.isFullscreen ? 12 : 11,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _showSpeedOptions ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white54,
                    size: widget.isFullscreen ? 20 : 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showSpeedOptions ? null : 0,
          child: _showSpeedOptions
              ? Container(
            color: Colors.black.withOpacity(0.2),
            child: Column(
              children: VideoSpeed.values.map((speed) {
                return InkWell(
                  onTap: () {
                    widget.onSpeedChange(speed);
                    setState(() {
                      _showSpeedOptions = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            speed.displayName,
                            style: TextStyle(
                              color: widget.currentSpeed == speed
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: widget.isFullscreen ? 14 : 13,
                              fontWeight: widget.currentSpeed == speed
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (widget.currentSpeed == speed)
                          Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: widget.isFullscreen ? 16 : 14,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildQualitySection() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showQualityOptions = !_showQualityOptions;
              if (_showQualityOptions) {
                _showSpeedOptions = false;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  Icons.high_quality,
                  color: Colors.white,
                  size: widget.isFullscreen ? 20 : 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'جودة الفيديو',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.isFullscreen ? 14 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.currentQuality.displayName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: widget.isFullscreen ? 12 : 11,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _showQualityOptions ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white54,
                    size: widget.isFullscreen ? 20 : 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showQualityOptions ? null : 0,
          child: _showQualityOptions
              ? Container(
            color: Colors.black.withOpacity(0.2),
            child: Column(
              children: VideoQuality.values.map((quality) {
                return InkWell(
                  onTap: () {
                    widget.onQualityChange(quality);
                    setState(() {
                      _showQualityOptions = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            quality.displayName,
                            style: TextStyle(
                              color: widget.currentQuality == quality
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: widget.isFullscreen ? 14 : 13,
                              fontWeight: widget.currentQuality == quality
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (widget.currentQuality == quality)
                          Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: widget.isFullscreen ? 16 : 14,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}