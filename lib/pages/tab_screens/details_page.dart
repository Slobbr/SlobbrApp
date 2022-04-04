import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:supabase_quickstart/utils/constants.dart';

import '../../components/auth_required_state.dart';
import '../starRatings.dart';

class DetailsScreen extends StatefulWidget {
  final int offerId;

  const DetailsScreen({Key? key, required this.offerId}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends AuthRequiredState<DetailsScreen> {
  dynamic _offerData = null;
  dynamic _userData = null;
  dynamic _reviewData = null;

  Future<void> _getOfferData() async {
    final response = await supabase.from('offers').select().match({'id': widget.offerId}).execute();
    final error = response.error;
    if (error != null) {
      print('Error: ${error.message}');
    }else {
      setState(() {
        _offerData = response.data[0];
      });
    }
  }
  
  Future<void> _getReviewData(double uid) async {
    final response = await supabase.from('reviews').select().match({'reviewed_id': uid}).execute();
    final error = response.error;
    if (error != null) {
      print('Error: ${error.message}');
    }else {
      setState(() {
        _reviewData = response.data;
      });
    }
  }

  Future<void> _getUserData() async {
    final response = await supabase.from('users').select().match({'id': _offerData['user_id']}).execute();
    final error = response.error;
    if (error != null) {
      print('Error: ${error.message}');
    }else {
      setState(() {
        _userData = response.data[0];
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getOfferData();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        backgroundColor: MColors.primaryWhite,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0.0,
                brightness: Brightness.light,
                backgroundColor: MColors.primaryWhite,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: MColors.textDark),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                expandedHeight: (MediaQuery.of(context).size.height) / 2.3,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Builder(
                  builder: (context) {
                    return Container(
                      color: MColors.primaryWhite,
                      padding: const EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 10.0),
                      child: _offerData == null
                      ? Center(child: CircularProgressIndicator())
                          : Hero(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  _offerData['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                          tag: _offerData['id'].toString(),
                        ),
                      );
                   },
                  )
                ),
              )
            ];
          },
          body: _offerData == null ? Center(child: CircularProgressIndicator()) : _buildProductDetails(_offerData),
        ),
        bottomNavigationBar: Container(
          color: MColors.primaryWhiteSmoke,
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
          child: primaryButtonPurple(
            Text(
              "Bestellen",
              style: boldFont(MColors.primaryWhite, 16.0),
            ),
            () {},
          ),
        ),
      );
    }
  }

  Widget _buildProductDetails(prodDetails){
    return Container(
      decoration: const BoxDecoration(
        color: MColors.primaryWhiteSmoke,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 20.0,
        right: 20.0,
        left: 20.0,
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              prodDetails['name'],
              style: boldFont(MColors.textDark, 22.0),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                prodDetails['price'],
                style: boldFont(MColors.primaryPurple, 20.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                "Beschrijving",
                style: boldFont(MColors.textDark, 16.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(
                prodDetails['description'],
                style: normalFont(MColors.textGrey, 14.0),
              ),
            )
          ]
        )
      )
    );
  }
