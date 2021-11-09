import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/models/type_payment.dart';
import 'package:untitled2/repo/sharedprefs.dart';
import 'package:untitled2/services/main_service.dart';
import 'package:untitled2/services/transaction_details_service.dart';
import 'package:untitled2/services/transaction_service.dart';
import 'package:untitled2/services/typepayment_service.dart';
import 'package:untitled2/ui/payment/success.dart';
import '../../models/cart.dart';
import '../../services/cart_service.dart';

import '../home.dart';

class PaymentScreen extends StatefulWidget {
  final String invoice;
  const PaymentScreen({Key? key, required this.invoice}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState(invoice);
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool tap = false;

  //mains
  var _mainService = MainService();
  int count = 0;
  var dateNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  getcounter() async {
    var data = await SharedPref.getData();
    setState(() {
      if (data != null) {
        count = data;
      }
      print(data);
      print(count);
    });
  }

  int _typetax = 0;
  double _tax = 0;
  getMains() async {
    var mains = await _mainService.readMain();
    mains.forEach((a) {
      setState(() {
        _typetax = a['typetax'];
        _tax = a['tax'];
      });
    });
    print(_typetax);
  }

  String invoice;
  _PaymentScreenState(this.invoice);

  // push details
  var _detailService = DetailService();
  var _data = TransactionDetails();

  //loaddata
  List<Cart> _cartList = <Cart>[];
  var _cartService = CartService();

  List<TypePayment> _payList = <TypePayment>[];
  var _payService = TypePaymentService();

  //form customer
  var _transactions = Transaction();
  var _transactionsService = TransactionService();

  var _controllerName = TextEditingController();
  var _controllerSubtotal = TextEditingController();
  var _controllerTax = TextEditingController();

  var _controllerDiscount = TextEditingController(text: '0');
  var _controllerTotal = TextEditingController();
  var _controllerInvoice = TextEditingController();
  var _controllertype = TextEditingController();
  var _controllerMoney = TextEditingController();
  var _controllerChange = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCart();
    getAllpay();
    getcounter();
    getMains();
  }

  getAllCart() async {
    _cartList = <Cart>[].toList();
    var carts = await _cartService.readCart();
    carts.forEach(
      (cart) {
        setState(() {
          var cartModel = Cart();
          cartModel.id = cart['id'];
          cartModel.name = cart['name'];
          cartModel.noinvoice = cart['noinvoice'];
          cartModel.price = cart['price'];
          cartModel.qty = cart['qty'];
          cartModel.total = cart['total'];
          _cartList.add(cartModel);
          _controllerName.text = 'Guest';
          _controllerInvoice.text = invoice;
        });
      },
    );
    print(carts);
  }

  getAllpay() async {
    _payList = <TypePayment>[].toList();
    var payments = await _payService.readPay();
    payments.forEach((a) {
      setState(() {
        var payModel = TypePayment();
        payModel.name = a['name'];

        payModel.id = a['id'];
        _payList.add(payModel);
      });
    });
    for (var i = 0; i < 1; i++) {
      _controllertype.text = _payList[i].name.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    double _subTotal = 0;
    double tax = 0;

    for (var i = 0; i < _cartList.length; i++) {
      _subTotal += double.parse(_cartList[i].total.toString());
      _controllerSubtotal.text = _subTotal.toString();
    }
    if (_typetax == 1) {
      tax += _subTotal * _tax / 100;
      _controllerTax.text = tax.toString();
      _controllerTotal.text = (_subTotal + tax).toString();
      _controllerMoney.text = (_subTotal + tax).toString();
    } else {
      tax += _subTotal * _tax / 100;
      _controllerTax.text = tax.toString();
      _controllerTotal.text = (_subTotal).toString();
      _controllerMoney.text = (_subTotal).toString();
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
              count++;
              await SharedPref.saveData(count);
              print(count);
            },
          ),
        ],
        title: Text('PAYMENT'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                      labelText:
                          _typetax == 1 ? "tax exclusive" : "tax inclusive",
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
                            hintText: "Input Discount",
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_typetax != 0) {
                            _controllerTotal.text =
                                (double.parse(_controllerSubtotal.text) +
                                        double.parse(_controllerTax.text) -
                                        double.parse(_controllerDiscount.text))
                                    .toString();
                            _controllerMoney.text =
                                (double.parse(_controllerSubtotal.text) +
                                        double.parse(_controllerTax.text) -
                                        double.parse(_controllerDiscount.text))
                                    .toString();
                          } else {
                            _controllerTotal.text =
                                (double.parse(_controllerSubtotal.text) -
                                        double.parse(_controllerDiscount.text))
                                    .toString();
                            _controllerMoney.text =
                                (double.parse(_controllerSubtotal.text) -
                                        double.parse(_controllerDiscount.text))
                                    .toString();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              'USE DISCOUNT',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
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
                    keyboardType: TextInputType.number,
                    controller: _controllerMoney,
                    decoration: InputDecoration(
                      // labelText: "Money Customer",
                      hintText: "Money",
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
                    itemCount: _payList.length,
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
                            _payList[index].name.toString(),
                            style: TextStyle(
                                color: Colors.amber[900],
                                fontWeight: FontWeight.w900),
                          ),
                          onPressed: () {
                            _controllertype.text =
                                _payList[index].name.toString();
                          },
                        ),
                      );
                    })),
            TextButton(
              onPressed: () async {
                if (tap != true) {
                  tap = true;
                  _controllerChange.text =
                      (double.parse(_controllerMoney.text) -
                              double.parse(_controllerTotal.text))
                          .toString();

                  _transactions.noinvoice = _controllerInvoice.text;
                  _transactions.name = _controllerName.text;
                  _transactions.subtotal =
                      double.parse(_controllerSubtotal.text);
                  _transactions.discount =
                      double.parse(_controllerDiscount.text);
                  _transactions.nettotal = double.parse(_controllerTotal.text);
                  _transactions.date =
                      DateTime.parse(dateNow).millisecondsSinceEpoch;
                  _transactions.type = _controllertype.text;
                  _transactions.money = double.parse(_controllerMoney.text);
                  _transactions.change = double.parse(_controllerChange.text);
                  _transactions.tax = double.parse(_controllerTax.text);
                  // add inv detail
                  for (var i = 0; i < _cartList.length; i++) {
                    _data.name = _cartList[i].name;
                    _data.noinvoice = _cartList[i].noinvoice;
                    _data.price = _cartList[i].price;
                    _data.qty = _cartList[i].qty;
                    _data.total = _cartList[i].total;
                    _data.date = DateTime.now().millisecondsSinceEpoch;
                    await _detailService.saveCart(_data);
                  }
                  // // result
                  await _transactionsService.save(_transactions);
                  count++;
                  await SharedPref.saveData(count);
                  await _cartService.deleteAll();

                  print('success save transaction, count++ and delete carts');

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Success(
                        invoice: _controllerInvoice.text,
                        name: _controllerName.text,
                        subtotal: _controllerSubtotal.text,
                        discount: _controllerDiscount.text,
                        tax: _controllerTax.text,
                        total: _controllerTotal.text,
                        date: dateNow,
                        type: _controllertype.text,
                        money: _controllerMoney.text,
                        change: _controllerChange.text,
                      ),
                    ),
                  );
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
    );
  }
}
