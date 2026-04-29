import 'package:pr/features/modules/domain/entities/module.dart';

abstract class ModuleRepository {
  Future<List<Module>> getModules(String courseId);
}
