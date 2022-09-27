import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/cart.dart';
import 'package:untitled2/controller/helper.dart';
import 'package:untitled2/controller/products.dart';
import 'package:untitled2/controller/store.dart';
import 'package:untitled2/controller/transaction.dart';
import 'package:untitled2/controller/type_payment.dart';
import 'package:untitled2/models/cart.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/repo/sharedprefs.dart';

import '../home.dart';
import 'success.dart';

class PaymentScreen extends StatelessWidget {
  final P = Get.put(ProductsController());
  final S = Get.put(StoresController());
  final T = Get.put(TypePaymentController());
  final C = Get.put(CartsController());
  final trx = Get.put(TransactionsController());
  final dtn = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  final _controllerName = TextEditingController(text: "Guest");
  final _controllerSubtotal = TextEditingController();
  final _controllerTax = TextEditingController();

  final _controllerDiscount = TextEditingController(text: "0");
  final _controllerTotal = TextEditingController();
  final _controllerInvoice = TextEditingController();
  final _controllertype = TextEditingController();

  final _controllerMoney = TextEditingController();
  final _controllerChange = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //helper
    int typeId;
    bool tap = false;
    _controllerSubtotal.text = C.subtot.toInt().toString();
    _controllertype.text = T.data[0].name;
    _controllerInvoice.text = trx.noinvoice.value;
    typeId = T.data[0].id;
    if (S.data[0].typetax == 1) {
      var a = C.subtot * S.data[0].tax / 100;
      _controllerTax.text = a.toInt().toString();

      _controllerTotal.text = (a + C.subtot.value).toInt().toString();
      _controllerMoney.text = (a + C.subtot.value).toInt().toString();
    } else {
      var a = C.subtot * S.data[0].tax / 100;

      _controllerTax.text = a.toInt().toString();

      _controllerTotal.text = C.subtot.toInt().toString();
      _controllerMoney.text = C.subtot.toInt().toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.amber[600], elevation: 0.0),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.monetization_on,
              color: Colors.white,
            ),
            onPressed: () async {
              // int a = await SharedPref.getData();
              // print(trx.no);
              trx.noUp();
              // print(trx.noinvoice.value);
              // print(a);
              // await SharedPref.saveData(a + 1);
            },
          ),
        ],
        title: Text('PAYMENT'),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      enabled: false,
                      controller: _controllerInvoice,
                      decoration: InputDecoration(
                          hintText: "INVOICE", labelText: "invoice"),
                    ),
                    TextField(
                      controller: _controllerName,
                      decoration: InputDecoration(
                          hintText: "Input Name", labelText: "Name"),
                      onTap: () => _controllerName.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controllerName.text.length,
                      ),
                    ),
                    TextField(
                      enabled: false,
                      controller: _controllerSubtotal,
                      decoration: InputDecoration(
                        hintText: "SubTotal",
                        labelText: "SubTotal",
                      ),
                    ),
                    TextField(
                      enabled: false,
                      controller: _controllerTax,
                      decoration: InputDecoration(
                        labelText: S.data[0].typetax == 1
                            ? "tax exclusive ${S.data[0].tax} %"
                            : "tax inclusive ${S.data[0].tax} %",
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 150.0,
                          height: 50.0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _controllerDiscount,
                            decoration: InputDecoration(
                                // focusColor: Colors.amber,
                                hintStyle: TextStyle(
                                  color: Colors.amber,
                                ),
                                labelText: "Rp"),
                            onTap: () =>
                                _controllerDiscount.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _controllerDiscount.text.length,
                            ),
                            onChanged: (value) {
                              if (S.data[0].typetax == 1) {
                                var a = C.subtot * S.data[0].tax / 100;

                                if (_controllerDiscount.text == "") {
                                  _controllerTotal.text =
                                      (a + C.subtot.toInt()).toInt().toString();
                                  _controllerMoney.text =
                                      (a + C.subtot.toInt()).toInt().toString();
                                } else {
                                  _controllerTotal.text = (a +
                                          C.subtot.toInt() -
                                          int.parse(_controllerDiscount.text))
                                      .toInt()
                                      .toString();
                                  _controllerMoney.text = (a +
                                          C.subtot.toInt() -
                                          int.parse(_controllerDiscount.text))
                                      .toInt()
                                      .toString();
                                }
                              } else {
                                if (_controllerDiscount.text == "") {
                                  _controllerTotal.text =
                                      C.subtot.toInt().toString();
                                  _controllerMoney.text =
                                      C.subtot.toInt().toString();
                                  _controllerDiscount.text = "0";
                                } else {
                                  _controllerTotal.text = (C.subtot.toInt() -
                                          int.parse(_controllerDiscount.text))
                                      .toString();
                                  _controllerMoney.text = (C.subtot.toInt() -
                                          int.parse(_controllerDiscount.text))
                                      .toString();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      enabled: false,
                      controller: _controllerTotal,
                      decoration: InputDecoration(
                        hintText: "Total",
                        labelText: "Total",
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10.0),
                    color: Colors.amber[600],
                    width: 120.0,
                    height: 50.0,
                    child: TextField(
                      enabled: false,
                      controller: _controllertype,
                      decoration: InputDecoration(),
                    ),
                  ),
                  Container(
                    width: 150.0,
                    height: 50.0,
                    child: TextField(
                      onTap: () {
                        _controllerMoney.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controllerMoney.text.length);
                      },
                      keyboardType: TextInputType.number,
                      controller: _controllerMoney,
                      decoration: InputDecoration(
                        labelText: "Money Customer",
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: T.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(2),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber[200]),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            child: Text(
                              T.data[index].name.toString(),
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                            onPressed: () {
                              _controllertype.text = T.data[index].name;
                              typeId = T.data[index].id;
                            },
                          ),
                        );
                      })),
              TextButton(
                onPressed: () async {
                  if (tap != true) {
                    _controllerChange.text =
                        (double.parse(_controllerMoney.text) -
                                double.parse(_controllerTotal.text))
                            .toString();

                    print('success save transaction, count++ and delete carts');

                    await trx.savetrx(
                        _controllerInvoice.text,
                        _controllerName.text,
                        _controllerTax.text,
                        _controllerSubtotal.text,
                        _controllerDiscount.text,
                        _controllerTotal.text,
                        DateTime.parse(dtn).millisecondsSinceEpoch,
                        typeId,
                        _controllertype.text,
                        _controllerMoney.text,
                        _controllerChange.text,
                        C.data);
                    await Get.off(() => Success(
                          invoice: _controllerInvoice.text,
                          name: _controllerName.text,
                          subtotal: _controllerSubtotal.text,
                          discount: _controllerDiscount.text,
                          tax: _controllerTax.text,
                          total: _controllerTotal.text,
                          date: DateTime.parse(dtn).millisecondsSinceEpoch,
                          type: _controllertype.text,
                          money: _controllerMoney.text,
                          change: _controllerChange.text,
                          carts: C.data,
                          stores: S.data,
                        ));
                    tap = true;
                    C.deleteData();
                    trx.noUp();
                  }
                },
                child: Container(
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber[600],
                  ),
                  child: Center(
                    child: Text(
                      'PAYMENT',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
