import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/extender/print.dart';
import 'package:untitled2/models/cart.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/ui/settings/printer.dart';
import '../home.dart';

class Success extends StatelessWidget {
  Success(
      {required this.invoice,
      required this.name,
      required this.subtotal,
      required this.tax,
      required this.discount,
      required this.total,
      required this.date,
      required this.type,
      required this.money,
      required this.change,
      required this.carts,
      required this.stores});

  final String invoice;
  final String name;
  final String subtotal;
  final String tax;
  final String discount;
  final String total;
  final int date;
  final String type;
  final String money;
  final String change;
  final List<Carts> carts;
  final List<Stores> stores;

  final printer = Print();

  final f = NumberFormat("Rp #,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'PAYMENT SUCCESS',
                      style: TextStyle(color: Colors.amber[600], fontSize: 30),
                    ),
                    Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.amber[600],
                      size: 200,
                    ),
                    Text(
                      'Number Invoice ' + invoice,
                      style: TextStyle(color: Colors.greenAccent[700]),
                    ),
                    Text(
                      'Total ' + f.format(double.parse(total)),
                      style: TextStyle(color: Colors.greenAccent[700]),
                    ),
                    Text(
                      type + " " + f.format(double.parse(money)),
                      style: TextStyle(color: Colors.greenAccent[700]),
                    ),
                    Text(
                      'Change ' + f.format(double.parse(change)),
                      style: TextStyle(
                          color: Colors.greenAccent[700], fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await printTicket(
                            context,
                            stores,
                            carts,
                            date,
                            invoice,
                            subtotal,
                            tax,
                            discount,
                            total,
                            type,
                            money,
                            change);
                        print(carts.length);
                        print(stores.length);
                        print(discount);
                        // _getDetailsInv(invoice);
                      },
                      child: Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber[600],
                        ),
                        child: Center(
                          child: Text(
                            'PRINT BILL',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(HomeScreen());
                      },
                      child: Container(
                        height: 40,
                        width: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.greenAccent[700],
                        ),
                        child: Center(
                          child: Text(
                            'FINISH',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Future<void> printTicket(context, stores, carts, date, invoice, subtotal, tax,
      discount, total, type, money, change) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await printer.getTicket(stores, carts, [], name, date,
          invoice, subtotal, tax, discount, total, type, money, change, false);
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      _failed(context);
    }
  }

  _failed(context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (params) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'close',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Printer()));
              },
              child: Text(
                'SetUp Printer',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.highlight_off,
                  color: Colors.red[600],
                  size: 200,
                ),
                Text(
                  "Printer Not Connected, Please Connecting",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
