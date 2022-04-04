import 'package:flutter/material.dart';
import 'package:supabase_quickstart/utils/colors.dart';
import 'package:supabase_quickstart/utils/constants.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  dynamic _orderList;

  Future<void> _getOrderList() async {
    final userId = supabase.auth.currentUser?.id;
    final response = await supabase.from('orders').select().match({'user_id': userId}).execute();
    final error = response.error;
    if (error != null) {
      print(error);
    }else{
      setState(() {
        _orderList = response.data;
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return _orderList == null ? Center(child: CircularProgressIndicator()) : offerPage(_orderList, context);
  }
}

Widget offerPage(offerList, context){
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
                    "Mijn bestellingen",
                    style: boldFont(MColors.textDark, 24.0),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 10.0),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: offerList.length,
                      itemBuilder: (context, i) {
                        var offer = offerList[i]['offer_data'];

                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            // remove order
                          },
                          background: backgroundDismiss(AlignmentDirectional.centerStart),
                          secondaryBackground: backgroundDismiss(AlignmentDirectional.centerEnd),
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            height: 160,
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                color: MColors.primaryWhite,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Container(
                                    width: 80.0,
                                    child: FadeInImage.assetNetwork(
                                      image: offer['image'],
                                      fit: BoxFit.fill,
                                      height: MediaQuery.of(context).size.height,
                                      placeholder: 'assets/images/placeholder.png',
                                      placeholderScale: MediaQuery.of(context).size.height / 2,
                                    )
                                  ),
                                  SizedBox(width: 5.0),
                                  Container(
                                    width: MediaQuery.of(context).size.height / 2.2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            offer['name'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: normalFont(MColors.textDark, 16.0),
                                            textAlign: TextAlign.start,
                                            softWrap: true,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                offer['price'],
                                                style: boldFont(MColors.primaryPurple, 22.0),
                                                textAlign: TextAlign.left,
                                              )
                                            ]
                                          )
                                        ),
                                        Spacer(),
                                        Container(
                                          child: Text(
                                            'Swipe om te verwijderen',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: normalFont(Colors.redAccent, 10.0),
                                            textAlign: TextAlign.left,
                                            softWrap: true,
                                          )
                                        )
                                      ]
                                    )
                                  ),
                                  Spacer(),
                                  //TODO: add builder
                                ]
                              )
                            )
                          )
                        );
                      },
                    )
                  )
                )
              ],
            )
        ),
      )
  );
}
