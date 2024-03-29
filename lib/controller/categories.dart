import 'package:get/get.dart';
import 'package:untitled2/models/category.dart';
import 'package:untitled2/services/category_service.dart';

class CategoriesController extends GetxController {
  RxList<Categories> data = <Categories>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    final category = await CategoryService().readCategory();
    data.value = category.map<Categories>(Categories.fromJson).toList();
  }

  saveData(String a) async {
    final _category = Categories(
      id: null,
      name: a,
    );
    await CategoryService().saveCategory(_category);
  }
}
