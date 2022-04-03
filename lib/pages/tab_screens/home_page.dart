import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_quickstart/components/auth_state.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:location/location.dart';
import 'package:supabase/supabase.dart';
import 'package:geocoder_flutter/geocoder.dart';
import 'package:supabase_quickstart/utils/constants.dart';

import '../horizontal_item_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends AuthState<HomePage> {
  dynamic _offers;

  Future<void> _getOffers() async {
    final response = await supabase.from('offers').select().execute();
    final error = response.error;
    if (error != null) {
      print(error);
    } else {
      setState(() {
        _offers = response.data;
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

  Future<Address?> getCurrentAddress() async {

    LocationData _currentLocationData;

    _currentLocationData = (await getCurrentLocationData())!;
    final coordinates = new Coordinates(_currentLocationData.latitude, _currentLocationData.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    return first;

  }

  buildHorizontalList(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 260.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: _offers == null ? 0 : _offers.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = _offers[index];
          return HorizontalItemCard(place: place, dishIndex: index,);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.primaryWhiteSmoke,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MColors.primaryWhiteSmoke,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: MColors.textDark),
            onPressed: () {},
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MColors.primaryPurple,
        child: const Icon(Icons.add, color: MColors.primaryWhite),
        onPressed: () {
          Navigator.pushNamed(context, '/addoffer');
        },
      ),
      body: primaryContainer(
        RefreshIndicator(
            child: ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Wat eten we vandaag?",
                      style: boldFont(MColors.textDark, 24.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  FutureBuilder<Address?>(
                      future: getCurrentAddress(),
                      builder: (BuildContext context, AsyncSnapshot<Address?> snapshot){
                        var address;
                        if(snapshot.hasData){
                          address = "${snapshot.data!.thoroughfare} ${snapshot.data!.featureName}, ${snapshot.data!.locality}";
                        }else {
                          address = "Getting location...";
                        }

                        return Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            address,
                            style: boldFont(MColors.textGrey, 16.0),
                            textAlign: TextAlign.start,
                          ),
                        );
                      }
                  ),
                  buildHorizontalList(context),
                ]
            ),
            onRefresh: _getOffers)
      )
    );
  }
}
