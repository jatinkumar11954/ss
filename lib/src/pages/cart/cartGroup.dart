import 'dart:convert';

import 'package:ECom/src/api/apiServices.dart';
import 'package:ECom/src/helpers/SizeConfig.dart';
import 'package:ECom/src/helpers/appBarWithPop.dart';
import 'package:ECom/src/helpers/autoText.dart';
import 'package:ECom/src/helpers/bottomNavBar.dart';
import 'package:ECom/src/helpers/constants.dart';
import 'package:ECom/src/helpers/helper.dart';
import 'package:ECom/src/models/userData.dart';
import 'package:ECom/src/pages/widget/cartRadio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CartProductItem copy.dart';
import 'CartProductItem.dart';
import 'api/CartData.dart';
import 'api/cartGroupApi.dart';
import 'cartNoItem.dart';
import 'cartSummary.dart';
import 'cartdetails.dart';

class CartGroup extends StatefulWidget {
  CartGroup({Key key}) : super(key: key);

  @override
  _CartGroupState createState() => _CartGroupState();
}

class _CartGroupState extends State<CartGroup> {
  String rush_type = "Regular";
  int rush = 1;
  bool checkBool = false;
  bool checkApply = false;
  String payment_type = "cod";
  int payment_id = 1;
  int nextdelivery = 0;
  void _onCheckApply(bool newValue) => setState(() {
        checkApply = !checkApply;
      });
  void _onCheckChange(bool newValue) => setState(() {
        checkBool = !checkBool;
      });
  // CartController _con;

