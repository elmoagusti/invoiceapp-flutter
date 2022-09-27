import 'package:get/get.dart';
import 'package:untitled2/models/cart.dart';

class CartsController extends GetxController {
  RxList<Carts> data = <Carts>[].obs;

  RxDouble subtot = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  saveData(id, name, price, qty, total) {
    int _qty = 0;
    if (data.isNotEmpty) {
      var elmo = data.where((data) => data.name == name);
      if (elmo.isEmpty) {
        _qty = qty;
      } else {
        for (var i = 0; i < data.length; i++) {
          if (data[i].name == name) {
            var a = data[i].qty + qty;
            _qty = a.toInt();
            data.removeAt(i);
          }
        }
      }
    } else if (data.isEmpty) {
      _qty = qty;
    }

    //
    final _carts = Carts(
      id: data.length + 1,
      name: name,
      price: price,
      qty: _qty,
      total: price * _qty,
    );

    data.add(_carts);
    subtot.value = 0.0;
    data.forEach((element) {
      subtot.value += element.total;
    });
  }

  deleList(name) {
    data.removeWhere((element) => element.name == name);
    subtot.value = 0.0;
    for (var i = 0; i < data.length; i++) {
      final a = data[i].total;
      subtot.value += a;
    }
  }

  deleteData() {
    data.clear();
    subtot.value = 0.0;
  }
}
