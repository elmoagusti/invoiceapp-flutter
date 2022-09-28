import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/products.dart';
import 'package:untitled2/controller/type_payment.dart';

import '../../controller/transaction.dart';
import 'sales_summary_invoice.dart';
import 'package:untitled2/extender/print.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

class SalesSummary extends StatelessWidget {
  final product = Get.put(ProductsController());
  final trx = Get.put(TransactionsController());
  final typePay = Get.put(TypePaymentController());

  final f = NumberFormat("Rp #,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        actions: [],
        title: Text('SALES SUMMARY'),
      ),
      body: GetX<TransactionsController>(
        init: TransactionsController(),
        initState: (_) {},
        builder: (_) {
          return ListView(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Text('Sales Summary: ',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: Colors.greenAccent[700])),
                    Text(
                      trx.dateNow,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.greenAccent[700]),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'SubTotal: ' + f.format(trx.subtotal.value).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.amber[600]),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Tax: ' + f.format(trx.tax.value).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.amber[600]),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Discount: ' + f.format(trx.discount.value).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: Colors.amber[600]),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.fromLTRB(20, 10, 0, 30),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Net Total: ' + f.format(trx.nettotal.value).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 19,
                          color: Colors.greenAccent[700]),
                    ),
                  ],
                ),
              ),
              typePay.data.isEmpty
                  ? Text('')
                  : Container(
                      padding: EdgeInsets.all(5),
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: typePay.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.amber[200]),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  typePay.data[index].name.toString(),
                                  style: TextStyle(
                                      color: Colors.amber[900],
                                      fontWeight: FontWeight.w900),
                                ),
                                onPressed: () {
                                  trx.filter(typePay.data[index].id);
                                },
                              ),
                            );
                          })),
              Container(
                padding: EdgeInsets.all(50),
                height: 500,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Settlement " + typePay.data[0].name,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.greenAccent[700],
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        f.format(trx.settlement.value),

                        // f.format(filter),
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.greenAccent[700],
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 30,
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber[200]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text(
                  'PRINT SALES',
                  style: TextStyle(
                      color: Colors.amber[900], fontWeight: FontWeight.w900),
                ),
                onPressed: () async {
                  await printTicket();
                }),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber[200]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              child: Text(
                'DETAIL TRANSACTIONS',
                style: TextStyle(
                    color: Colors.amber[900], fontWeight: FontWeight.w900),
              ),
              onPressed: () => Get.to(SalesInvoice()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await Print().getSettlement(
          trx.dateNow,
          trx.subtotal.value,
          trx.discount.value,
          trx.tax.value,
          trx.nettotal.value,
          typePay.data,
          trx.data,
          trx.dataDetail,
          product.data);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      // _failed();
    }
  }
}
