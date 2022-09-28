import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/categories.dart';
import 'package:untitled2/controller/helper.dart';
import 'package:untitled2/controller/products.dart';

class ProductScreen extends StatelessWidget {
  final _product = Get.put(ProductsController());
  final _category = Get.put(CategoriesController());
  final help = Get.put(HelpC());

  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();

  clearform() async {
    _productNameController.clear();
    _productPriceController.clear();
  }

  _showSnackbar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              help.status(0);
              _showFormDialog(context, 0);
            },
          ),
        ],
        title: Text('Products'),
      ),
      body: Builder(builder: (context) {
        return GetX<ProductsController>(
          init: ProductsController(),
          initState: (_) {},
          builder: (_) {
            return ListView.builder(
              itemCount: _product.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                  child: Card(
                    elevation: 11,
                    child: ListTile(
                      subtitle: Text(_product.data[index].price.toString()),
                      leading: Text(_product.data[index].categoriesname),
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                                child: Text(
                              _product.data[index].name,
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
                              help.status(1);
                              _productNameController.text =
                                  _product.data[index].name;
                              _productPriceController.text =
                                  _product.data[index].price.toString();
                              help.select(_product.data[index].category);

                              // _editProduct(context, _productList[index].id);
                              _showFormDialog(context, _product.data[index].id);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _removeFormDialog(
                                  context, _product.data[index].id);
                              // print(_productList[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }

  _showFormDialog(BuildContext context, int id) {
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
                if (help.stats.value == 0) {
                  //adding new
                  if (_productNameController.text.isEmpty) {
                    _showSnackbar(context, Text("please fill name"));
                  } else if (_productPriceController.text.isEmpty) {
                    _showSnackbar(context, Text("please fill price"));
                  } else {
                    _product.saveData(_productNameController.text,
                        _productPriceController.text, help.a.value);
                    Navigator.pop(context);
                    _product.getData();
                    _showSnackbar(context,
                        Text(_productNameController.text + " Success Create"));

                    clearform();
                  }
                } else {
                  //add update
                  if (_productNameController.text.isEmpty) {
                    _showSnackbar(context, Text("please fill name"));
                  } else if (_productPriceController.text.isEmpty) {
                    _showSnackbar(context, Text("please fill price"));
                  } else {
                    _product.updateData(id, _productNameController.text,
                        help.a.value, _productPriceController.text);
                    Navigator.pop(context);
                    _product.getData();
                    _showSnackbar(context,
                        Text(_productNameController.text + " Success Update"));
                    clearform();
                  }
                }
              },
              child: Text(
                help.stats.value == 1 ? 'Update' : 'Save',
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
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _productPriceController,
                  decoration: InputDecoration(
                      hintText: "Input Price", labelText: "Price"),
                ),
                _dropdown(),
              ],
            ),
          ),
        );
      },
    );
  }

  _dropdown() {
    return Obx(() => DropdownButton<String>(
          value: _category.data.length == 0 ? "No category" : help.a.toString(),
          items: _category.data.map((value) {
            return DropdownMenuItem<String>(
              value: value.id.toString(),
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (value) {
            print(value);
            help.select(int.parse(value!));
          },
        ));
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
                _product.deleteData(productId);
                _product.getData();
                Navigator.pop(context);
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
}
