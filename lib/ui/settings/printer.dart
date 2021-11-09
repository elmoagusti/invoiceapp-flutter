import 'dart:async';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:image/image.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
// import 'package:flutter/services.dart';

import '../home.dart';

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

  // Future<void> printTicket() async {
  //   String? isConnected = await BluetoothThermalPrinter.connectionStatus;
  //   if (isConnected == "true") {
  //     List<int> bytes = await getTicket();
  //     final result = await BluetoothThermalPrinter.writeBytes(bytes);
  //     print("Print $result");
  //   } else {
  //     //Hadnle Not Connected Senario
  //   }
  // }

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

    // Print Barcode using native function
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // bytes += generator.barcode(Barcode.upcA(barData));
    bytes += generator.drawer();
    bytes += generator.cut();

    return bytes;
  }

  //testing
  // Future<List<int>> getGraphicsTicket() async {
  //   List<int> bytes = [];

  //   CapabilityProfile profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm58, profile);
  //   final ByteData data = await rootBundle.load('images/inneed.png');
  //   final Uint8List byte = data.buffer.asUint8List();
  //   final Image image = decodeImage(byte)!;

  //   bytes += generator.image(image);
  //   bytes += generator.text("Store Name",
  //       styles: PosStyles(
  //         align: PosAlign.center,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ),
  //       linesAfter: 2);
  //   bytes += generator.text(
  //     "27-08-2021 11:25:26",
  //     styles: PosStyles(
  //       align: PosAlign.right,
  //       bold: true,
  //     ),
  //   );
  //   bytes += generator.text(
  //     "Invoice: INV001002003",
  //     styles: PosStyles(
  //       align: PosAlign.left,
  //       bold: true,
  //       height: PosTextSize.size1,
  //       width: PosTextSize.size1,
  //     ),
  //   );
  //   bytes += generator.text(
  //     "Outlet: Cabang Bogor",
  //     styles: PosStyles(
  //       align: PosAlign.left,
  //       bold: true,
  //       height: PosTextSize.size1,
  //       width: PosTextSize.size1,
  //     ),
  //   );
  //   bytes += generator.hr(ch: '=');
  //   for (var i = 0; i < 2; i++) {
  //     bytes += generator.text(
  //       "ayam geprek bensu",
  //       styles: PosStyles(
  //         align: PosAlign.left,
  //         bold: true,
  //       ),
  //     );
  //     bytes += generator.row([
  //       PosColumn(
  //           text: '9 x 100000',
  //           width: 6,
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //             width: PosTextSize.size1,
  //           )),
  //       PosColumn(
  //           text: "Rp 900,000.00",
  //           width: 6,
  //           styles: PosStyles(
  //             align: PosAlign.right,
  //             height: PosTextSize.size1,
  //             width: PosTextSize.size1,
  //           )),
  //     ]);
  //   }
  //   bytes += generator.hr(ch: '=', linesAfter: 1);
  //   bytes += generator.text(
  //     "Subtotal: Rp 180,000.00",
  //     styles: PosStyles(
  //       align: PosAlign.left,
  //       bold: true,
  //       height: PosTextSize.size1,
  //       width: PosTextSize.size1,
  //     ),
  //   );
  //   bytes += generator.text(
  //     "Tax: Rp 0.0",
  //     styles: PosStyles(
  //       align: PosAlign.left,
  //       bold: true,
  //       height: PosTextSize.size1,
  //       width: PosTextSize.size1,
  //     ),
  //   );
  //   bytes += generator.row([
  //     PosColumn(
  //         text: 'TOTAL',
  //         width: 6,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size2,
  //           width: PosTextSize.size1,
  //         )),
  //     PosColumn(
  //       text: "Rp 1,800,000.00",
  //       width: 6,
  //       styles: PosStyles(
  //         align: PosAlign.right,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size1,
  //       ),
  //     ),
  //   ]);
  //   bytes += generator.text(
  //     "Money: Rp 1,800,000.00",
  //     styles: PosStyles(
  //       align: PosAlign.left,
  //       bold: true,
  //       height: PosTextSize.size1,
  //       width: PosTextSize.size1,
  //     ),
  //   );
  //   bytes += generator.text("Change: Rp 0.0",
  //       styles: PosStyles(
  //         align: PosAlign.left,
  //         bold: true,
  //         height: PosTextSize.size1,
  //         width: PosTextSize.size1,
  //       ),
  //       linesAfter: 1);
  //   bytes += generator.text(
  //     "Terimakasih",
  //     styles: PosStyles(
  //       align: PosAlign.center,
  //       bold: true,
  //       height: PosTextSize.size1,
  //       width: PosTextSize.size1,
  //     ),
  //   );
  //   bytes += generator.cut();

  //   return bytes;
  // }

//   Future<List<int>> getTicket() async {
//     List<int> bytes = [];
//     CapabilityProfile profile = await CapabilityProfile.load();
//     final generator = Generator(PaperSize.mm58, profile);
//     final File path = File(
//         "/data/user/0/com.example.untitled2/cache/scaled_image_picker383474335626035781.jpg");
//     final Uint8List a = path.readAsBytesSync();
//     final Image? images = decodeImage(a);
//     // final ByteData data = await rootBundle.load('images/inneed1.jpeg');
//     // final Uint8List byte = data.buffer.asUint8List();
//     // final Image image = decodeImage(byte)!;

