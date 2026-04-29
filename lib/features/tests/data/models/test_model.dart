import 'package:pr/features/tests/domain/entities/test_item.dart';

class TestModel extends TestItem {
  const TestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.duration,
    required super.questionsCount,
  });
  factory TestModel.fromMap(Map<String, dynamic> d) => TestModel(
    id: (d['id'] ?? '').toString(),
    title: (d['title'] ?? d['name'] ?? d['subject'] ?? '').toString(),
    description: (d['description'] ?? '').toString(),
    duration: _p(d['duration'] ?? d['time']),
    questionsCount: _p(d['questions_count'] ?? d['questionsCount']),
  );
  static int _p(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
