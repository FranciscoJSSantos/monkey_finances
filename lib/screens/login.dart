import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_finances/provider/google_sign_in.dart';
import 'package:monkey_finances/utilities/constants.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'forgot_password.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool? _rememberMe = false;

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  final docUser = FirebaseFirestore.instance.collection('users');

  Future checkUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: controllerEmail.text, password: controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Widget _monkey_image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/logo.png', width: 200.0, height: 200.0),
      ],
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerEmail,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Senha',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: controllerPassword,
            obscureText: true,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Senha',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          Get.to(() => ForgotPasswordScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 350));
        },
        child: const Text(
          'Esqueceu senha ?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      alignment: Alignment.topLeft,
      child: Row(children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            value: _rememberMe,
            checkColor: Colors.blue,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                _rememberMe = value;
              });
            },
          ),
        ),
        const Text(
          'Lembrar de mim',
          style: kLabelStyle,
        )
      ]),
    );
  }

  Future openDialog(String descricao) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(descricao, textAlign: TextAlign.center),
            actions: [
              TextButton(
                onPressed: submit,
                child: const Text('Voltar'),
              )
            ],
          ));

  void submit() {
    Navigator.of(context).pop();
  }

  Widget _buildLoginBtn() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (controllerEmail.text != "" || controllerPassword.text != "") {
              checkUser();
            } else {
              openDialog("Preencha os dados corretamente");
            }
          },
          style: styledButtonLogin,
          child: const Text(
            'LOGIN',
            style: TextStyle(
                color: Color(0xFF263238),
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
        ));
  }

  Widget _buildSignInWithText() {
    return Column(
      children: const <Widget>[
        Text(
          '- OU -',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 20.0)
      ],
    );
  }

  Widget _buildSocialBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF212121)),
      onPressed: () {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin();
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(0, 2), blurRadius: 6.0)
            ],
            image:
                DecorationImage(image: AssetImage('assets/logos/google.jpg'))),
      ),
    );
  }

  // Widget _buildSocialBtnRow() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 30.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         _buildSocialBtn(() => print('Entrar com Facebook'),
  //             const AssetImage('assets/logos/facebook.jpg')),
  //         _buildSocialBtn(() => print('Entrar com Google'),
  //             const AssetImage('assets/logos/google.jpg')),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSignUpBtn() {
    return GestureDetector(
      onTap: () {
        Get.to(() => RegisterScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 350));
      },
      child: RichText(
          text: const TextSpan(
        children: [
          TextSpan(
            text: 'Não possui uma conta? ',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400),
          ),
          TextSpan(
            text: 'Inscreva-se',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xFF212121),
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _monkey_image(),
                  const SizedBox(height: 5.0),
                  _buildEmailTF(),
                  const SizedBox(height: 20.0),
                  _buildPasswordTF(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRememberMeCheckbox(),
                      _buildForgotPasswordBtn(),
                    ],
                  ),
                  _buildLoginBtn(),
                  _buildSignInWithText(),
                  _buildSocialBtn(),
                  const SizedBox(height: 20.0),
                  // _buildSocialBtnRow(),
                  _buildSignUpBtn(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
