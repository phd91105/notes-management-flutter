import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:note_app/src/components/already_have_an_account_acheck.dart';
import 'package:note_app/src/components/background_login.dart';
import 'package:note_app/src/components/check_islogin.dart';
import 'package:note_app/src/components/rounded_button.dart';
import 'package:note_app/src/components/rounded_input_field.dart';
import 'package:note_app/src/components/rounded_password_field.dart';
import 'package:note_app/src/resources/login/signup.dart';
import 'package:http/http.dart' as http;
import 'package:note_app/src/model/user_model.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_app/src/resources/screens/notes_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool login = true;
  bool islogin = false;
  String _email;
  String _password;

  Future<UserModel> loginUser() async {
    var response = await http
        .post(
      'https://api-mobile-app.herokuapp.com/api/signin',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': _email,
        'password': _password,
      }),
    )
        .catchError((e) {
      throw (e);
    });
    print(response.body);

    if (response.statusCode == 200) {
      showToast("Login succesful");
      setState(() {
        // islogin = true;
      });
      return userModelFromJson(response.body);
    } else {
      setState(() {
        // islogin = false;
      });
      showToast(jsonDecode(response.body)['error'] ?? "Something went wrong");
      return null;
    }
  }

  showToast(String msg) {
    Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login1.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                _email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _password = value;
              },
            ),
            RoundedButton(
              text: "LOG IN",
              press: loginUser,
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUp();
                    },
                  ),
                );
              },
            ),
            // CheckLogin(
            //   // islogin: false,
            //   press: () {
            //     MaterialPageRoute(builder: (context) {
            //       return NotesScreen();
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
