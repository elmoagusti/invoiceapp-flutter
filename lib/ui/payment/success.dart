import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:intl/intl.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/services/main_service.dart';
import 'package:untitled2/services/transaction_details_service.dart';
import 'package:image/image.dart';

import '../home.dart';

class Success extends StatefulWidget {
  final String invoice;
  final String name;
  final String subtotal;
  final String tax;
  final String discount;
  final String total;
  final String date;
  final String type;
  final String money;
  final String change;

  const Success({
    Key? key,
    required this.invoice,
    required this.name,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    required this.date,
    required this.type,
    required this.money,
    required this.change,
  }) : super(key: key);

  @override
  _SuccessState createState() => _SuccessState(
      invoice, name, subtotal, tax, discount, total, date, type, money, change);
}

class _SuccessState extends State<Success> {
  //mains
  var _mainService = MainService();
  List<Mains> _mainList = <Mains>[];
  //details
  var f = NumberFormat("Rp #,##0.00", "en_US");
  List<TransactionDetails> _detailList = <TransactionDetails>[];
  var _detailService = DetailService();

  String invoice;
  String name;
  String subtotal;
  String tax;
  String discount;
  String total;
  String date;
  String type;
  String money;
  String change;
  _SuccessState(this.invoice, this.name, this.subtotal, this.tax, this.discount,
      this.total, this.date, this.type, this.money, this.change);

  @override
  void initState() {
    super.initState();
    _getDetailsInv(invoice);
    getMains();
  }

  getMains() async {
    _mainList = <Mains>[].toList();
    var mains = await _mainService.readMain();
    mains.forEach((a) {
      setState(() {
        var mainModel = Mains();
        mainModel.outlet = a['outlet'];
        mainModel.store = a['store'];
        mainModel.address = a['address'];
        mainModel.phone = a['phone'];
        mainModel.tax = a['tax'];
        mainModel.header = a['header'];
        mainModel.footer = a['footer'];
        mainModel.logo = a['logo'];
        mainModel.id = a['id'];
        _mainList.add(mainModel);
      });
    });
    print(mains);
  }

  _getDetailsInv(inv) async {
    _detailList = <TransactionDetails>[].toList();
    var datas = await _detailService.readDatabyInv(inv);
    datas.forEach((data) {
      setState(() {
        var dataModel = TransactionDetails();
        dataModel.id = data['id'];
        dataModel.name = data['name'];
        dataModel.noinvoice = data['noinvoice'];
        dataModel.price = data['price'];
        dataModel.qty = data['qty'];
        dataModel.total = data['total'];
        _detailList.add(dataModel);
      });
    });
    print(datas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
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
                        await printTicket();
                        _getDetailsInv(invoice);
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
                      onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => HomeScreen())),
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

  Future<void> printTicket() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getTicket();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      _failed();
    }
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    for (var i = 0; i < _mainList.length; i++) {
      //images logo
      if (_mainList[i].logo != "") {
        final File path = File(_mainList[i].logo.toString());
        final Uint8List a = path.readAsBytesSync();
        final Image? images = decodeImage(a);

        bytes += generator.image(images!);
      }
      //named store
      if (_mainList[i].store != "") {
        bytes += generator.text("${_mainList[i].store}",
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            ),
            linesAfter: 1);
      }
      //datenow
      bytes += generator.text(
        date,
        styles: PosStyles(
          align: PosAlign.right,
          bold: true,
        ),
      );
      bytes += generator.text(
        "Invoice: " + invoice,
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
      if (_mainList[i].outlet != "") {
        bytes += generator.text(
          "Outlet: ${_mainList[i].outlet}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );
      }
      if (_mainList[i].address != "") {
        bytes += generator.text(
          "Address: ${_mainList[i].address}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );
      }
      if (_mainList[i].phone != "") {
        bytes += generator.text(
          "Phone: ${_mainList[i].phone}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );
      }
      bytes += generator.text(
        "NAME: " + name,
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size1,
        ),
      );
      if (_mainList[i].header != "") {
        bytes += generator.text("${_mainList[i].header}",
            styles: PosStyles(align: PosAlign.center));
      }

      bytes += generator.hr(ch: '=');
      for (var i = 0; i < _detailList.length; i++) {
        bytes += generator.text(
          "@ ${_detailList[i].name}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          ),
        );
        bytes += generator.row([
          PosColumn(
              text: "${_detailList[i].qty} x ${_detailList[i].price}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: "${f.format(_detailList[i].total)}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
        ]);
      }
      bytes += generator.hr(ch: '=', linesAfter: 1);

      bytes += generator.text(
        "SubTotal: ${f.format(double.parse(subtotal))}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
      if (_mainList[i].tax != 0) {
        bytes += generator.text(
          "Tax: ${f.format(double.parse(tax))} (${_mainList[i].tax}%)",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );
      }
      bytes += generator.text(
        "Discount: ${f.format(double.parse(discount))}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
      bytes += generator.row([
        PosColumn(
            text: 'TOTAL',
            width: 6,
            styles: PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size2,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: f.format(double.parse(total)),
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size1,
            )),
      ]);
      bytes += generator.text(
        "PAID ${type.toString()} : ${f.format(double.parse(money))}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
      bytes += generator.text("Change : ${f.format(double.parse(change))}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
          linesAfter: 1);
      if (_mainList[i].footer != "") {
        bytes += generator.text("${_mainList[i].footer}",
            styles: PosStyles(align: PosAlign.center));
      }
      bytes += generator.drawer();
      bytes += generator.cut();
    }
    return bytes;
  }

  _failed() {
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
                style: TextStyle(color: Colors.red),
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
