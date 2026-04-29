import 'package:pr/core/utils/url_normalizer.dart';
import 'package:pr/features/lessons/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.id,
    required super.title,
    required super.order,
    required super.description,
    required super.videoSource,
  });
  factory LessonModel.fromMap(Map<String, dynamic> d) => LessonModel(
    id: (d['id'] ?? '').toString(),
    title: (d['title'] ?? d['name'] ?? '').toString(),
    order: _p(d['order'] ?? d['position'] ?? d['index']),
    description: (d['description'] ?? d['content'] ?? '').toString(),
    videoSource: UrlNormalizer.normalize(_extractVideo(d)),
  );
  static int _p(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static String _extractVideo(Map<String, dynamic> d) {
    for (final k in [
      'video',
      'video_url',
      'video_source',
      'video_file',
      'file',
      'url',
      'source',
      'media',
    ]) {
      final v = d[k];
      final s = _str(v);
      if (s.isNotEmpty) return s;
    }
    for (final v in d.values) {
      final s = _str(v);
      if (s.isNotEmpty &&
          (s.contains('.mp4') || s.contains('.m3u8') || s.startsWith('http'))) {
        return s;
      }
    }
    return '';
  }

  static String _str(dynamic v) {
    if (v is String) return v;
    if (v is Map<String, dynamic>) {
      for (final k in ['url', 'file', 'video', 'src', 'source']) {
        final n = v[k];
        if (n is String && n.isNotEmpty) return n;
      }
    }
    return '';
  }
}