  // _CartWidgetState() : super(CartController()) {
  //   _con = controller;
  // }
  // GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    getCartData(refresh: false);
  }

  String coupon;
  showLoading() => setState(() {
        _isLoading = true;
      });
  stopLoading() => setState(() {
        _isLoading = false;
      });

  showWLoading() => setState(() {
        _isWLoading = true;
      });
  stopWLoading() => setState(() {
        _isWLoading = false;
      });

  showCLoading() => setState(() {
        _isCLoading = true;
      });
  stopCLoading() => setState(() {
        _isCLoading = false;
      });
  bool _isLoading = false;
  bool _isWLoading = false;
  bool _isCLoading = false;
  bool _isCart = false;
  List<CartGroupData> cartGroupList = [];
  NoRushData noRushData;
  String minOrderAmount = "500";
  List<String> dayArray = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  getCartData({bool refresh}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool("isLogin") ?? false;
    if (isLogin) {
      refresh ? print("refresh is true") : showLoading();

      // await Future.delayed(Duration(milliseconds: 1000));
      Map noRushres = await ApiServices.getRequestToken(noRushEndPoint);
      Map regularres = await ApiServices.getRequestToken(regEndPoint);
      print("reg res $regularres");
      if (noRushres != null) {
        // print(DateFormat.ABBR_WEEKDAY);
        // DateFormat('EEE').format(DateTime.now());
        noRushData = NoRushData.fromMap(noRushres["data"]);
        // print(
        //     "--no rush data ${DateTime.now().subtract(Duration(days: 5)).weekday}");
        setState(() {
          nextdelivery = ((DateTime.now().weekday -
                      (dayArray.indexOf(noRushData.deliveryDay) + 1)) -
                  7)
              .abs();
        });
      }
      Map cartGroupres = await ApiServices.getRequestToken("api/cart-group");
      Map minOrderres = await ApiServices.getRequestToken(minOrdAmtEndPoint);
      if (minOrderres != null) {
        if (minOrderres["status"])
          minOrderAmount = minOrderres["data"]["min_order_amount"].toString();
      }
      if (cartGroupres != null) {
        // print("init of cart");
        // print(res["data"]["products"].isEmpty);
        // print(res["status"] == false);
        print("cart grp" + cartGroupres.toString());
        if ((cartGroupres?.isNotEmpty ?? false)) {
          setState(() {
            cartGroupList = List<CartGroupData>.from(
                cartGroupres["data"]?.map((x) => CartGroupData.fromMap(x)) ??
                    []);
          });
          // Provider.of<CartData>(context, listen: false)
          //     .setCartData(cartGroupres["data"]);
          stopLoading();
          setState(() {
            _isCart = true;
          });
        } //status is true
        else if (cartGroupres == null || cartGroupres.isEmpty) {
          // stopLoading();
          setState(() {
            _isCart = false;
          });
          // Navigator.of(context).pushNamed("/CartNoItem");
        }
      } else {
        // stopLoading();
      } //status is not true
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _orderConfirmed = false;
  bool goback = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomNavBar(
        index: 0,
        isLogin: true,
      ),
      backgroundColor: Colors.white,
      appBar: AppBarWithPop(context, "Cart Preview",
          needCart: false, ispop: true, needSearch: true),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (!_isCart || (cartGroupList?.isEmpty ?? false))
              ? CartNoItem()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                                color: Colors.grey[300], height: 1);
                          },
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          itemCount: cartGroupList?.length ?? 0,
                          itemBuilder: (context, grpIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  cartGroupList[grpIndex].vendor == "shop-sasta"
                                      ? Row(
                                          // crossAxisAlignment: Cross,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15.0,
                                              ),
                                              child: Text("Sold by "),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Image.asset(
                                                'assets/icons/SHOPSASTA_200X45.png',
                                                width: SizeConfig.w * 0.19,
                                                alignment:
                                                    Alignment.bottomCenter,
                                              ),
                                            ),
                                            Text(" and Fulfilled by "),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Image.asset(
                                                'assets/icons/SHOPSASTA_200X45.png',
                                                width: SizeConfig.w * 0.19,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          // crossAxisAlignment: Cross,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15.0,
                                              ),
                                              child: Text("Sold by "),
                                            ),
                                            Text(
                                              cartGroupList[grpIndex].vendor,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            Text(" and Fulfilled by "),
                                            cartGroupList[grpIndex]
                                                        .vendorDetails
                                                        .shipping_by ==
                                                    "shop-sasta"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Image.asset(
                                                      'assets/icons/SHOPSASTA_200X45.png',
                                                      width:
                                                          SizeConfig.w * 0.19,
                                                    ),
                                                  )
                                                : Text(
                                                    cartGroupList[grpIndex]
                                                        .vendor,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )
                                          ],
                                        ),

                                  cartGroupList[grpIndex].vendor != "shop-sasta"
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15.0, top: 15),
                                          child: textST2(
                                              "Expected delivery on ${DateFormat.yMMMEd().format(DateTime.now().add(Duration(days: int.parse(cartGroupList[grpIndex].vendorDetails.deliveryDetails.daysOfSkip) + ((cartGroupList[grpIndex].vendorDetails.deliveryDetails.sundayDelivery) ? 1 : (DateTime.now().add(Duration(days: (int.parse(cartGroupList[grpIndex].vendorDetails.deliveryDetails.daysOfSkip) + 1))).weekday == DateTime.sunday) ? 2 : 1))))} (${cartGroupList[grpIndex].vendorDetails.deliveryDetails.deliveryHours})",
                                              textstyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              maxLines: 2),
                                        )
                                      : Wrap(
                                          spacing: 0,
                                          children: <Widget>[
                                            RadioCart(
                                              radioText: 'Regular',
                                              payment_id: rush,
                                              valueint: 1,
                                              radioClick: (val) {
                                                setState(() {
                                                  rush_type = 'Regular';
                                                  rush = 1;
                                                });
                                              },
                                              textClick: () {
                                                setState(() {
                                                  rush_type = 'Regular';
                                                  rush = 1;
                                                });
                                              },
                                            ),
                                            RadioCart(
                                              radioText:
                                                  'No-Rush (You get an extra ${noRushData?.cashbackPercent}% cashback.\n Applicable for shopsasta products only)',
                                              payment_id: rush,
                                              valueint: 2,
                                              radioClick: (val) {
                                                setState(() {
                                                  rush_type = 'NoRush';
                                                  rush = 2;
                                                });
                                              },
                                              textClick: () {
                                                setState(() {
                                                  rush_type = 'NoRush';
                                                  rush = 2;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                  // : Container(),
                                  cartGroupList[grpIndex].vendor == "shop-sasta"
                                      ? rush == 2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                              ),
                                              child: textST2(
                                                  // fit: BoxFit.fitWidth,
                                                  // child: Text(

                                                  "Expected delivery on ${DateFormat.yMMMEd().format(DateTime.now().add(Duration(days: nextdelivery)))}(${noRushData?.deliveryHours})",
                                                  textstyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  maxLines: 2
                                                  // ),
                                                  ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 5.0,
                                              ),
                                              child: textST2(
                                                  "Expected delivery on ${DateFormat.yMMMEd().format(DateTime.now().add(Duration(days: int.parse(cartGroupList[grpIndex].vendorDetails.deliveryDetails.daysOfSkip) + ((cartGroupList[grpIndex].vendorDetails.deliveryDetails.sundayDelivery) ? 1 : (DateTime.now().add(Duration(days: (int.parse(cartGroupList[grpIndex].vendorDetails.deliveryDetails.daysOfSkip) + 1))).weekday == DateTime.sunday) ? 1 : 2))))} (${cartGroupList[grpIndex].vendorDetails.deliveryDetails.deliveryHours})",

                                                  // "Expected delivery on ${DateFormat.yMMMEd().format(DateTime.now().add(Duration(days: int.parse(cartGroupList[grpIndex].vendorDetails.deliveryDetails.daysOfSkip) + (cartGroupList[grpIndex].vendorDetails.deliveryDetails.sundayDelivery && (DateTime.now().add(Duration(days: (int.parse(cartGroupList[grpIndex].vendorDetails.deliveryDetails.daysOfSkip) + 1))).weekday == DateTime.sunday) ? 1 : 2))))}(${cartGroupList[grpIndex].vendorDetails.deliveryDetails.deliveryHours})",
                                                  textstyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  maxLines: 2),
                                            )
                                      : Container(),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    addAutomaticKeepAlives: true,
                                    itemCount:
                                        cartGroupList[grpIndex].items?.length ??
                                            0,
                                    itemBuilder: (context, ind) {
                                      return
                                          // Expanded(
                                          //   child:
                                          CartProductItemPreview(
                                        // key: Key(
                                        //     "${cartdata?.currentCart?.products[ind].variantId}"),
                                        cartData:
                                            cartGroupList[grpIndex].items[ind],

                                        heroTag: 'details_featured_product',
                                        product: productImg.elementAt(2),
                                        // ),
                                      );
                                    },
                                  ),
                                  SummaryWidget(
                                    cartData: cartGroupList[grpIndex],
                                  )
                                ],
                              ),
                            );
                          }),
                      Center(
                        child: goback
                            ? CircularProgressIndicator()
                            : Container(
                                margin: EdgeInsets.only(top: 10, bottom: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // width: SizeConfig.w * 0.6,
                                height: 35,
                                child: RaisedButton(
                                  elevation: 0,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    _NextPressed();
                                  },
                                  child: Text("Proceed to checkout >>",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16)),
                                ),
                              ),
                      ),
                      // SizedBox(
                      //   height: 15,
                      // )
                    ],
                  ),
                ),
    );
  }

  _NextPressed() async {
    print("billing addres");
    Map<String, dynamic> data = {
      "is_checkout": true,
    };
    // print("nnnnnnnnnnnnnnn${data}");
    setState(() {
      goback = true;
    });
    // await Future.delayed(
    //     Duration(milliseconds: 600));
    print(data);
    // print("hitting api for back");

    Map res = await ApiServices.postRequestToken(
      json.encode(data),
      removeCashbacksEndPoint,
    );
    // print("ffffffffffggggggggggggffffffffffffff${res}");
    if (res["status"] != null) {
      if (res["status"]) {
        setState(() {
          goback = false;
        });
        var formatter = new DateFormat('dd-MM-yyyy');
        List<Map<String, dynamic>> update = [];
        cartGroupList.forEach((ca) {
          bool checkRegular = DateTime.now()
                  .add(Duration(
                      days: (int.parse(
                              ca.vendorDetails.deliveryDetails.daysOfSkip) +
                          1)))
                  .weekday ==
              DateTime.sunday;
          update.add({
            "deliveryBy": ca.vendor,
            "delivery_date": formatter.format(DateTime.now().add(Duration(
                days: int.parse((ca.vendor == "shop-sasta" && rush == 2)
                    ? "$nextdelivery"
                    : "${int.parse(ca.vendorDetails.deliveryDetails.daysOfSkip) + (ca.vendorDetails.deliveryDetails.sundayDelivery ? 1 : checkRegular ? 2 : 1)}")))),
            "delivery_charges": ca.deliveryCharges,
            "delivery_time": ca.vendorDetails.deliveryDetails.deliveryHours
          });
        });
        Map<String, dynamic> updatedata = {"delivery_info": update};
        print(updatedata);
        Map updateres = await ApiServices.postRequestToken(
          json.encode(updatedata),
          updatevendorEndPoint,
        );

        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CartDetailsWidget(
                  scaffoldKeyCart1: _scaffoldKey,
                  norush: rush == 2,
                )));
      } else {
        setState(() {
          goback = false;
        });
      }
      // cartdata?.currentCart?.products =
      //     [];

    } //cart res is not null

    else {
      // itemData?.quantity += 1;

      Fluttertoast.showToast(
        msg: res["message"] ?? "Cart is Empty",
        backgroundColor: Colors.grey[400],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
      );
    }
  }
}

