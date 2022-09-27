import '../models/transaction_details.dart';
import '../repo/repository.dart';

class DetailService {
  Repository? _repository;

  DetailService() {
    _repository = Repository();
  }

  saveCart(TransactionDetail product) async {
    return await _repository?.inserData(
        'transactions_details', product.transactionDetailMap());
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

  readDatabyInv(trxid) async {
    return await _repository?.readDataByinv('transactions_details', trxid);
  }

  delete(trxid) async {
    return await _repository?.deleteDatawithinv('transactions_details', trxid);
  }
}
