import 'package:flutter/material.dart';
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
}
