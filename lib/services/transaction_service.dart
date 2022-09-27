import 'package:untitled2/models/transaction.dart';
import 'package:untitled2/repo/repository.dart';

class TransactionService {
  Repository? _repository;

  TransactionService() {
    _repository = Repository();
  }

  save(Transactions transactions) async {
    return await _repository?.inserData(
        'transactions', transactions.transactionsMap());
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

  delete(id) async {
    return await _repository?.deleteData('transactions', id);
  }
}
