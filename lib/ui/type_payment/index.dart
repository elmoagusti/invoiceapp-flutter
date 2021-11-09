import 'package:flutter/material.dart';
import 'package:untitled2/models/type_payment.dart';
import 'package:untitled2/services/typepayment_service.dart';

import '../home.dart';

class PaymentTypeScreen extends StatefulWidget {
  // const PaymentTypeScreen({Key? key}) : super(key: key);

  @override
  _PaymentTypeScreenState createState() => _PaymentTypeScreenState();
}

class _PaymentTypeScreenState extends State<PaymentTypeScreen> {
  var _paymentNameController = TextEditingController();

  var _paymenttype = TypePayment();
  var _paymentservice = TypePaymentService();

  List<TypePayment> _paymentlist = <TypePayment>[];
  var typepayment;

  @override
  void initState() {
    super.initState();
    getAllpay();
    clearform();
  }

  clearform() async {
    _paymentNameController.clear();
  }

  getAllpay() async {
    _paymentlist = <TypePayment>[].toList();
    var payments = await _paymentservice.readPay();
    payments.forEach((a) {
      setState(() {
        var payModel = TypePayment();
        payModel.name = a['name'];

        payModel.id = a['id'];
        _paymentlist.add(payModel);
      });
    });
  }

  _showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _globalKey,
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
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _showFormDialog(context);
            },
          ),
        ],
        title: Text('Payment Type'),
      ),
      body: ListView.builder(
        itemCount: _paymentlist.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
            child: Card(
              // elevation: 11,
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Container(
                        child: Text(
                      _paymentlist[index].name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (params) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  clearform();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_paymentNameController.text.isEmpty) {
                    _showSnackbar(Text("please fill name"));
                  } else {
                    _paymenttype.name = _paymentNameController.text;

                    await _paymentservice.savePay(_paymenttype);
                    Navigator.pop(context);
                    getAllpay();
                    _showSnackbar(Text("Saved"));
                    clearform();
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
            title: Text("Type Payment Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _paymentNameController,
                    decoration: InputDecoration(
                        hintText: "Input Name", labelText: "Name"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
