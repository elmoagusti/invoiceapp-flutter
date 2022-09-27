import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/products.dart';
import 'package:untitled2/controller/type_payment.dart';

import '../../controller/transaction.dart';
import 'sales_summary_invoice.dart';
import 'package:untitled2/extender/print.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

// class SalesSummary extends StatefulWidget {
//   const SalesSummary({Key? key}) : super(key: key);

//   @override
//   _SalesSummaryState createState() => _SalesSummaryState();
// }

class SalesSummary extends StatelessWidget {
  final product = Get.put(ProductsController());
  final trx = Get.put(TransactionsController());
  final typePay = Get.put(TypePaymentController());
  // double subTotal = 0;
  // double discount = 0;
  // double tax = 0;
  // double netTotal = 0;

  // var _productService = ProductService();

  // List<Product> _productList = <Product>[];

  // List<TransactionDetails> _detailList = <TransactionDetails>[];
  // var _detailService = DetailService();

  // //filter
  // String? ff;
  // double filter = 0;
  // var datenow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  // List<TypePayment> _payList = <TypePayment>[];
  // var _payService = TypePaymentService();

  // var _transactionService = TransactionService();
  final f = NumberFormat("Rp #,##0.00", "en_US");

  // List<Transaction> _transaksiList = <Transaction>[];

  // var a = DateFormat('yyyy-MM-dd 00:01:01.000').format(DateTime.now());
  // var b = DateFormat('yyyy-MM-dd 23:59:59.999').format(DateTime.now());

  // @override
  // void initState() {
  //   super.initState();
  //   getAllpay();
  //   getAllinvoice();
  //   getAllProducts();
  //   getDetailinvoice();
  // }

  // getAllProducts() async {
  //   _productList = <Product>[].toList();
  //   var products = await _productService.readProduct();
  //   products.forEach((product) {
  //     setState(() {
  //       var productModel = Product();
  //       productModel.name = product['name'];
  //       productModel.id = product['id'];
  //       _productList.add(productModel);
  //     });
  //   });
  //   print(products);
  // }

  // getAllpay() async {
  //   _payList = <TypePayment>[].toList();
  //   var payments = await _payService.readPay();
  //   payments.forEach((a) {
  //     setState(() {
  //       var payModel = TypePayment();
  //       payModel.name = a['name'];
  //       payModel.id = a['id'];
  //       _payList.add(payModel);
  //     });
  //   });
  // }

  // getDetailinvoice() async {
  //   int start = (DateTime.parse(a).millisecondsSinceEpoch);
  //   int end = (DateTime.parse(b).millisecondsSinceEpoch);
  //   _detailList = <TransactionDetails>[].toList();
  //   var transaksi = await _detailService.sortbyDate(start, end);
  //   transaksi.forEach((transaction) {
  //     setState(() {
  //       var transaksiModel = TransactionDetails();
  //       transaksiModel.id = transaction['id'];
  //       transaksiModel.name = transaction['name'];
  //       transaksiModel.qty = transaction['qty'];
  //       transaksiModel.date = transaction['date'];
  //       _detailList.add(transaksiModel);
  //     });
  //   });
  //   print(transaksi);
  // }

  // getAllinvoice() async {
  //   int start = (DateTime.parse(a).millisecondsSinceEpoch);
  //   int end = (DateTime.parse(b).millisecondsSinceEpoch);
  //   _transaksiList = <Transaction>[].toList();
  //   var transaksi = await _transactionService.sortbyDate(start, end);
  //   transaksi.forEach((transaction) {
  //     setState(() {
  //       var transaksiModel = Transaction();
  //       transaksiModel.id = transaction['id'];
  //       transaksiModel.name = transaction['name'];
  //       transaksiModel.noinvoice = transaction['noinvoice'];
  //       transaksiModel.subtotal = transaction['subtotal'];
  //       transaksiModel.discount = transaction['discount'];
  //       transaksiModel.tax = transaction['tax'];
  //       transaksiModel.nettotal = transaction['nettotal'];
  //       transaksiModel.type = transaction['type'];
  //       // transaksiModel.money = transaction['money'];
  //       // transaksiModel.change = transaction['change'];
  //       transaksiModel.date = transaction['date'];
  //       _transaksiList.add(transaksiModel);
  //     });
  //   });
  //   print(transaksi);
  //   double subt = 0;
  //   double disc = 0;
  //   double t = 0;
  //   double total = 0;
  //   for (var i = 0; i < _transaksiList.length; i++) {
  //     subt += double.parse(_transaksiList[i].subtotal.toString());
  //     disc += double.parse(_transaksiList[i].discount.toString());
  //     t += double.parse(_transaksiList[i].tax.toString());
  //     total += double.parse(_transaksiList[i].nettotal.toString());

  //     subTotal = subt;
  //     discount = disc;
  //     tax = t;
  //     netTotal = total;
  //   }
  // }

  // _filter(ff) {
  //   double n = 0;
  //   var elmo = _transaksiList.where((data) => data.type == ff);
  //   elmo.forEach((element) {
  //     n += double.parse(element.nettotal.toString());
  //     print(element.nettotal);
  //   });
  //   // print(n);
  //   filter = n;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        // leading: ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => HomeScreen()));
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        //   style: ElevatedButton.styleFrom(
        //       primary: Colors.amber[600], elevation: 0.0),
        // ),
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
                      // color: Colors.red,
                      // width: 1000,
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
                                  // setState(() {
                                  //   ff = _payList[index].name.toString();
                                  //   _filter(ff);

                                  // });
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
                          // "Settlement " + ff.toString(),

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
