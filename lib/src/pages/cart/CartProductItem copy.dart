import 'dart:convert';

import 'package:ECom/src/api/apiServices.dart';
import 'package:ECom/src/helpers/helper.dart';
import 'package:ECom/src/models/cart.dart';
import 'package:ECom/src/models/productListApi.dart';
import 'package:ECom/src/pages/productDetails/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ECom/src/helpers/SizeConfig.dart';
import 'package:ECom/src/helpers/constants.dart';
import 'package:ECom/src/models/route_argument.dart';
import 'package:ECom/src/models/userData.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'api/CartData.dart';

class CartProductItemPreview extends StatefulWidget {
  final String heroTag;
  // final Product product;
  final String product;
  Product cartData;
  CartProductItemPreview({Key key, this.product, this.heroTag, this.cartData})
      : super(key: key);
  @override
  _CartProductItemPreviewState createState() => _CartProductItemPreviewState();
}

class _CartProductItemPreviewState extends State<CartProductItemPreview> {
  int quantity = 0;
  String secondDrop;
  var requiredvariant, requiredProduct;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    requiredvariant = widget.cartData?.variant;
    requiredProduct = widget.cartData;

    SizeConfig().init(context);
    return Consumer<UserData>(builder: (context, userData, ch) {
      // List<Item> produtList = category.items ?? [];
      return Consumer<ProductListData>(builder: (context, productListData, ch) {
        // Item itemData = productListData.items
        //     .firstWhere((e) => e.itemId == widget?.cartData?.productId);

        return Container(
          height: SizeConfig.h * 0.19,
          padding: EdgeInsets.only(left: 12, top: 16, bottom: 0),
          decoration: BoxDecoration(
            color:
                // Colors.black,
                Theme.of(context).primaryColorLight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // InkWell(
              //   splashColor: Theme.of(context).primaryColor,
              //   focusColor: Theme.of(context).primaryColor,
              //   highlightColor: Theme.of(context).primaryColorLight,
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (_) => ProductWidget(
              //                 linker: widget.cartData.name.toLowerCase(),
              //                 product: widget.product,
              //                 ProductName: widget.productName,
              //                 routeArgument: RouteArgument(
              //                   id: '0',
              //                   param: widget.product,
              //                   heroTag: widget.heroTag,
              //                 ))));
              //   },
              //   child: Hero(
              //     tag: widget.heroTag + widget.product,
              // child:
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProductWidget(
                              linker: widget.cartData.linker,
                            ))),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: widget.cartData.pictures.isEmpty
                      ? Center(
                          child: Container(
                              width: SizeConfig.w * 0.17,
                              child: Center(
                                child: Image.asset(
                                  'assets/img/No_image_available.jpg',
                                  // width: double.infinity,
                                  // fit: BoxFit.fill,

                                  fit: BoxFit.fitWidth,
                                  // width: double.infinity,
                                  height: SizeConfig.h * 0.15,
                                  width: SizeConfig.w * 0.17,
                                ),
                              )),
                        )
                      : CachedNetworkImage(
                          height: SizeConfig.h * 0.15,
                          width: SizeConfig.w * 0.17,
                          fit: BoxFit.fitWidth,
                          imageUrl:
                              awsLink + widget.cartData.pictures[0] + ".jpg",
                          placeholder: (context, url) => Image.asset(
                            'assets/img/loading.gif',
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                          errorWidget: (context, url, error) => Container(
                              height: 100,
                              child: Center(child: Icon(Icons.image))),
                        ),
                ),
              ),
              //   ),
              // ),
              SizedBox(width: 10),
              Container(
                margin: EdgeInsets.symmetric(vertical: 9),
                width: SizeConfig.w * 0.76,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: SizeConfig.w * 0.7,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProductWidget(
                                              linker: widget.cartData.linker,
                                            ))),
                                child: Text(
                                  widget.cartData.name ?? "Name",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .title
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14),
                                ),
                              ),
                              // ),
                            ),
                            SizedBox(
                              width: SizeConfig.w * 0.7,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    // height: 30,
                                    width: SizeConfig.w * 0.2,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 1),
                                    margin: EdgeInsets.only(left: 0.0, top: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color:
                                                Theme.of(context).accentColor,
                                            width: 0.5)),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          requiredvariant?.title ?? "1 KG",
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    //width: SizeConfig.w * 0.24,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Quantity: "),
                                        Container(
                                          width: 28,
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                  widget?.cartData?.quantity
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        // left: 15,
                        right: 15,
                      ),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              child: Text(
                                  "MRP: " +
                                      Helper.getPrice(requiredProduct.mrp),
                                  // overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            FittedBox(
                              child: Text(
                                "You Pay: " +
                                    Helper.getPrice(requiredProduct.price),
                                // overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            FittedBox(
                              child: Text(
                                "Save: " +
                                    Helper.getPrice(
                                        (requiredProduct?.mrp ?? 0.0) -
                                            (requiredProduct?.price ?? 0.0)),
                                // overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor),
                              ),
                            ),
                            // SizedBox(
                            //   width: 0,
                            // ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  "Sold by: ${(widget?.cartData?.deliveryType == "shop-sasta" ? "shopsasta" : widget?.cartData?.deliveryType) ?? "shopsasta"} ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: SizeConfig.w * 0.032)),
                          // TextSpan(
                          //     text:
                          //         " ${(widget.cartData.shippingPrice > 0) ? "(Shipping Price:" + (widget.cartData.shippingPrice.toString()) + ")" : ""}",
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyText1
                          //         .copyWith(fontSize: SizeConfig.w * 0.028)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
