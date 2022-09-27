import '../models/product.dart';
import '../repo/repository.dart';

class ProductService {
  Repository? _repository;

  ProductService() {
    _repository = Repository();
  }

  saveProduct(Products products) async {
    return await _repository?.inserData('products', products.productsMap());
  }

  readProduct() async {
    return await _repository?.sortData('products');
  }

  readDataCustom() async {
    return await _repository?.readDataJoin('products');
  }

  readProductById(productId) async {
    return await _repository?.readDataById('products', productId);
  }

  readProductByCategory(category) async {
    return await _repository?.readDataBycategory('products', category);
  }

  updateProduct(Products products) async {
    return await _repository?.updateData('products', products.productsMap());
  }

  deleteProduct(productId) async {
    return await _repository?.deleteData('products', productId);
  }
}
