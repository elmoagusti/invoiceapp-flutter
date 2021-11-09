import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../services/category_service.dart';
// import 'package:untitled2/ui/home.dart';
import '../../services/product_service.dart';
import '../../ui/home.dart';

class ProductScreen extends StatefulWidget {
  // const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
//dropdown

  var _categoryService = CategoryService();

  var _productCategory;
  List<Category> _datacategory = <Category>[];

  var _productNameController = TextEditingController();
  // var _productCategoryController = TextEditingController();
  var _productPriceController = TextEditingController();

  var _product = Product();
  var _productService = ProductService();

  List<Product> _productList = <Product>[];

  var product;

  var _editproductNameController = TextEditingController();
  var _editproductCategoryController = TextEditingController();
  var _editproductPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllProducts();
    clearform();
    getAllCategory();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  clearform() async {
    _productNameController.clear();
    // _productCategoryController.clear();
    _productPriceController.clear();
  }

  getAllProducts() async {
    _productList = <Product>[].toList();
    var products = await _productService.readProduct();
    products.forEach((product) {
      setState(() {
        var productModel = Product();
        productModel.name = product['name'];
        productModel.category = product['category'];
        productModel.price = product['price'];
        productModel.id = product['id'];
        _productList.add(productModel);
      });
    });
  }

  getAllCategory() async {
    _datacategory = <Category>[].toList();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.id = category['id'];
        _datacategory.add(categoryModel);
      });
    });
  }

  _editProduct(BuildContext context, productId) async {
    product = await _productService.readProductById(productId);
    setState(() {
      _editproductNameController.text = product[0]['name'] ?? 'no name';
      _editproductCategoryController.text =
          product[0]['category'] ?? 'no category';
      _editproductPriceController.text = product[0]['price'].toString();
    });
    _editFormDialog(context);
  }

  _showSnackbar(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        leading: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.amber[600], elevation: 0.0),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _showFormDialog(context);
            },
          ),
        ],
        title: Text('Products'),
      ),
      body: ListView.builder(
        itemCount: _productList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
            child: Card(
              elevation: 11,
              child: ListTile(
                subtitle: Text(_productList[index].price!.toString()),
                leading: Text(_productList[index].category!),
                title: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                          child: Text(
                        _productList[index].name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mode_edit,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _editProduct(context, _productList[index].id);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _removeFormDialog(context, _productList[index].id);
                        // print(_productList[index].id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (params) {
        return new AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                clearform();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_productNameController.text.isEmpty) {
                  _showSnackbar(Text("please fill name"));
                } else if (_productPriceController.text.isEmpty) {
                  _showSnackbar(Text("please fill price"));
                } else if (_productCategory == null) {
                  _showSnackbar(Text("please fill category"));
                } else {
                  _product.name = _productNameController.text;
                  // _product.category = _productCategoryController.text;
                  _product.category = _productCategory;
                  _product.price = double.parse(_productPriceController.text);
                  //var result
                  await _productService.saveProduct(_product);
                  Navigator.pop(context);
                  getAllProducts();
                  clearform();
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Text("Products Form"),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                      hintText: "Input Name", labelText: "Name"),
                ),
                // TextField(
                //   controller: _productCategoryController,
                //   decoration: InputDecoration(
                //       hintText: "Input Category", labelText: "Category"),
                // ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _productPriceController,
                  decoration: InputDecoration(
                      hintText: "Input Price", labelText: "Price"),
                ),
                dropdown(),
              ],
            ),
          ),
        );
      },
    );
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              // onPressed: () => Navigator.of(context),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                _product.id = product[0]['id'];
                _product.name = _editproductNameController.text;
                _product.category = _editproductCategoryController.text;
                _product.price = double.parse(_editproductPriceController.text);
                await _productService.updateProduct(_product);
                getAllProducts();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProductScreen()));
                _showSnackbar(Text('Update Product'));
              },
              child: Text(
                'Update',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Text('Form Edit'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _editproductNameController,
                  decoration: InputDecoration(
                      hintText: "Input Name", labelText: "Name"),
                ),
                TextField(
                  enabled: false,
                  controller: _editproductCategoryController,
                  decoration: InputDecoration(
                      hintText: "Input Category", labelText: "Category"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _editproductPriceController,
                  decoration: InputDecoration(
                      hintText: "Input Price", labelText: "Price"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _removeFormDialog(BuildContext context, productId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _productService.deleteProduct(productId);
                getAllProducts();
                Navigator.pop(context);
                _showSnackbar(Text("Deleted"));
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Text('Confirm Delete'),
        );
      },
    );
  }

  Widget dropdown() {
    return new DropdownButton(
      hint: Text("Select Category"),
      value: _productCategory,
      items: _datacategory.map((value) {
        return new DropdownMenuItem(
          child: Text(value.name!),
          value: value.name,
        );
      }).toList(),
      onChanged: (value) {
        // print(value);
        setState(() {
          _productCategory = value;
          print(_productCategory);
          print(_productNameController);
          Navigator.pop(context);
          _showFormDialog(context);
        });
      },
    );
  }
}
