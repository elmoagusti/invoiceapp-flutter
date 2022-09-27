import 'package:untitled2/models/main.dart';
import 'package:untitled2/repo/repository.dart';

class MainService {
  Repository? _repository;

  MainService() {
    _repository = Repository();
  }

  saveMain(Stores stores) async {
    return await _repository?.inserData('mains', stores.storesMap());
  }

  readMain() async {
    return await _repository?.readData('mains');
  }

  readById(id) async {
    return await _repository?.readDataById('mains', id);
  }

  updateMain(Stores stores) async {
    return await _repository?.updateData('mains', stores.storesMap());
  }

  deleteMain(mainId) async {
    return await _repository?.deleteData('mains', mainId);
  }
}
