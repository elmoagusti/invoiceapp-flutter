import '../models/category.dart';
import '../repo/repository.dart';

class CategoryService {
  Repository? _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(Category category) async {
    return await _repository?.inserData('categories', category.categoryMap());
  }

  readCategory() async {
    return await _repository?.readData('categories');
  }
}
