import 'package:flutter/material.dart';
import 'package:supabase_quickstart/pages/tab_screens/details_order_page.dart';
import 'package:supabase_quickstart/pages/tab_screens/details_page.dart';

// import '../screens/details.dart';

class VerticalOrderCard extends StatelessWidget {
  final Map place;
  final int dishIndex;
  final int orderId;
  final String orderStatus;

  VerticalOrderCard({required this.place, required this.dishIndex, required this.orderStatus, required this.orderId});

  @override
  Widget build(BuildContext context) {
    String _status = 'null';

    switch(orderStatus){
      case 'pending':
        _status = 'In afwachting';
        break;
      case 'accepted':
        _status = 'Gaccepteerd';
        break;
      case 'declined':
        _status = 'Geweigerd';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        child: Container(
          height: 70.0,
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  "${place["image"]}",
                  height: 70.0,
                  width: 70.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15.0),
              Container(
                height: 80.0,
                width: 180,
                child: ListView(
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${place["name"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              color: Colors.blueGrey[300],
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${place["price"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DetailsOrderScreen(offerId: place['id'], userId: place['user_id'], orderStatus: orderStatus, orderId: orderId,);
              },
            ),
          );
        },
      ),
    );
  }
}