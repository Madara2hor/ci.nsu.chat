import 'package:ci.nsu.chat/core/enums/viewState.dart';
import 'package:ci.nsu.chat/core/viewmodels/signin_model.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/ui/shared/dialog_helper.dart';
import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/widgets/models/dialog_content.dart';

import 'package:flutter/material.dart';

import 'base_view.dart';

class SignInView extends StatefulWidget {
  SignInView({Key key}) : super(key: key);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SignInModel>(
        builder: (context, model, child) => _buildLoginView(model));
  }

  Scaffold _buildLoginView(SignInModel model) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appHeader(),
          model.state == ViewState.Busy
              ? _circularProgressIndicator()
              : _bottomButtons(model)
        ],
      ),
    );
  }

  Widget _appHeader() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 100, 0.0, 0.0),
                child: Text(
                  'ci.nsu',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 66.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(35.0, 155.0, 0.0, 0.0),
                child: Text(
                  'chat',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 155.0, 0.0, 0.0),
                child: Text(
                  '.',
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.thirdColor),
                ),
              ),
            ],
          )),
          Container(
            child: Center(
              child: Image.asset('assets/img/programmer.png'),
            ),
          ),
        ]);
  }

  Widget _circularProgressIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _bottomButtons(SignInModel model) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                onTap: () async {
                  var isLogin = await model.login();
                  if (!isLogin) {
                    _showWrongEmailDialog();
                  } else {
                    Navigator.pushNamed(context, RouteName.sideBarRoute);
                  }
                },
                child: Container(
                    height: 50.0,
                    child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        color: AppColors.secondColor,
                        elevation: 7.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image(
                                  height: 30,
                                  width: 30,
                                  image: AssetImage('assets/icons/google.png')),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Center(
                              child: Text(
                                'Войти с помощью Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
              SizedBox(height: 15.0),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    _showResetPasswordDialog();
                  },
                  child: Text('Восстановить пароль',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        decoration: TextDecoration.underline,
                      )),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ],
    );
  }

  void _showResetPasswordDialog() {
    DialogHelper.resetPassword(
        context,
        DialogContent(
          text:
              'Для восстановления пароля тебе придется топать к администратору.',
          title: 'Ну что ж ты так?',
        ));
  }

  void _showWrongEmailDialog() {
    DialogHelper.warning(
        context,
        DialogContent(
          text: 'Для входа в чат нужен аккаунта колледжа.',
          title: 'Попался!',
        ));
  }
}
