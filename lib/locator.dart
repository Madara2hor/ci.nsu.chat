import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:ci.nsu.chat/core/services/database_service.dart';
import 'package:ci.nsu.chat/core/viewmodels/chat_list_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/chat_room_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/users_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/sidebar_layout_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/sidebar_model.dart';
import 'package:ci.nsu.chat/core/viewmodels/signin_model.dart';

import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => DatabaseService());

  locator.registerFactory(() => SignInModel());
  locator.registerFactory(() => SideBarModel());
  locator.registerFactory(() => ChatListModel());
  locator.registerFactory(() => UsersModel());
  locator.registerFactory(() => SideBarLayoutModel());
  locator.registerFactory(() => ChatRoomModel());
}
