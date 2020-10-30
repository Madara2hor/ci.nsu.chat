import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/viewmodels/base_model.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';

class SideBarLayoutModel extends BaseModel {
  String _initialPage = RouteName.chatListRoute;
  String _currentPage;

  SideBarLayoutModel() {
    _currentPage == null
        ? _currentPage = _initialPage
        : _currentPage = _currentPage;
  }

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
