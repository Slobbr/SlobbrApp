import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/auth_state.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends AuthState<RegisterScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _usernameController;
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    final response = await supabase.auth.signUp(
        _emailController.text, _passwordController.text);
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      final loginResponse = await supabase.auth.signIn(
          email: _emailController.text, password: _passwordController.text);
      final loginError = loginResponse.error;

      if (loginError != null) {
        context.showErrorSnackBar(message: loginError.message);
      } else {
        final userName = _usernameController.text;
        final user = supabase.auth.currentUser;
        final updates = {
          'id': user!.id,
          'username': userName,
          'updated_at': DateTime.now().toIso8601String(),
        };
        final updateResponse = await supabase.from('profiles')
            .upsert(updates)
            .execute();
        final updateError = updateResponse.error;
        if (updateError != null) {
          context.showErrorSnackBar(message: updateError.message);
        } else {
          final cartUpdates = {
            'user_id': user!.id,
          };
          final cartResponse = await supabase.from('carts')
              .upsert(cartUpdates)
              .execute();
          final cartError = cartResponse.error;
          if (cartError != null) {
            context.showErrorSnackBar(message: cartError.message);
          } else {
            Navigator.pushNamed(context, '/tabs');
          }
        }
      }
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
    _usernameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.primaryWhiteSmoke,
      body: SingleChildScrollView(
        child: primaryContainer(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(
                  "Maak je gratis Slobbraccount",
                  style: boldFont(MColors.textDark, 38.0)
                )
              ),

              SizedBox(height: 20.0),

              Row(
                children: <Widget>[
                  Text(
                    "Heb je al een account? ",
                    style: normalFont(MColors.textGrey, 16.0),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    child: GestureDetector(
                      child: Text(
                        "Login!",
                        style: boldFont(MColors.primaryPurple, 16.0),
                        textAlign: TextAlign.start,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                ]
              ),

              SizedBox(height: 20.0),

              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  "Gebruikersnaam",
                  style: normalFont(MColors.textGrey, null),
                ),
              ),

              TextFormField(
                controller: _usernameController,
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
                  "Registreer",
                  style: boldFont(MColors.primaryWhite, 16.0),
                ),
                    () {
                  _signUp();
                },
              )
            ]
          )
        )
      )
    );
  }
}
