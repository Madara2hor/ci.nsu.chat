import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/sidebar_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/signin_model.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());

  locator.registerFactory(() => SignInModel());
  locator.registerFactory(() => SideBarModel());
}
