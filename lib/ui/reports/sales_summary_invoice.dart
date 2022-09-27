import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/store.dart';
import 'package:untitled2/controller/transaction.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/ui/reports/sales_summary.dart';
import 'package:untitled2/ui/reports/sales_summary_invoice_details.dart';
import 'package:get/get.dart';

class SalesInvoice extends StatelessWidget {
  final trx = Get.put(TransactionsController());

  final f = NumberFormat("Rp #,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        // leading: ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => SalesSummary()));
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        //   style: ElevatedButton.styleFrom(
        //       primary: Colors.amber[600], elevation: 0.0),
        // ),
        actions: [],
        title: Text('Transaction'),
      ),
      body: GetX<TransactionsController>(
        init: TransactionsController(),
        initState: (_) {},
        builder: (_) {
          return ListView.builder(
            itemCount: trx.data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                child: Card(
                  margin: EdgeInsets.all(5),
                  elevation: 11,
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                trx.data[index].noinvoice.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Text(
                          trx.data[index].typeName.toString(),
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  trx.data[index].date!)) +
                          "\n" +
                          f.format(
                            double.parse(
                              trx.data[index].nettotal.toString(),
                            ),
                          ),
                    ),
                    leading: Text(trx.data[index].name.toString()),
                    onTap: () async {
                      List<Transactions> a = trx.data
                          .where((p0) => p0.id == trx.data[index].id)
                          .toList();
                      List<TransactionDetail> b = trx.dataDetail
                          .where((p0) => p0.trxid == trx.data[index].id)
                          .toList();
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => InvoiceDetails(
                      //       data: a,
                      //       detail: b,
                      //     ),
                      //   ),
                      // );
                      Get.to(InvoiceDetails(data: a, detail: b));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
