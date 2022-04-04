import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              "assets/images/landing2.svg",
              height: 200,
            ),
          ),
          SizedBox(height: 30.0),
          Container(
              child: Text("Welkom bij Slobbr!",
                  style: boldFont(MColors.textDark, 30.0))),
        ],
      ))),
      bottomNavigationBar: Container(
          height: 150.0,
          color: MColors.primaryWhite,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              primaryButtonPurple(
                Text("Login", style: boldFont(MColors.primaryWhite, 16.0)),
                () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              primaryButtonWhiteSmoke(
                Text("Registreren", style: boldFont(MColors.textDark, 16.0)),
                () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          )),
    );
  }
}
