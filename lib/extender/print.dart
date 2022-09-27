import 'dart:io';
import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/models/product.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/models/type_payment.dart';
import '../models/cart.dart';
import '../models/main.dart';

class Print {
  var f = NumberFormat("Rp #,##0", "en_US");

  // Future<void> printTicket(store, detail, name, dateNow, noinvoice, subtotal,
  //     tax, discount, total, type, money, change, copy) async {
  //   String? isConnected = await BluetoothThermalPrinter.connectionStatus;

  //   if (isConnected == "true") {
  //     List<int> bytes = await getTicket(store, detail, name, dateNow, noinvoice,
  //         subtotal, tax, discount, total, type, money, change, copy);
  //     final result = await BluetoothThermalPrinter.writeBytes(bytes);
  //     print("Print $result");
  //   } else {
  //     // _failed();
  //   }
  // }

  Future<List<int>> getTicket(
      List<Stores> store,
      List<Carts> detail,
      List<TransactionDetail> x,
      name,
      dateNow,
      noinvoice,
      subtotal,
      tax,
      discount,
      total,
      type,
      money,
      change,
      copy) async {
    List<Stores> _mainList = store;
    List<Carts> _detailList = detail;
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    //images logo
    if (_mainList[0].logo != "") {
      final File path = File(_mainList[0].logo.toString());
      final Uint8List a = path.readAsBytesSync();
      final Image? images = decodeImage(a);

      bytes += generator.image(images!);
    }

    //named store
    if (_mainList[0].store != "") {
      bytes += generator.text("${_mainList[0].store}",
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ),
          linesAfter: 1);
    }
    //datenow
    bytes += generator.text(
      DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(dateNow)),
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );
    bytes += generator.text(
      "Invoice: " + noinvoice,
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    if (_mainList[0].outlet != "") {
      bytes += generator.text(
        "Outlet: ${_mainList[0].outlet}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
    }
    if (_mainList[0].address != "") {
      bytes += generator.text(
        "Address: ${_mainList[0].address}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
    }
    if (_mainList[0].phone != "") {
      bytes += generator.text(
        "Phone: ${_mainList[0].phone}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
    }
    bytes += generator.text(
      "NAME: " + name,
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    if (_mainList[0].header != "") {
      bytes += generator.text("${_mainList[0].header}",
          styles: PosStyles(align: PosAlign.center));
    }

    bytes += generator.hr(ch: '=');
    if (detail.length != 0) {
      for (var i = 0; i < _detailList.length; i++) {
        bytes += generator.text(
          "@ ${_detailList[i].name}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          ),
        );
        bytes += generator.row([
          PosColumn(
              text: "${_detailList[i].qty} x ${f.format(_detailList[i].price)}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: "${f.format(_detailList[i].total)}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
        ]);
      }
    }
    if (x.length != 0) {
      for (var i = 0; i < x.length; i++) {
        bytes += generator.text(
          "@ ${x[i].name}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
          ),
        );
        bytes += generator.row([
          PosColumn(
              text: "${x[i].qty} x ${f.format(x[i].price)}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.left,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: "${f.format(x[i].total)}",
              width: 6,
              styles: PosStyles(
                align: PosAlign.right,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
        ]);
      }
    }
    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.text(
      "SubTotal: ${f.format(double.parse(subtotal))}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    if (_mainList[0].tax != 0) {
      bytes += generator.text(
        "Tax: ${f.format(double.parse(tax))} (${_mainList[0].tax}%)",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
    }
    bytes += generator.text(
      "Discount: ${f.format(double.parse(discount))}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: f.format(double.parse(total)),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          )),
    ]);
    bytes += generator.text(
      "PAID ${type.toString()} : ${f.format(double.parse(money))}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.text("Change : ${f.format(double.parse(change))}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
        linesAfter: 1);
    if (_mainList[0].footer != "") {
      bytes += generator.text("${_mainList[0].footer}",
          styles: PosStyles(align: PosAlign.center));
    }

    if (copy == true) {
      bytes += generator.text(
        "*****COPY STRUK*****",
        styles: PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
    }
    bytes += generator.drawer();
    bytes += generator.cut();

    return bytes;
  }

  Future<List<int>> getSettlement(
      datenow,
      subTotal,
      discount,
      tax,
      netTotal,
      List<TypePayments> paylist,
      List<Transactions> transaction,
      List<TransactionDetail> detail,
      List<Products> product) async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text("SALES SUMMARY",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);
    bytes += generator.text(
      datenow,
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.text(
      "*SALES",
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );
    bytes += generator.text(
      "SUBTOTAL ${f.format(subTotal)}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.text(
      "DISCOUNT: ${f.format(discount)}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.text(
      "TAX: ${f.format(tax)}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );
    bytes += generator.text(
      "OMZET: ${f.format(netTotal)}",
      styles: PosStyles(
        align: PosAlign.left,
        bold: true,
        height: PosTextSize.size1,
        width: PosTextSize.size1,
      ),
    );

    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.text(
      "*SETTLEMENT",
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );

    for (var i = 0; i < paylist.length; i++) {
      double n = 0;
      var elmo = transaction.where((data) => data.type == paylist[i].id);
      elmo.forEach((element) {
        n += double.parse(element.nettotal.toString());
        print(element.nettotal);
      });

      print(paylist[i].name);
      bytes += generator.text("${paylist[i].name} : ${f.format(n)}",
          styles: PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
          linesAfter: 1);
      n = 0;
    }
    bytes += generator.hr(ch: '=', linesAfter: 1);
    bytes += generator.text(
      "*TRANSACTIONS",
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );

    for (var i = 0; i < transaction.length; i++) {
      bytes += generator.text(
        "${transaction[i].noinvoice} @ ${transaction[i].name}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
        ),
      );
      bytes += generator.row([
        PosColumn(
            text: "${f.format(transaction[i].nettotal)}",
            width: 6,
            styles: PosStyles(
              align: PosAlign.left,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: "${transaction[i].typeName}",
            width: 6,
            styles: PosStyles(
              align: PosAlign.right,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
      ]);
    }
    bytes += generator.text(
      "Total: ${transaction.length} Transactions",
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );
    bytes += generator.hr(ch: '=');
    bytes += generator.text(
      "*Details Qty product",
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );
    for (var i = 0; i < product.length; i++) {
      int n = 0;
      var elmo = detail.where((data) => data.name == product[i].name);
      elmo.forEach((element) {
        n += int.parse(element.qty.toString());
        print(element.qty);
        print(n);
      });

      print(product[i].name);
      bytes += generator.text(
        "${product[i].name} : ${n.toString()}",
        styles: PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      );
      n = 0;
    }
    int quantity = 0;

    for (var i = 0; i < detail.length; i++) {
      quantity += int.parse(detail[i].qty.toString());
    }
    bytes += generator.text(
      "Total: ${quantity.toString()} Product",
      styles: PosStyles(
        align: PosAlign.right,
        bold: true,
      ),
    );
    bytes += generator.cut();
    return bytes;
  }
}
