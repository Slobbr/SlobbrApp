import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_quickstart/components/auth_required_state.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:supabase_quickstart/utils/constants.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends AuthRequiredState<AccountPage> {
  final _usernameController = TextEditingController();
  final _websiteController = TextEditingController();
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`
  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      _usernameController.text = (data['username'] ?? '') as String;
      _websiteController.text = (data['website'] ?? '') as String;
    }
    setState(() {
      _loading = false;
    });
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final userName = _usernameController.text;
    final website = _websiteController.text;
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': userName,
      'website': website,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Successfully updated profile!');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.primaryWhiteSmoke,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: primaryContainer(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 100.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Profiel",
                  style: boldFont(MColors.textDark, 24.0),
                  textAlign: TextAlign.start,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                child: CircleAvatar(
                  backgroundImage: NetworkImage('https://www.newscientist.nl/app/uploads/ThinkstockPhotos-516446406-1080x1080.jpg'),
                  maxRadius: 50,
                )
              ),

              SizedBox(height: 10),

              Text(
                '${supabase.auth.currentUser?.email ?? ''}',
                style: boldFont(MColors.textDark, 16.0),
                textAlign: TextAlign.start,
              ),

              SizedBox(height: 24.0),

              primaryButtonPurple(
                Text(
                  "Uitloggen",
                  style: boldFont(MColors.primaryWhite, 16.0),
                ),
                    () {
                  _signOut();
                },
              )
            ],
          )
        )
      )
    );
  }
}
