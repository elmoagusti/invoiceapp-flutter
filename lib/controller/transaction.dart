import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/cart.dart';
import 'package:untitled2/models/cart.dart';
import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/models/transaction_details.dart';
import 'package:untitled2/repo/sharedprefs.dart';
import 'package:untitled2/services/transaction_details_service.dart';
import 'package:untitled2/services/transaction_service.dart';

class TransactionsController extends GetxController {
  RxList<Transactions> data = <Transactions>[].obs;
  RxList<TransactionDetail> dataDetail = <TransactionDetail>[].obs;

  RxInt no = 1.obs;

  var noinvoice = "".obs;

  final dateNow = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final dn = DateFormat('yyMMdd').format(DateTime.now());
  final f = NumberFormat("Rp #,##0.00", "en_US");

  //reports
  final a = DateFormat('yyyy-MM-dd 00:01:01.000').format(DateTime.now());
  final b = DateFormat('yyyy-MM-dd 23:59:59.999').format(DateTime.now());
  final subtotal = 0.0.obs;
  final discount = 0.0.obs;
  final tax = 0.0.obs;
  final nettotal = 0.0.obs;
  final settlement = 0.0.obs;

  @override
  void onInit() async {
    noGet();
    await gettrx(DateTime.parse(a).millisecondsSinceEpoch,
        DateTime.parse(b).millisecondsSinceEpoch);
    filter(1);
    super.onInit();
  }

  void noUp() async {
    await SharedPref.saveData(no.value + 1);
    noGet();
  }

  noGet() async {
    final a = await SharedPref.getData();
    if (a == null) {
      noinvoice.value = "INV001" + dn + no.toString();
    } else {
      no.value = a;
      noinvoice.value = "INV001" + dn + no.toString();
    }
  }

  savetrx(noinvoice, name, tax, subtotal, discount, nettotal, date, type,
      typename, money, change, List<Carts> cart) async {
    final _trx = Transactions(
      id: null,
      noinvoice: noinvoice,
      name: name,
      tax: double.parse(tax),
      subtotal: double.parse(subtotal),
      discount: double.parse(discount),
      nettotal: double.parse(nettotal),
      date: date,
      type: type,
      typeName: typename,
      money: double.parse(money),
      change: double.parse(change),
    );
    final id = await TransactionService().save(_trx);
    // print("id transaksi " + id.toString());
    try {
      for (var i = 0; i < cart.length; i++) {
        final _detail = TransactionDetail(
          id: null,
          trxid: id,
          name: cart[i].name,
          qty: cart[i].qty,
          price: cart[i].price,
          total: cart[i].total,
          date: date,
        );

        final td = await DetailService().saveCart(_detail);

        // print("id detail " + td.toString());
      }
      gettrx(DateTime.parse(a).millisecondsSinceEpoch,
          DateTime.parse(b).millisecondsSinceEpoch);
    } catch (e) {
      return e;
    }
  }

  gettrx(start, end) async {
    //trx
    var _inv = await TransactionService().sortbyDate(start, end);
    data.value = _inv.map<Transactions>(Transactions.fromJson).toList();
    // detail
    var detail = await DetailService().sortbyDate(start, end);
    dataDetail.value =
        detail.map<TransactionDetail>(TransactionDetail.fromJson).toList();

    subtotal.value = 0;
    discount.value = 0;
    tax.value = 0;
    nettotal.value = 0;
    for (var i = 0; i < data.length; i++) {
      double a = data[i].subtotal;
      double b = data[i].discount;
      double c = data[i].tax;
      double d = data[i].nettotal;
      subtotal.value += a;
      discount.value += b;
      tax.value += c;
      nettotal.value += d;
    }
  }

  filter(no) {
    double n = 0;
    var elmo = data.where((data) => data.type == no);
    elmo.forEach((element) {
      n += double.parse(element.nettotal.toString());
    });
    // print(n);
    settlement.value = n;
  }

  deletetrx(id) async {
    try {
      await TransactionService().delete(id);
      await DetailService().delete(id);

      gettrx(DateTime.parse(a).millisecondsSinceEpoch,
          DateTime.parse(b).millisecondsSinceEpoch);
    } catch (e) {
      print(e);
    }
  }
}
