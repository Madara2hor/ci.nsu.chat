import 'package:ci.nsu.chat/Helpers/app_colors.dart';
import 'package:ci.nsu.chat/Helpers/dialog_helper.dart';
import 'package:ci.nsu.chat/Services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
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
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                  onTap: () async {
                    await context
                        .read<AuthenticationService>()
                        .googleSignIn()
                        .then((user) => {
                              if (user == null)
                                {
                                  DialogHelper.warning(
                                      context,
                                      DialogContent(
                                        text:
                                            'Для входа в чат нужен аккаунта колледжа.',
                                        title: 'Попался!',
                                      ))
                                }
                            });
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
                                    image:
                                        AssetImage('assets/icons/google.png')),
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
                    onTap: () async {
                      return await DialogHelper.resetPassword(
                          context,
                          DialogContent(
                            text:
                                'Для восстановления пароля тебе придется топать к администратору.',
                            title: 'Ну что ж ты так?',
                          ));
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
      ),
    );
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
