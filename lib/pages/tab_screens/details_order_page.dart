import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:supabase_quickstart/utils/constants.dart';

import '../../components/auth_required_state.dart';
import '../starRatings.dart';

enum Status {
  accepted,
  declined,
  pending,
}

class DetailsOrderScreen extends StatefulWidget {
  final int offerId;
  final String userId;
  final String orderStatus;
  final int orderId;

  const DetailsOrderScreen({Key? key, required this.offerId, required this.userId, required this.orderStatus, required this.orderId}) : super(key: key);

  @override
  State<DetailsOrderScreen> createState() => _DetailsOrderScreenState();
}

class _DetailsOrderScreenState extends AuthRequiredState<DetailsOrderScreen> {
  dynamic _offerData = null;
  dynamic _userData = null;
  dynamic _orderStatus = null;

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

  Future<void> _getUserData() async {
    final res = await supabase.from('profiles').select().match({'id': widget.userId}).execute();
    final err = res.error;
    if (err != null) {
      context.showErrorSnackBar(message: err.message);
    }else {
      setState(() {
        _userData = res.data[0];
      });
    }
  }

  Future<void> _cancelOrder() async {
    final res = await supabase.from('orders').delete().match({'id': widget.orderId}).execute();
    final err = res.error;
    if (err != null) {
      context.showErrorSnackBar(message: err.message);
    }else {
      Navigator.pop(context);
    }
  }

  @override
  initState() {
    super.initState();
    _getOfferData();
    _getUserData();
    switch(widget.orderStatus){
      case "pending":
        _orderStatus = 'In afwachting';
        break;
      case "accepted":
        _orderStatus = 'Geaccepteerd';
        break;
      case "declined":
        _orderStatus = 'Geweigerd';
        break;
    }
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
          body: _offerData == null ? Center(child: CircularProgressIndicator()) : _userData == null ? Center(child: CircularProgressIndicator()): _buildProductDetails(_offerData, _userData, _orderStatus),
        ),
        bottomNavigationBar: Container(
          color: MColors.primaryWhiteSmoke,
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 15.0),
          child: primaryButtonPurple(
            Text(
              _orderStatus == "accepted" ? "Verwijderen" : "Annuleren",
              style: boldFont(MColors.primaryWhite, 16.0),
            ),
            () {
              _cancelOrder();
            },
          ),
        ),
      );
    }
  }

  Widget _buildProductDetails(prodDetails, userDetails, orderStatus) {
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
            ),
            Container(
              child: ExpansionTile(
                title: Text(
                  "Details",
                  style: boldFont(MColors.textDark, 16.0),
                ),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      bottom: 10.0,
                      right: 30.0
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              "Aanbieder",
                              style: normalFont(MColors.textDark, 16.0),
                            )
                        ),
                        Expanded(
                            child: Text(
                              userDetails['username'],
                              style: normalFont(MColors.textGrey, 14.0),
                            )
                        )
                        ]
                    )
                  )
                ]
              )
            ),
            Container(
                child: ExpansionTile(
                    title: Text(
                      "Status",
                      style: boldFont(MColors.textDark, 16.0),
                    ),
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(
                              left: 30.0,
                              bottom: 10.0,
                              right: 30.0
                          ),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                      "Huidige status",
                                      style: normalFont(MColors.textDark, 16.0),
                                    )
                                ),
                                Expanded(
                                    child: Text(
                                      orderStatus.toString(),
                                      style: normalFont(MColors.textGrey, 14.0),
                                    )
                                )
                              ]
                          )
                      )
                    ]
                )
            )
          ]
        )
      )
    );
  }
