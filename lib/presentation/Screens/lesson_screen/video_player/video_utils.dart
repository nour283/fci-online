// utils/video_utils.dart

import 'package:flutter/material.dart';

class VideoUtils {
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  static Color getVolumeColor(double volume, bool isMuted) {
    if (isMuted || volume == 0) {
      return Colors.red;
    } else if (volume < 0.3) {
      return Colors.orange;
    } else if (volume < 0.7) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  static IconData getVolumeIcon(double volume, bool isMuted) {
    if (isMuted || volume == 0) {
      return Icons.volume_off;
    } else if (volume < 0.3) {
      return Icons.volume_mute;
    } else if (volume < 0.7) {
      return Icons.volume_down;
    } else {
      return Icons.volume_up;
    }
  }

  static String getVolumePercentage(double volume) {
    return "${(volume * 100).round()}%";
  }

  static LinearGradient getVolumeGradient(double volume) {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
      ],
      stops: [0.0, 0.3, 0.7, 1.0],
    );
  }

  static void showDownloadDialog(BuildContext context, {
    required VoidCallback onDownload,
    required String videoTitle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.grey[900],
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة التحميل
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.download,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),

                // العنوان
                Text(
                  'تحميل الفيديو',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // اسم الفيديو
                Text(
                  videoTitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // وصف إضافي
                Text(
                  'سيتم حفظ الفيديو في معرض الصور',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // الأزرار
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onDownload();

                          // إظهار رسالة التأكيد
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.download, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'جاري تحميل: $videoTitle',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('تحميل'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}