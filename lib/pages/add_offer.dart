import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:location/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_quickstart/components/auth_required_state.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';
import 'package:image_cropper/image_cropper.dart';


class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({Key? key}) : super(key: key);

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _AddOfferScreenState extends AuthRequiredState<AddOfferScreen> {
  var uuid = Uuid();
  File? _photo;
  late AppState state;
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final MaskedTextController _priceController;
  late final TextEditingController _addressController;

  pickedImageWidget(BuildContext context){
    if(_photo != null){
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(_photo!)
      );
    }else {
      return GestureDetector(
        child: Image.asset('assets/images/placeholderOrder.png'),
        onTap: (){
          imgFromCamera();
        },
      );
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        state = AppState.picked;
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
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  Future<LocationData?> getCurrentLocationData() async {

    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled){
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled){
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if(_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if(_permissionGranted != PermissionStatus.granted){
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;

  }

  Future<void> addOffer(BuildContext context) async {
    final LocationData? locationData = await getCurrentLocationData();
    final photo = _photo;
    final photoUuid = uuid.v1();
    final res = await supabase.storage.from('offer-images').upload('${supabase.auth.currentUser!.id}/$photoUuid.png', photo!, fileOptions: FileOptions(
      cacheControl: '3600',
      upsert: false
    ));
    final error = res.error;
    if(error != null){
      print(error);
    }else {
      final updates = {
        'image': 'https://yoepxzzytgwaodkdamsr.supabase.co/storage/v1/object/public/offer-images/${supabase.auth.currentUser!.id}/$photoUuid.png',
        'user_id': supabase.auth.currentUser!.id,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'address': _addressController.text,
        'created_at': DateTime.now().toIso8601String(),
        'lat': locationData?.latitude,
        'lng': locationData?.longitude,
      };
      final response = await supabase.from('offers').upsert(updates).execute();
      final err = response.error;
      if(err != null){
        print(err);
      }else {
        Navigator.pop(context);
      }
    }
  }


  @override
  void initState() {
    state = AppState.free;
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController  = MaskedTextController(mask: '€00.00');
    _addressController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MColors.primaryWhiteSmoke,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Aanbieding plaatsen',
          style: boldFont(MColors.textDark, 16.0),
        ),
      ),
      backgroundColor: MColors.primaryWhiteSmoke,
      body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: primaryContainer(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            pickedImageWidget(context),
            SizedBox(height: 20),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Naam",
                style: normalFont(MColors.textGrey, null),
              ),
            ),

            TextFormField(
              controller: _nameController,
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

            SizedBox(height: 20),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Beschrijving",
                style: normalFont(MColors.textGrey, null),
              ),
            ),

            TextFormField(
              controller: _descriptionController,
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

            SizedBox(height: 20),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Adres",
                style: normalFont(MColors.textGrey, null),
              ),
            ),

            TextFormField(
              controller: _addressController,
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

            SizedBox(height: 20),

            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                "Prijs",
                style: normalFont(MColors.textGrey, null),
              ),
            ),

            TextFormField(
              controller: _priceController,
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

            SizedBox(height: 20),

            primaryButtonPurple(
                Text(
                  "Plaats aanbieding",
                  style: boldFont(MColors.primaryWhite, 16.0),
                ),
                    () {
                  addOffer(context);
                }),

          ],
        )
      )
      )
    );
  }
}
