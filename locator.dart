//auth repo
import 'package:learn_layout/repository/storage_repo.dart';

import './repository/auth_repo.dart';

//user controller
import './view_controller/user_controller.dart';

//getit
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<StorageRepo>(StorageRepo());

  locator.registerSingleton<UserController>(UserController());
}
