import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/store.dart';
import 'package:untitled2/controller/type_payment.dart';
import 'package:untitled2/ui/payment/index.dart';
import 'package:untitled2/ui/reports/sales_summary.dart';
import 'package:untitled2/ui/settings/mains.dart';
import 'package:untitled2/ui/settings/printer.dart';
import 'package:untitled2/ui/type_payment/index.dart';
import '../controller/cart.dart';
import '../ui/category/index.dart';
import '../ui/product/index.dart';

class DrawerNavigate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('devE AEGIS Technology'),
              accountEmail: Text('WhatsApp: +62 859 1069 610'),
              decoration: BoxDecoration(color: Colors.amber[600]),
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: Colors.amber,
              ),
              title: Align(
                child: Text('Sales Summary'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Get.to(SalesSummary()),
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
              title: Align(
                child: Text('Product Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Get.to(ProductScreen()),
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle_outline,
                color: Colors.blue[400],
              ),
              title: Align(
                child: Text('Category Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Get.to(CategoryScreen()),
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.cyan,
              ),
              title: Align(
                child: Text('Payment Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Get.to(PaymentTypeScreen()),
            ),
            ListTile(
              leading: Icon(
                Icons.add_business,
                color: Colors.red,
              ),
              title: Align(
                child: Text('Store Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () {
                Get.to(MainScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.deepPurple,
              ),
              title: Align(
                child: Text('Printer Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Get.to(Printer()),
            ),
          ],
        ),
      ),
    );
  }
}

class CartNavigate extends StatelessWidget {
  final A = Get.put(CartsController());
  final M = Get.put(StoresController());
  final P = Get.put(TypePaymentController());
  final f = NumberFormat("Rp #,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: GetX<CartsController>(
      init: CartsController(),
      builder: (_) {
        return Container(
          color: Colors.amber[600],
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: A.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        A.data.isEmpty
                            ? Text('')
                            : Padding(
                                padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                child: GestureDetector(
                                  onHorizontalDragEnd: (details) =>
                                      A.deleList(A.data[index].name),
                                  child: Card(
                                    // color: Colors.orange,
                                    elevation: 11,
                                    child: ListTile(
                                      title: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                                child: Text(
                                              A.data[index].name,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            )),
                                          ),
                                          Spacer(
                                            flex: 2,
                                          ),
                                          Container(
                                              child: Text(
                                            f.format(A.data[index].total),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                        ],
                                      ),
                                      subtitle: Text(
                                        A.data[index].qty.toString() +
                                            ' x ' +
                                            f.format(
                                              A.data[index].price,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
              detail(context),
            ],
          ),
        );
      },
    ));
  }

  detail(BuildContext context) {
    return Container(
      child: Align(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              title: Align(
                child: Text('Clear All Carts'),
                alignment: Alignment(-1.4, 0),
              ),
              onTap: () {
                A.deleteData();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.local_atm,
                color: Colors.green,
                size: 40,
              ),
              title: Align(
                alignment: Alignment(-1.2, 0),
                child: Text('SubTotal: ' + f.format(A.subtot.value),
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              onTap: () async {
                // print(_subTotal);
              },
            ),
            TextButton(
              onPressed: () async {
                // _cartList.isEmpty
                if (A.data.isEmpty) {
                  message(context, "Carts is Empty");
                } else if (M.data.isEmpty) {
                  message(context, "Store data is Empty");
                } else if (P.data.isEmpty) {
                  message(context, "Type payment is Empty");
                } else {
                  Get.to(PaymentScreen());
                }
              },
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'PAYMENT',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  message(BuildContext context, msg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                right: -40.0,
                top: -40.0,
                child: InkResponse(
                  onTap: () {
                    Get.back();
                  },
                  child: CircleAvatar(
                    child: Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              Text(msg),
            ],
          ),
        );
      },
    );
  }
}
