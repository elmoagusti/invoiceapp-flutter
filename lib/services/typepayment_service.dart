import '../models/type_payment.dart';
import '../repo/repository.dart';

class TypePaymentService {
  Repository? _repository;

  TypePaymentService() {
    _repository = Repository();
  }

  savePay(TypePayments typepayments) async {
    return await _repository?.inserData(
        'payments', typepayments.typePaymentsMap());
  }

  readPay() async {
    return await _repository?.readData('payments');
  }
}
