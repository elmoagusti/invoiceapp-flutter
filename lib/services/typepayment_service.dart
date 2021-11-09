import '../models/type_payment.dart';
import '../repo/repository.dart';

class TypePaymentService {
  Repository? _repository;

  TypePaymentService() {
    _repository = Repository();
  }

  savePay(TypePayment typepayment) async {
    return await _repository?.inserData(
        'payments', typepayment.typepaymentMap());
  }

  readPay() async {
    return await _repository?.readData('payments');
  }
}
