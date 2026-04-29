import 'package:pr/features/modules/domain/entities/module.dart';
import 'package:pr/features/modules/domain/repositories/module_repository.dart';

class GetModules {
  final ModuleRepository _r;
  GetModules(this._r);
  Future<List<Module>> call(String courseId) => _r.getModules(courseId);
}
