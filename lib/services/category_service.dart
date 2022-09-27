import '../models/category.dart';
import '../repo/repository.dart';

class CategoryService {
  Repository? _repository;

  CategoryService() {
    _repository = Repository();
  }

  saveCategory(Categories categories) async {
    return await _repository?.inserData(
        'categories', categories.categoriesMap());
  }

  readCategory() async {
    return await _repository?.readData('categories');
  }
}
