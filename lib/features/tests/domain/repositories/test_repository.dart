import 'package:pr/features/tests/domain/entities/test_item.dart';

abstract class TestRepository {
  Future<List<TestItem>> getTests();
  Future<Map<String, dynamic>> getTestDetail(String id);
  Future<Map<String, dynamic>> submitTest(
    String id,
    Map<String, dynamic> payload,
  );
}
