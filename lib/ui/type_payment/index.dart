import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/type_payment.dart';

class PaymentTypeScreen extends StatelessWidget {
  final typePayment = Get.put(TypePaymentController());
  final _paymentNameController = TextEditingController();

  clearform() async {
    _paymentNameController.clear();
  }

  _showSnackbar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
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
      body: GetX<TypePaymentController>(
        init: TypePaymentController(),
        initState: (_) {},
        builder: (_) {
          return ListView.builder(
            itemCount: typePayment.data.length,
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
                          typePayment.data[index].name,
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
                  _showSnackbar(context, Text("please fill name"));
                } else {
                  // _paymenttype.name = _paymentNameController.text;
                  typePayment.saveData(_paymentNameController.text);
                  // await _paymentservice.savePay(_paymenttype);
                  Navigator.pop(context);
                  // getAllpay();
                  typePayment.getData();
                  _showSnackbar(context, Text("Saved"));
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
      },
    );
  }
}
