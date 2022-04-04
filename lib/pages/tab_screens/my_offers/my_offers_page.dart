import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_quickstart/pages/tab_screens/my_offers/vertical_offer_card.dart';

import '../../../components/auth_state.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class MyOfferPage extends StatefulWidget {
  const MyOfferPage({Key? key}) : super(key: key);

  @override
  State<MyOfferPage> createState() => _MyOfferPageState();
}

class _MyOfferPageState extends AuthState<MyOfferPage> {
  dynamic _offerList;

  Future<void> _getOrderList() async {
    final userId = supabase.auth.currentUser?.id;
    final response = await supabase.from('offers').select().match(
        {'user_id': userId}).execute();
    final error = response.error;
    if (error != null) {
      print(error);
    } else {
      setState(() {
        _offerList = response.data;
      });
    }
  }

  @override
  initState() {
    super.initState();
    _getOrderList();
  }

  buildVerticalList() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _offerList == null ? 0 : _offerList.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = _offerList[index];
          return VerticalOfferCard(
            place: place,
            dishIndex: index,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MColors.primaryWhiteSmoke,
        appBar: AppBar(
        elevation: 0,
        backgroundColor: MColors.primaryWhiteSmoke,
        leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mijn aanbiedingen',
          style: boldFont(MColors.textDark, 16.0),
        ),
      ),
      body: primaryContainer(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildVerticalList(),
          ],
        )
      )
    );
  }
}
