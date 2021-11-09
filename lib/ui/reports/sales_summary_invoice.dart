import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/services/transaction_service.dart';
import 'package:untitled2/ui/reports/sales_summary.dart';
import 'package:untitled2/ui/reports/sales_summary_invoice_details.dart';

class SalesInvoice extends StatefulWidget {
  const SalesInvoice({Key? key}) : super(key: key);

  @override
  _SalesInvoiceState createState() => _SalesInvoiceState();
}

class _SalesInvoiceState extends State<SalesInvoice> {
  // initial load data
  var _transactionService = TransactionService();
  var f = NumberFormat("Rp #,##0.00", "en_US");

  List<Transaction> _transaksiList = <Transaction>[];

  var a = DateFormat('yyyy-MM-dd 00:01:01.000').format(DateTime.now());
  var b = DateFormat('yyyy-MM-dd 23:59:59.999').format(DateTime.now());

  @override
  void initState() {
    super.initState();

    getAllinvoice();
  }

  getAllinvoice() async {
    int start = (DateTime.parse(a).millisecondsSinceEpoch);
    int end = (DateTime.parse(b).millisecondsSinceEpoch);
    _transaksiList = <Transaction>[].toList();
    var transaksi = await _transactionService.sortbyDate(start, end);
    transaksi.forEach((transaction) {
      setState(() {
        var transaksiModel = Transaction();
        transaksiModel.id = transaction['id'];
        transaksiModel.name = transaction['name'];
        transaksiModel.noinvoice = transaction['noinvoice'];
        // transaksiModel.subtotal = transaction['subtotal'];
        // transaksiModel.discount = transaction['discount'];
        // transaksiModel.tax = transaction['tax'];
        transaksiModel.nettotal = transaction['nettotal'];
        transaksiModel.type = transaction['type'];
        // transaksiModel.money = transaction['money'];
        // transaksiModel.change = transaction['change'];
        transaksiModel.date = transaction['date'];
        _transaksiList.add(transaksiModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SalesSummary()));
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.amber[600], elevation: 0.0),
        ),
        actions: [],
        title: Text('Transaction'),
      ),
      body: ListView.builder(
        itemCount: _transaksiList.length,
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
                            _transaksiList[index].noinvoice.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Text(
                      _transaksiList[index].type.toString(),
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ],
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              _transaksiList[index].date!)) +
                      "\n" +
                      f.format(
                        double.parse(
                          _transaksiList[index].nettotal.toString(),
                        ),
                      ),
                ),
                leading: Text(_transaksiList[index].name.toString()),
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => InvoiceDetails(
                      invoice: _transaksiList[index].noinvoice.toString(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
