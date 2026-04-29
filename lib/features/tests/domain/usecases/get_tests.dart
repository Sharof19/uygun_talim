import 'package:pr/features/tests/domain/entities/test_item.dart';
import 'package:pr/features/tests/domain/repositories/test_repository.dart';

class GetTests {
  final TestRepository _r;
  GetTests(this._r);
  Future<List<TestItem>> call() => _r.getTests();
}
