import 'dart:async';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';

class Printer extends StatefulWidget {
  @override
  _PrinterState createState() => _PrinterState();
}

class _PrinterState extends State<Printer> {
  @override
  void initState() {
    super.initState();
  }

  bool connected = false;
  List availableBluetoothDevices = [];

  Future<void> getBluetooth() async {
    final List? bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths!;
    });
  }

  Future<void> setConnect(String mac) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    print("state conneected $result");
    if (result == "true") {
      setState(() {
        connected = true;
        _success();
      });
    } else {
      _failed();
    }
  }

  Future<void> printGraphics() async {
    String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      List<int> bytes = await getGraphicsTicket();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {
      _failed();
    }
  }

  Future<List<int>> getGraphicsTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    // Print QR Code using native function
    bytes += generator.text(
      "CONNECTED!",
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    bytes += generator.text(
        "Terimakasih sudah membeli produk kami, jika kamu membelinya secara legal maka kamu mendapat dukungan penuh support 1x24 jam. kamu dapat menghubungi whatstapp: +62859106961034",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.qrcode('https://wa.me/62859106961034');
    bytes += generator.drawer();
    bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('The System Back Button is Deactivated')));
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber[600],
            title: const Text('Connecting Bluetooth thermal'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Search Paired Bluetooth"),
                  TextButton(
                    onPressed: () {
                      this.getBluetooth();
                    },
                    child: Text(
                      "Search",
                      style: TextStyle(
                          color: Colors.amber[600],
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: availableBluetoothDevices.length > 0
                          ? availableBluetoothDevices.length
                          : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            String select = availableBluetoothDevices[index];
                            List list = select.split("#");
                            // String name = list[0];
                            String mac = list[1];
                            this.setConnect(mac);
                          },
                          title: Text(
                            '${availableBluetoothDevices[index]}',
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text("Click to connect",
                              textAlign: TextAlign.center),
                        );
                      },
                    ),
                  ),
                  TextButton(
                    // onPressed: connected ? this.printGraphics : null,
                    onPressed: this.printGraphics,
                    child: Text(
                      "Test Printer",
                      style: TextStyle(color: Colors.amber[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _success() {
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
                  'Tutup',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.amber[600],
                    size: 200,
                  ),
                  Text(
                    "Printer Connected",
                    style: TextStyle(
                        color: Colors.amber[600],
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          );
        });
  }

  _failed() {
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
                    "Printer Not Connected, please Restart Apps",
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
        });
  }
}
