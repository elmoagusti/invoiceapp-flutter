import '../models/transaction_details.dart';
import '../repo/repository.dart';

class DetailService {
  Repository? _repository;

  DetailService() {
    _repository = Repository();
  }

  saveCart(TransactionDetails product) async {
    return await _repository?.inserData(
        'transactions_details', product.transactiondetailMap());
  }

  readCart() async {
    return await _repository?.readData('transactions_details');
  }

  readCartById(id) async {
    return await _repository?.readDataById('transactions_details', id);
  }

  sortbyDate(start, end) async {
    return await _repository?.readDataWithDate(
        'transactions_details', start, end);
  }

  readDatabyInv(inv) async {
    return await _repository?.readDataByinv('transactions_details', inv);
  }

  delete(inv) async {
    return await _repository?.deleteDatawithinv('transactions_details', inv);
  }
}