//     //awal
//     // final ByteData data = await rootBundle.load('images/inneed.png');
//     // final Uint8List byte = data.buffer.asUint8List();
//     // final Image? image = decodeImage(byte);

// // Using `ESC *`

//     bytes += generator.image(images!);
//     bytes += generator.text("Store Name",
//         styles: PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ),
//         linesAfter: 1);
//     bytes += generator.text(
//       "27-08-2021 11:25:26",
//       styles: PosStyles(
//         align: PosAlign.right,
//         bold: true,
//       ),
//     );
//     bytes += generator.hr(ch: '=');
//     for (var i = 0; i < 2; i++) {
//       bytes += generator.text(
//         "ayam geprek bensu",
//         styles: PosStyles(
//           align: PosAlign.left,
//           bold: true,
//         ),
//       );
//       bytes += generator.row([
//         PosColumn(
//             text: '9 x 100000',
//             width: 6,
//             styles: PosStyles(
//               align: PosAlign.left,
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//             )),
//         PosColumn(
//             text: "Rp 999,000.00",
//             width: 6,
//             styles: PosStyles(
//               align: PosAlign.right,
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//             )),
//       ]);
//     }
//     bytes += generator.hr(ch: '=', linesAfter: 1);
//     // bytes += generator.image(images!);

//     // bytes += generator.text(
//     //     "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
//     //     styles: PosStyles(align: PosAlign.center));
//     // bytes += generator.text('Tel: +919591708470',
//     //     styles: PosStyles(align: PosAlign.center));

//     // bytes += generator.hr();

//     // bytes += generator.row([
//     //   PosColumn(text: "1", width: 1),
//     //   PosColumn(
//     //       text: "Tea",
//     //       width: 5,
//     //       styles: PosStyles(
//     //         align: PosAlign.left,
//     //       )),
//     //   PosColumn(
//     //       text: "10",
//     //       width: 2,
//     //       styles: PosStyles(
//     //         align: PosAlign.center,
//     //       )),
//     //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: "10", width: 2, styles: PosStyles(align: PosAlign.right)),
//     // ]);

//     // bytes += generator.row([
//     //   PosColumn(text: "2", width: 1),
//     //   PosColumn(
//     //       text: "Sada Dosa",
//     //       width: 5,
//     //       styles: PosStyles(
//     //         align: PosAlign.left,
//     //       )),
//     //   PosColumn(
//     //       text: "30",
//     //       width: 2,
//     //       styles: PosStyles(
//     //         align: PosAlign.center,
//     //       )),
//     //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: "30", width: 2, styles: PosStyles(align: PosAlign.right)),
//     // ]);

//     // bytes += generator.row([
//     //   PosColumn(text: "3", width: 1),
//     //   PosColumn(
//     //       text: "Masala Dosa",
//     //       width: 5,
//     //       styles: PosStyles(
//     //         align: PosAlign.left,
//     //       )),
//     //   PosColumn(
//     //       text: "50",
//     //       width: 2,
//     //       styles: PosStyles(
//     //         align: PosAlign.center,
//     //       )),
//     //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: "50", width: 2, styles: PosStyles(align: PosAlign.right)),
//     // ]);

//     // bytes += generator.row([
//     //   PosColumn(text: "4", width: 1),
//     //   PosColumn(
//     //       text: "Rova Dosa",
//     //       width: 5,
//     //       styles: PosStyles(
//     //         align: PosAlign.left,
//     //       )),
//     //   PosColumn(
//     //       text: "70",
//     //       width: 2,
//     //       styles: PosStyles(
//     //         align: PosAlign.center,
//     //       )),
//     //   PosColumn(text: "1", width: 2, styles: PosStyles(align: PosAlign.center)),
//     //   PosColumn(text: "70", width: 2, styles: PosStyles(align: PosAlign.right)),
//     // ]);

//     // bytes += generator.hr();

  // bytes += generator.row([
  //   PosColumn(
  //       text: 'TOTAL',
  //       width: 6,
  //       styles: PosStyles(
  //         align: PosAlign.left,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size1,
  //       )),
  //   PosColumn(
  //       text: "Rp 1.999,000.00",
  //       width: 6,
  //       styles: PosStyles(
  //         align: PosAlign.right,
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size1,
  //       )),
  // ]);

//     // bytes += generator.hr(ch: '=', linesAfter: 1);

//     // // ticket.feed(2);
//     // bytes += generator.text('Thank you!',
//     //     styles: PosStyles(align: PosAlign.center, bold: true));

//     // bytes += generator.text(
//     //   "ayam geprek bensu",
//     //   styles: PosStyles(align: PosAlign.left),
//     // );
//     // bytes += generator.text(
//     //   "2 x 25000",
//     //   styles: PosStyles(align: PosAlign.left),
//     // );
//     // bytes += generator.text("Rp 50,000.00",
//     //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

//     // bytes += generator.
//     // bytes += generator.text(
//     //     'Note: Goods once sold will not be taken back or exchanged.',
//     //     styles: PosStyles(align: PosAlign.center, bold: false));
//     // bytes += generator.cut();
//     return bytes;
//   }

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
          bottomNavigationBar: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amber[600]),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            child: Text(
              'GET STARTED',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen())),
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
                  'Start',
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
