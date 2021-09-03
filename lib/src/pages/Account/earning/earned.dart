import 'package:ECom/src/api/apiServices.dart';
import 'package:ECom/src/models/orderData.dart';
import 'package:ECom/src/models/productListApi.dart';
import 'package:ECom/src/pages/orders/orderDetails.dart';
import 'package:ECom/src/pages/orders/orderDetailsRefund.dart';
import 'package:flutter/material.dart';
import 'package:ECom/src/helpers/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:ECom/src/helpers/appBarWithPop.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details.dart';
import 'earningData.dart';
import 'earningData.dart';
import 'package:ECom/src/helpers/constants.dart';

class Earned extends StatefulWidget {
  List<EarningData> earningData = [];
  int balance;
  Earned({Key key, this.earningData, this.balance}) : super(key: key);

  @override
  _EarnedState createState() => _EarnedState();
}

class _EarnedState extends State<Earned> {
  @override
  void initState() {
    super.initState();

    controller = new ScrollController()..addListener(_scrollListener);
  }

  ScrollController controller;

  int pages, page;

  void _scrollListener() async {
    print("inside controller" + controller.position.extentAfter.toString());
    // if (widget.isCat != "false")
    if (controller.position.extentAfter == 0.0) {
      print("after pagnation for $page");

      if (page < pages) {
        page += 1;

        Map productRes = await ApiServices.getRequestToken(
            earningEndPoint + "?json=1&page=$page");

        if (productRes != null) {
          // stopLoading();
          print("after pagnation for $page");
          // print(productRes);
          Provider.of<MyEarningData>(context, listen: false)
              .setProductListData(productRes["data"]);
          Provider.of<MyEarningData>(context, listen: false).addData(
              List<EarningData>.from((productRes["data"]["items"]
                      ?.map((x) => EarningData.fromMap(x))) ??
                  []));
          Provider.of<MyEarningData>(context, listen: false).increasePage(page);
        } else {
          // stopLoading();
          Fluttertoast.showToast(
            msg: "Server is not responding",
            backgroundColor: Colors.grey[400],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<MyEarningData>(builder: (context, category, ch) {
      // if (category.isSubCategory)

      pages = category?.earningListData?.pages ?? 0;
      page = category?.earningListData?.page ?? 0;
      print(pages);
      print(page);

      if (category.earningList == null || category.earningList?.length == 0)
        return Center(
          child: Text("No cashback earned yet!"),
        );
      else
        return Container(
          padding: EdgeInsets.only(top: 5, bottom: 2),
          // color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                // width: 1,
                height: 1,
              ),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Colors.grey[300],
                      width: 1,
                      height: 0,
                    );
                  },
                  itemCount: category.earningList.length,
                  itemBuilder: (context, earnIndex) => InkWell(
                      onTap: () async {
                        String description =
                            category.earningList[earnIndex].description;
                        if (description.contains("#")) {
                          List<OrderData> OrderList;
                          String orderId = description.split("#")[1];
                          Map OrderListRes = await ApiServices.postRequestToken(
                              '''{}''', getOrderEndPoint);
                          if (OrderListRes != null && orderId != null) {
                            OrderList = List<OrderData>.from(
                                (OrderListRes["items"]
                                        ?.map((x) => OrderData.fromMap(x))) ??
                                    []);
                            // print(message ?? "null");
// if(OrderList.contains((element)=>element.or))
                            OrderData currentItem = OrderList.firstWhere(
                                (e) => e.orderDataId == orderId);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        currentItem.status.toLowerCase() ==
                                                "refunded"
                                            ? OrderDetailsRefund(
                                                orderData: currentItem)
                                            : OrderDetails(
                                                orderData: currentItem)));
                          }
                        }
                      },
                      child: details(context, category.earningList[earnIndex])),
                ),
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
          // SizedBox(
          //   height: 20,
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 12.0),
          //   child: Row(
          //     children: <Widget>[
          //       Text("Total Earned",
          //           style: Theme.of(context)
          //               .textTheme
          //               .headline3
          //               .copyWith(color: Theme.of(context).primaryColor)),
          //       Text(
          //         "  ₹ ${balance}",
          //         style: Theme.of(context)
          //             .textTheme
          //             .headline4
          //             .copyWith(color: Colors.black),
          //       )
          //     ],
          //   ),
          // ),
          //   ],
          // ),
        );
    });
  }
}
