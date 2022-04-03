import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  final _avatarController = TextEditingController();
  var _loading = false;
  final ImagePicker _picker = ImagePicker();
  File? _photo;

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
      _avatarController.text = (data['avatar_url'] ?? '') as String;
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

  Future<void> _updateAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        _cropImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: _photo!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.ratio4x3
        ]
            : [
          CropAspectRatioPreset.ratio4x3
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: MColors.primaryPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _photo = croppedFile;
      final res = await supabase.storage.from('avatars').update('${supabase.auth.currentUser!.id}.jpg', _photo!, fileOptions: FileOptions(cacheControl: '3600', upsert: false) );
      final err = res.error;

      if(err != null){
        context.showErrorSnackBar(message: err.message);
      }else {
        final photo = _photo;
        final user = supabase.auth.currentUser;
        final updates = {
          'id': user!.id,
          'avatar_url': 'https://yoepxzzytgwaodkdamsr.supabase.co/storage/v1/object/sign/avatars/${supabase.auth
              .currentUser!.id}.jpg',
          'updated_at': DateTime.now().toIso8601String(),
        };
        final response = await supabase.from('profiles')
            .upsert(updates)
            .execute();
        final error = response.error;
        if (error != null) {
          context.showErrorSnackBar(message: error.message);
        } else {
          setState(() {
            _avatarController.text = updates['avatar_url'] as String;
          });
        }
      }
    }
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
    _avatarController.dispose();
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
                child: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_avatarController.text ?? 'http://www.zooniverse.org/assets/simple-avatar.png'),
                    maxRadius: 50,
                  ),
                  onTap: () {
                    _updateAvatar();
                  },
                )
              ),

              SizedBox(height: 10),

              Text(
                supabase.auth.currentUser!.email ?? '',
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
