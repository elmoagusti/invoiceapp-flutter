import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/repo/repository.dart';

class TransactionService {
  Repository? _repository;

  TransactionService() {
    _repository = Repository();
  }

  save(Transaction transaction) async {
    return await _repository?.inserData(
        'transactions', transaction.transactionMap());
  }

  read() async {
    return await _repository?.readData('transactions');
  }

  readById(id) async {
    return await _repository?.readDataById('transactions', id);
  }

  readDatabyInv(inv) async {
    return await _repository?.readDataByinv('transactions', inv);
  }

  sortbyDate(start, end) async {
    return await _repository?.readDataWithDate('transactions', start, end);
  }

  delete(inv) async {
    return await _repository?.deleteDatawithinv('transactions', inv);
  }
}
