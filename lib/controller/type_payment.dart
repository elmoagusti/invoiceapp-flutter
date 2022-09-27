import 'package:get/get.dart';
import 'package:untitled2/models/type_payment.dart';
import 'package:untitled2/services/typepayment_service.dart';

class TypePaymentController extends GetxController {
  RxList<TypePayments> data = <TypePayments>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    final typePayment = await TypePaymentService().readPay();
    data.value = typePayment.map<TypePayments>(TypePayments.fromJson).toList();
  }

  saveData(String a) async {
    final _type = TypePayments(
      id: null,
      name: a,
    );
    await TypePaymentService().savePay(_type);
    // print(data);
  }
}
