import '../models/product.dart';
import '../repo/repository.dart';

class ProductService {
  Repository? _repository;

  ProductService() {
    _repository = Repository();
  }

  saveProduct(Product product) async {
    return await _repository?.inserData('products', product.productMap());
  }

  readProduct() async {
    return await _repository?.sortData('products');
  }

  readProductById(productId) async {
    return await _repository?.readDataById('products', productId);
  }

  readProductByCategory(category) async {
    return await _repository?.readDataBycategory('products', category);
  }

  updateProduct(Product product) async {
    return await _repository?.updateData('products', product.productMap());
  }

  deleteProduct(productId) async {
    return await _repository?.deleteData('products', productId);
  }
}
