import 'package:flutter/material.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:supabase_quickstart/utils/constants.dart';

import '../vertical_order_card.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  dynamic _orderList;

  Future<void> _getOrderList() async {
    final userId = supabase.auth.currentUser?.id;
    final response = await supabase.from('orders').select().match(
        {'user_id': userId}).execute();
    final error = response.error;
    if (error != null) {
      print(error);
    } else {
      setState(() {
        _orderList = response.data;
      });
    }
  }


  buildVerticalList() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _orderList == null ? 0 : _orderList.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = _orderList[index];
          return VerticalOrderCard(place: place['offer_data'], dishIndex: index, orderStatus: place['accepted'], orderId: place['id'],);
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.primaryWhiteSmoke,
      body: primaryContainer(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 100.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "Mijn Bestellingen",
                style: boldFont(MColors.textDark, 24.0),
                textAlign: TextAlign.start,
              ),
            ),
            buildVerticalList()
          ],
        )
      )
    );
  }
}


