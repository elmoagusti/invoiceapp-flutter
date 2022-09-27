import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/transaction.dart';
import 'package:untitled2/extender/print.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/services/main_service.dart';
import 'package:untitled2/services/transaction_details_service.dart';
import 'package:untitled2/services/transaction_service.dart';
import 'package:untitled2/ui/reports/sales_summary_invoice.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart';

import '../../controller/store.dart';

// class InvoiceDetails extends StatefulWidget {
//   final String invoice;

//   const InvoiceDetails({
//     Key? key,
//     required this.invoice,
//   }) : super(key: key);

//   @override
//   _InvoiceDetailsState createState() => _InvoiceDetailsState(invoice);
// }

class InvoiceDetails extends StatelessWidget {
  final trx = Get.put(TransactionsController());
  final f = NumberFormat("Rp #,##0", "en_US");
  InvoiceDetails({required this.data, required this.detail});
  final main = Get.put(StoresController());
  final List<Transactions> data;
  final List<TransactionDetail> detail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        // leading: ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => SalesInvoice()));
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        //   style: ElevatedButton.styleFrom(
        //       primary: Colors.amber[600], elevation: 0.0),
        // ),
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
                itemCount: data.length,
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
                                    data[index].noinvoice.toString() +
                                        "  " +
                                        data[index].name.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                            Container(
                              child: Text(data[index].typeName.toString(),
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ],
                        ),
                        subtitle: Text("\n" +
                            "SubTotal: " +
                            f.format(data[index].subtotal) +
                            "\n" +
                            "Discount: " +
                            f.format(data[index].discount) +
                            "\n" +
                            "NetTotal: " +
                            f.format(data[index].nettotal) +
                            "\n" +
                            "Money: " +
                            f.format(data[index].money) +
                            "\n" +
                            "Change: " +
                            f.format(data[index].change)),
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
                itemCount: detail.length,
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
                                  detail[index].name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 13),
                                )),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Text(f.format(detail[index].total),
                                  style: TextStyle(fontSize: 13))
                            ],
                          ),
                          subtitle: Text(
                            detail[index].qty.toString() +
                                " x " +
                                f.format(detail[index].price),
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
                  await printTicket(context);
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
                  _removeFormDialog(context, data[0].id);
                }),
          ],
        ),
      ),
    );
  }

  Future<void> printTicket(context) async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await Print().getTicket(
        main.data,
        [],
        detail,
        data[0].name,
        data[0].date,
        data[0].noinvoice,
        data[0].subtotal.toString(),
        data[0].tax.toString(),
        data[0].discount.toString(),
        data[0].nettotal.toString(),
        data[0].typeName.toString(),
        data[0].money.toString(),
        data[0].change.toString(),
        true,
      );
      await BluetoothThermalPrinter.writeBytes(bytes);
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

  _removeFormDialog(BuildContext context, id) {
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
                await trx.deletetrx(id);
                Get.back();
                Get.back();
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
