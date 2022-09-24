import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monkey_finances/screens/login.dart';
import 'package:monkey_finances/utilities/constants.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Widget _monkey_image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('logo.png', width: 200.0, height: 200.0),
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
          child: const TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: InputDecoration(
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

  Widget _buildBackToLogin() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.to(() => LoginScreen(),
              transition: Transition.leftToRight,
              duration: const Duration(milliseconds: 350));
        },
        child: const Text(
          'Voltar ao Login',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildSendEmailBtn() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => LoginScreen(),
                transition: Transition.leftToRight,
                duration: const Duration(milliseconds: 350));
          },
          style: styledButtonLogin,
          child: const Text(
            'ENVIAR',
            style: TextStyle(
                color: Color(0xFF263238),
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
        ));
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
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _monkey_image(),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Insira o seu email e enviaremos uma nova senha de acesso.',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _buildEmailTF(),
                      _buildBackToLogin(),
                      _buildSendEmailBtn()
                    ])),
          ),
        ],
      ),
    ));
  }
}
