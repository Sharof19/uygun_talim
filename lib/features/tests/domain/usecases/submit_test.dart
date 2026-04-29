import 'package:pr/features/tests/domain/repositories/test_repository.dart';

class SubmitTest {
  final TestRepository _r;
  SubmitTest(this._r);
  Future<Map<String, dynamic>> call(String id, Map<String, dynamic> payload) =>
      _r.submitTest(id, payload);
}
