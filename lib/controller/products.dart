import 'package:get/get.dart';
import 'package:untitled2/models/product.dart';
import 'package:untitled2/services/product_service.dart';

class ProductsController extends GetxController {
  RxList<Products> data = <Products>[].obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    try {
      final product = await ProductService().readDataCustom();
      data.value = product.map<Products>(Products.fromJson).toList();
    } catch (e) {
      return e;
    }
  }

  filterProduct(cat) async {
    await getData();
    data.value = data.where((i) => i.categoriesname == cat).toList();
  }

  saveData(String name, price, int category) async {
    final _product = Products(
      id: null,
      name: name,
      category: category,
      categoriesname: null,
      price: double.parse(price),
    );
    return await ProductService().saveProduct(_product);
  }

  deleteData(productId) async {
    // final _productService = ProductService();
    return await ProductService().deleteProduct(productId);
  }

  updateData(int id, String name, int category, price) async {
    final _product = Products(
      id: id,
      name: name,
      category: category,
      categoriesname: null,
      price: double.parse(price),
    );
    return await ProductService().updateProduct(_product);
  }
}