class SummaryWidget extends StatelessWidget {
  double subTotal;
  double total;
  double totalSaving;
  CartGroupData cartData;
  SummaryWidget(
      {Key key, this.cartData, this.subTotal, this.total, this.totalSaving})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 0.5, color: Colors.grey))),
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Subtotal",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        Helper.getPrice(cartData?.subTotal ?? 0.0),
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Delivery Fee",
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        Helper.getPrice(cartData?.deliveryCharges ?? 0.0),
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.black, fontSize: 15),
                      ),
                      // Text(
                      //   // cartdata.currentCart
                      //   //                 ?.totalShippingPrice !=
                      //   //             null &&
                      //   //         (cartdata.currentCart
                      //   //                     ?.totalShippingPrice ??
                      //   //                 0) >
                      //   //             0
                      //   //     ? Helper.getPrice(
                      //   //         cartdata
                      //   //             .currentCart
                      //   //             ?.totalShippingPrice)
                      //   //     :
                      //   "--",
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .headline5
                      //       .copyWith(color: Colors.black, fontSize: 15),
                      // ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 0.5, color: Colors.grey))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Total",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            Helper.getPrice(cartData?.total ?? 0.0),
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.black, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   height: SizeConfig.w * 0.22,
          //   // color: Colors.red,
          //   child: Column(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: <Widget>[
          //       Text(
          //         "Total Saved",
          //         style: Theme.of(context)
          //             .textTheme
          //             .headline5
          //             .copyWith(color: Colors.black, fontSize: 12),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(
          //           left: 5.0,
          //           right: 5.0,
          //         ),
          //         child: FittedBox(
          //           fit: BoxFit.fitWidth,
          //           child: Text(
          //             Helper.getPrice(cartData?. ?? 0.0),
          //             style: Theme.of(context).textTheme.headline5.copyWith(
          //                 color: Theme.of(context).primaryColor, fontSize: 14),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
