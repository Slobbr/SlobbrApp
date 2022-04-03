import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_quickstart/components/auth_state.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_quickstart/utils/constants.dart';
import 'package:supabase_quickstart/utils/textFieldFormatters.dart';

import '../../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends AuthState<LoginScreen> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();

  late String _email;
  late String _error;
  late bool _autoValidate = false;
  late bool _isButtonDisabled = false;
  late bool _obscureText = true;
  late bool _isEnabled = true;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signIn(email: _emailController.text, password: _passwordController.text);
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      _emailController.clear();
      _passwordController.clear();
      Navigator.pushNamed(context, '/tabs');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.primaryWhiteSmoke,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: primaryContainer(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 100.0),
                child: Text(
                  "Login met je Slobbraccount",
                  style: boldFont(MColors.textDark, 38.0),
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(height: 20.0),

              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      "Heb je geen account?",
                      style: normalFont(MColors.textGrey, 16.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      child: Text(
                        " Registreer je nu!",
                        style: boldFont(MColors.primaryPurple, 16.0),
                        textAlign: TextAlign.start,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    )
                  ),
                ]
              ),


              SizedBox(height: 20.0),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "E-mail",
                  style: normalFont(MColors.textGrey, null),
                ),
              ),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelStyle: normalFont(null, 14.0),
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  fillColor: MColors.primaryWhite,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: 0.50 == 0.0 ? Colors.transparent : MColors.textGrey,
                      width: 0.50,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: MColors.primaryPurple,
                      width: 1.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Wachtwoord",
                  style: normalFont(MColors.textGrey, null),
                ),
              ),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelStyle: normalFont(null, 14.0),
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
                  fillColor: MColors.primaryWhite,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: 0.50 == 0.0 ? Colors.transparent : MColors.textGrey,
                      width: 0.50,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: MColors.primaryPurple,
                      width: 1.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              primaryButtonPurple(
                Text(
                  "Login",
                  style: boldFont(MColors.primaryWhite, 16.0),
                ),
                () {
                  _signIn();
                },
              )
            ],
          )
        )
      )
    );
  }

}
