import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/repo/sharedprefs.dart';
import 'package:untitled2/ui/reports/sales_summary.dart';
import 'package:untitled2/ui/settings/mains.dart';
import 'package:untitled2/ui/settings/printer.dart';
import 'package:untitled2/ui/type_payment/index.dart';
import '../ui/category/index.dart';
import '../ui/home.dart';
import '../ui/product/index.dart';

class DrawerNavigate extends StatefulWidget {
  @override
  _DrawerNavigateState createState() => _DrawerNavigateState();
}

class _DrawerNavigateState extends State<DrawerNavigate> {
  // bool status = true;
  // var username = 'accesspoint';
  // var password = DateFormat('25' + 'yyMd' + '99').format(DateTime.now());
  // var _controllerName = TextEditingController();
  // var _controllerPass = TextEditingController();

  // getStatus() async {
  //   var data = await SharedPref.getactivations();
  //   setState(() {
  //     if (data == true) {
  //       status = true;
  //     } else if (data == false) {
  //       status = false;
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('devE AEGIS Technology'),
              accountEmail: Text('WhatsApp: +62 859 1069 610'),
              decoration: BoxDecoration(color: Colors.amber[600]),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.green,
              ),
              title: Align(
                child: Text('Home'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: Colors.amber,
              ),
              title: Align(
                child: Text('Sales Summary'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SalesSummary())),
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
              title: Align(
                child: Text('Product Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProductScreen())),
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle_outline,
                color: Colors.blue[400],
              ),
              title: Align(
                child: Text('Category Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CategoryScreen())),
            ),
            ListTile(
              leading: Icon(
                Icons.payment,
                color: Colors.cyan,
              ),
              title: Align(
                child: Text('Payment Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PaymentTypeScreen())),
            ),
            ListTile(
              leading: Icon(
                Icons.add_business,
                color: Colors.red,
              ),
              title: Align(
                child: Text('Store Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () {
                // if (status == true) {
                // _showFormDialog(context);
                // } else if (status == false) {
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => MainScreen()));
                // }
                // print(status);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Colors.deepPurple,
              ),
              title: Align(
                child: Text('Printer Settings'),
                alignment: Alignment(-1.3, 0),
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Printer())),
            ),
          ],
        ),
      ),
    );
  }

  // _showFormDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (params) {
  //         return SingleChildScrollView(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               AlertDialog(
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       'Cancel',
  //                       style: TextStyle(color: Colors.grey),
  //                     ),
  //                   ),
  //                   TextButton(
  //                     onPressed: () async {
  //                       print(_controllerName.text);
  //                       print(_controllerPass.text);
  //                       if (_controllerPass.text != password) {
  //                         print("Password salah" + password);
  //                       } else if (_controllerName.text != username) {
  //                         print("username salah" + username);
  //                       } else if (_controllerName.text == username ||
  //                           _controllerPass.text == password) {
  //                         print("udah bener");
  //                         status = false;
  //                         await SharedPref.activateData(status);
  //                         Navigator.of(context).pushReplacement(
  //                             MaterialPageRoute(
  //                                 builder: (context) => HomeScreen()));
  //                       }
  //                     },
  //                     child: Text(
  //                       'PROCESS',
  //                       style: TextStyle(color: Colors.red),
  //                     ),
  //                   ),
  //                 ],
  //                 title: Center(
  //                     child: Text(
  //                   "Activation",
  //                   style: TextStyle(color: Colors.red),
  //                 )),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     TextField(
  //                       controller: _controllerName,
  //                       decoration: InputDecoration(
  //                           hintText: "Input Username", labelText: "Name"),
  //                     ),
  //                     TextField(
  //                       controller: _controllerPass,
  //                       obscureText: true,
  //                       decoration: InputDecoration(
  //                           hintText: "Input Password", labelText: "Password"),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }
}
