import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/cart.dart';
import 'package:untitled2/controller/categories.dart';
import 'package:untitled2/controller/products.dart';
import 'package:untitled2/controller/store.dart';
import 'package:untitled2/controller/transaction.dart';
import 'package:untitled2/controller/type_payment.dart';
import 'package:untitled2/drawer/drawer_navigate.dart';
import '../src/config.dart';

class HomeScreen extends StatelessWidget {
  final C = Get.put(ProductsController());
  final A = Get.put(CategoriesController());
  final S = Get.put(StoresController());
  final T = Get.put(CartsController());
  final P = Get.put(TypePaymentController());
  final trx = Get.put(TransactionsController());

  final f = NumberFormat("Rp #,##0", "en_US");
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productSubtotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //mediaquery
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[600],
          actions: [
            IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  C.getData();
                }),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        drawer: DrawerNavigate(),
        endDrawer: CartNavigate(),
        body: _portraitMode());
  }

  Widget _portraitMode() {
    return CustomScrollView(
      slivers: <Widget>[
        GetX<CategoriesController>(
          init: CategoriesController(),
          initState: (_) {},
          builder: (x) {
            return SliverToBoxAdapter(
              child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemExtent: 150,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                            child: Container(
                              child: Center(
                                  child: Text(
                                x.data[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.amber[100],
                                    fontSize: 20),
                              )),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber[600],
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.amber, spreadRadius: 4),
                                // ],
                              ),
                            ),
                            onTap: () {
                              C.filterProduct(A.data[index].name);
                            },
                          ),
                      itemCount: x.data.length)),
            );
          },
        ),
        GetX<ProductsController>(
          init: ProductsController(),
          initState: (_) {},
          builder: (_) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            C.data[index].name.toUpperCase(),
                            // overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            f.format(C.data[index].price).toString(),
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(5.0),
                    // color: Colors.yellow,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber[100],
                      // image: DecorationImage(
                      //     colorFilter: new ColorFilter.mode(
                      //         Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      //     image: NetworkImage(
                      //         "https://e7.pngegg.com/pngimages/165/189/png-clipart-food-bowl-computer-icons-soup-menu-soup-food.png"),
                      //     fit: BoxFit.cover),
                      border: Border.all(color: Colors.amber, width: 3),
                      // boxShadow: [
                      //   BoxShadow(color: Colors.amber, spreadRadius: 3),
                      // ],
                    ),
                  ),
                  onTap: () {
                    _productNameController.text = C.data[index].name;
                    _productPriceController.text =
                        C.data[index].price.toString();
                    _productSubtotalController.text = "0";
                    _productQtyController.text = "0";
                    _cartFormDialog(context, C.data[index].id);
                  },
                ),
                childCount: C.data.length,
              ),
            );
          },
        ),
      ],
    );
  }

  _cartFormDialog(BuildContext context, id) {
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_productQtyController.text != "0") {
                  T.saveData(
                    id,
                    _productNameController.text,
                    double.parse(_productPriceController.text),
                    int.parse(_productQtyController.text),
                    double.parse(_productSubtotalController.text),
                  );
                  Get.back();
                }
              },
              child: Text(
                'ADD CART',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Center(child: Text('ADD CART')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  enabled: false,
                  controller: _productNameController,
                  decoration: InputDecoration(
                      hintText: "Input Name", labelText: "Name"),
                ),
                TextField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _productPriceController,
                  decoration: InputDecoration(
                      hintText: "Input Price", labelText: "Price"),
                ),
                TextField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _productSubtotalController,
                  decoration: InputDecoration(
                      hintText: "Subtotal", labelText: "SubTotal"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (int.parse(_productQtyController.text) > 1) {
                            _productQtyController.text =
                                (int.parse(_productQtyController.text) - 1)
                                    .toString();
                            _productSubtotalController.text =
                                (double.parse(_productPriceController.text) *
                                        int.parse(_productQtyController.text))
                                    .toString();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: TextField(
                          enabled: false,
                          textAlign: TextAlign.center,
                          controller: _productQtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "Qty"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _productQtyController.text =
                              (int.parse(_productQtyController.text) + 1)
                                  .toString();
                          _productSubtotalController.text =
                              (double.parse(_productPriceController.text) *
                                      int.parse(_productQtyController.text))
                                  .toString();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
