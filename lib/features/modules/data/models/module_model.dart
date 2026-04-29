import 'package:pr/features/modules/domain/entities/module.dart';

class ModuleModel extends Module {
  const ModuleModel({
    required super.id,
    required super.title,
    required super.order,
    required super.lessonsCount,
  });
  factory ModuleModel.fromMap(Map<String, dynamic> d) => ModuleModel(
    id: (d['id'] ?? '').toString(),
    title: (d['title'] ?? d['name'] ?? '').toString(),
    order: _p(d['order'] ?? d['position'] ?? d['index']),
    lessonsCount: _p(d['lessons_count'] ?? d['lesson_count'] ?? d['lessons']),
  );
  static int _p(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
