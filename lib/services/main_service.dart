import 'package:untitled2/models/main.dart';
import 'package:untitled2/repo/repository.dart';

class MainService {
  Repository? _repository;

  MainService() {
    _repository = Repository();
  }

  saveMain(Mains main) async {
    return await _repository?.inserData('mains', main.mainsMap());
  }

  readMain() async {
    return await _repository?.readData('mains');
  }

  readById(id) async {
    return await _repository?.readDataById('mains', id);
  }

  updateMain(Mains main) async {
    return await _repository?.updateData('mains', main.mainsMap());
  }

  deleteMain(mainId) async {
    return await _repository?.deleteData('mains', mainId);
  }
}
