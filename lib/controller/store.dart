import 'package:get/get.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/services/main_service.dart';

class StoresController extends GetxController {
  RxList<Stores> data = <Stores>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    final _main = await MainService().readMain();
    data.value = _main.map<Stores>(Stores.fromJson).toList();
  }

  saveData(
      outlet, store, address, phone, typetax, tax, header, footer, logo) async {
    final _main = Stores(
      id: null,
      outlet: outlet,
      store: store,
      address: address,
      phone: phone,
      typetax: typetax,
      tax: tax,
      header: header,
      footer: footer,
      logo: logo,
    );
    await MainService().saveMain(_main);
  }

  editData(id, outlet, store, address, phone, typetax, tax, header, footer,
      logo) async {
    final _main = Stores(
      id: id,
      outlet: outlet,
      store: store,
      address: address,
      phone: phone,
      typetax: typetax,
      tax: tax,
      header: header,
      footer: footer,
      logo: logo,
    );
    await MainService().updateMain(_main);
  }
}
