import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';

class SideBarLayoutModel extends BaseModel {
  String _currentPage = RouteName.chatRoomsRoute;

  String get currentPage => _currentPage;

  void goTo(String newPage) {
    setState(ViewState.Busy);

    if (_currentPage == newPage) {
      print('$currentPage don\'t changed');
      setState(ViewState.Idle);
      return;
    }
    print('$currentPage changed on $newPage');

    _currentPage = newPage;
    setState(ViewState.Idle);
  }
}
