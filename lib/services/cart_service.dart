import '../models/cart.dart';
import '../repo/repository.dart';

class CartService {
  Repository? _repository;

  CartService() {
    _repository = Repository();
  }

  saveCart(Cart product) async {
    return await _repository?.inserData('carts', product.cartMap());
  }

  readCart() async {
    return await _repository?.readData('carts');
  }

  readCartById(cartId) async {
    return await _repository?.readDataById('carts', cartId);
  }

  updateCart(Cart cart) async {
    return await _repository?.updateData('carts', cart.cartMap());
  }

  deleteProduct(cartId) async {
    return await _repository?.deleteData('carts', cartId);
  }

  deleteAll() async {
    return await _repository?.deleteAll('carts');
  }
}
