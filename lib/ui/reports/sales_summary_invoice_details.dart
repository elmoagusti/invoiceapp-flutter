import 'dart:io';
import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:intl/intl.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/services/main_service.dart';
import 'package:untitled2/services/transaction_details_service.dart';
import 'package:untitled2/services/transaction_service.dart';
import 'package:untitled2/ui/reports/sales_summary_invoice.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart';

class InvoiceDetails extends StatefulWidget {
  final String invoice;

  const InvoiceDetails({
    Key? key,
    required this.invoice,
  }) : super(key: key);

  @override
  _InvoiceDetailsState createState() => _InvoiceDetailsState(invoice);
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  String invoice;
  var f = NumberFormat("Rp #,##0.00", "en_US");

  _InvoiceDetailsState(this.invoice);

  List<Transaction> _transactionList = <Transaction>[];
  var _transactionService = TransactionService();

  List<TransactionDetails> _detailList = <TransactionDetails>[];
  var _detailService = DetailService();

  @override
  void initState() {
    super.initState();
    _getDetailsInv(invoice);
    _getInv(invoice);
    getMains();
  }

  _getInv(inv) async {
    _transactionList = <Transaction>[].toList();
    var datas = await _transactionService.readDatabyInv(inv);
    datas.forEach((data) {
      setState(() {
        var dataModel = Transaction();
        dataModel.id = data['id'];
        dataModel.name = data['name'];
        dataModel.date = data['date'];
        dataModel.noinvoice = data['noinvoice'];
        dataModel.subtotal = data['subtotal'];
        dataModel.discount = data['discount'];
        dataModel.tax = data['tax'];
        dataModel.nettotal = data['nettotal'];
        dataModel.type = data['type'];
        dataModel.money = data['money'];
        dataModel.change = data['change'];

        _transactionList.add(dataModel);
      });
    });
    print(datas);
  }

  var _mainService = MainService();
  List<Mains> _mainList = <Mains>[];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SalesInvoice()));
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.amber[600], elevation: 0.0),
        ),
        actions: [],
        title: Text('Detail Transaction'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                itemExtent: 140,
                scrollDirection: Axis.vertical,
                itemCount: _transactionList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Card(
                      elevation: 15,
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: Container(
                                child: Text(
                                    // _productList[index].name!,
                                    _transactionList[index]
                                            .noinvoice
                                            .toString() +
                                        "  " +
                                        _transactionList[index].name.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Container(
                              child: Text(
                                  _transactionList[index].type.toString(),
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ],
                        ),
                        subtitle: Text("\n" +
                            "SubTotal: " +
                            f.format(_transactionList[index].subtotal) +
                            "\n" +
                            "Discount: " +
                            f.format(_transactionList[index].discount) +
                            "\n" +
                            "NetTotal: " +
                            f.format(_transactionList[index].nettotal) +
                            "\n" +
                            "Money: " +
                            f.format(_transactionList[index].money) +
                            "\n" +
                            "Change: " +
                            f.format(_transactionList[index].change)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 700,
              child: ListView.builder(
                itemExtent: 75,
                scrollDirection: Axis.vertical,
                itemCount: _detailList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Card(
                      // elevation: 11,
                      child: ListTile(
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                    child: Text(
                                  _detailList[index].name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 13),
                                )),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Text(f.format(_detailList[index].total),
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          subtitle: Text(
                            _detailList[index].qty.toString() +
                                " x " +
                                f.format(_detailList[index].price),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 11),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  'PRINT STRUK',
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
                  'VOID',
                  style: TextStyle(
                      color: Colors.amber[900], fontWeight: FontWeight.w900),
                ),
                onPressed: () {
                  _removeFormDialog(context, invoice);
                }),
          ],
        ),
      ),
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

      for (var i = 0; i < _transactionList.length; i++) {
        bytes += generator.text(
          DateFormat('yyyy-MM-dd HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(_transactionList[i].date!)),
          styles: PosStyles(
            align: PosAlign.right,
            bold: true,
          ),
        );
        bytes += generator.text(
          "Invoice: " + _transactionList[i].noinvoice.toString(),
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
        if (_mainList[i].header != "") {
          bytes += generator.text("${_mainList[i].header}",
              styles: PosStyles(align: PosAlign.center));
        }
        bytes += generator.text(
          "NAME: ${_transactionList[i].name}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ),
        );

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
          "SubTotal: ${f.format(_transactionList[i].subtotal)}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );
        if (_mainList[i].tax != 0) {
          bytes += generator.text(
            "Tax: ${f.format(_transactionList[i].tax)} (${_mainList[i].tax.toString()}%)",
            styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
        }
        bytes += generator.text(
          "Discount: ${f.format(_transactionList[i].discount)}",
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
              text: f.format(_transactionList[i].nettotal),
              width: 6,
              styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size2,
                width: PosTextSize.size1,
              )),
        ]);
        bytes += generator.text(
          "PAID ${_transactionList[i].type} : ${f.format(_transactionList[i].money)}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        );
        bytes +=
            generator.text("Change : ${f.format(_transactionList[i].change)}",
                styles: PosStyles(
                  align: PosAlign.left,
                  bold: true,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                ),
                linesAfter: 1);
      }

      if (_mainList[i].footer != "") {
        bytes += generator.text("${_mainList[i].footer}",
            styles: PosStyles(align: PosAlign.center), linesAfter: 1);
      }

      bytes += generator.text(
        "*****COPY STRUK*****",
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
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

  _removeFormDialog(BuildContext context, inv) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _transactionService.delete(inv);
                await _detailService.delete(inv);
                _getInv(invoice);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SalesInvoice()));
                // _showSnackbar(Text("Deleted"));
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Text('Confirm Delete'),
        );
      },
    );
  }
}
