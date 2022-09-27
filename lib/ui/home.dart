import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled2/controller/cart.dart';
import 'package:untitled2/controller/categories.dart';
import 'package:untitled2/controller/products.dart';
import 'package:untitled2/controller/store.dart';
import 'package:untitled2/controller/transaction.dart';
import 'package:untitled2/controller/type_payment.dart';
import 'package:untitled2/drawer/drawer_navigate.dart';
import '../src/config.dart';
import '../ui/payment/index.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../services/category_service.dart';
import '../services/product_service.dart';
import 'package:untitled2/repo/sharedprefs.dart';

class Previous extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Previous> {
  int count = 0;

  getcounter() async {
    var data = await SharedPref.getData();
    setState(() {
      if (data != null) {
        count = data;
      }
      print(data);
      print(count);
    });
  }

//testingdetails

  // List<TransactionDetails> _detailList = <TransactionDetails>[];
  // var _detailService = DetailService();
  // var _data = TransactionDetails();

  //initialdata
  List<Product> _productList = <Product>[];
  List<Category> _categoryList = <Category>[];
  List<Cart> _cartList = <Cart>[];

  var _categoryService = CategoryService();
  var _productService = ProductService();

  //datainputcart
  var product;
  var _productNameController = TextEditingController();
  var _productPriceController = TextEditingController();
  var _productQtyController = TextEditingController();
  // var _productTotalController;
  var _cart = Cart();
  var _cartService = CartService();

  var dateNow = DateFormat('yyMMdd').format(DateTime.now());
  var f = NumberFormat("Rp #,##0.00", "en_US");
  var store = 'INV001';
  // int count = 0;
  @override
  void initState() {
    super.initState();
    getAllProducts();
    getAllCategory();
    getAllCart();
    // getAllDetail();
    getcounter();
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
    _categoryList = <Category>[].toList();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  getAllCart() async {
    _cartList = <Cart>[].toList();
    var carts = await _cartService.readCart();
    carts.forEach((cart) {
      setState(() {
        var cartModel = Cart();
        cartModel.id = cart['id'];
        cartModel.name = cart['name'];
        cartModel.noinvoice = cart['noinvoice'];
        cartModel.price = cart['price'];
        cartModel.qty = cart['qty'];
        cartModel.total = cart['total'];
        _cartList.add(cartModel);
      });
    });
  }

  //load details cart
  _toCartProduct(BuildContext context, productId) async {
    product = await _productService.readProductById(productId);
    setState(() {
      _productNameController.text = product[0]['name'] ?? 'no name';
      _productPriceController.text = product[0]['price'].toString();
      _productQtyController.text = 1.toString();
    });
    _cartFormDialog(context);
  }

  //filter category
  _productbyCat(BuildContext context, category) async {
    _productList = <Product>[].toList();

    var product = await _productService.readProductByCategory(category);
    product.forEach((product) {
      setState(() {
        var productModel = Product();
        productModel.name = product['name'];
        productModel.category = product['category'];
        productModel.price = product['price'];
        productModel.id = product['id'];
        _productList.add(productModel);
      });
    });

    print(product);
  }

  //testingdetail
  // getAllDetail() async {
  //   _detailList = <TransactionDetails>[].toList();
  //   var datas = await _detailService.readCart();
  //   datas.forEach((data) {
  //     setState(() {
  //       var dataModel = TransactionDetails();
  //       dataModel.id = data['id'];
  //       dataModel.name = data['name'];
  //       dataModel.noinvoice = data['noinvoice'];
  //       dataModel.price = data['price'];
  //       dataModel.qty = data['qty'];
  //       dataModel.total = data['total'];
  //       _detailList.add(dataModel);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double _subTotal = 0;
    for (var i = 0; i < _cartList.length; i++) {
      _subTotal += double.parse(_cartList[i].total.toString());
    }
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 40,
        backgroundColor: Colors.amber[600],
        actions: [
          Builder(
              builder: (context) => TextButton(
                  onPressed: () {
                    getAllProducts();
                  },
                  child: Text(
                    'Show All',
                    style: TextStyle(color: Colors.white),
                  ))
              //  IconButton(
              //     icon: Icon(Icons.view_stream),
              //     onPressed: () {
              //       getAllProducts();
              //     }),
              ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: DrawerNavigate(),
      endDrawer: Drawer(
        child: Container(
          color: Colors.amber[600],
          child: Column(
            children: <Widget>[
              Expanded(
                // ListView contains a group of widgets that scroll inside the drawer
                child: ListView.builder(
                  itemCount: _cartList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        _cartList.isEmpty
                            ? Text('')
                            : Padding(
                                padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                child: Card(
                                  // color: Colors.orange,
                                  elevation: 11,
                                  child: ListTile(
                                    title: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                              child: Text(
                                            _cartList[index].name!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                        ),
                                        Spacer(
                                          flex: 2,
                                        ),
                                        Container(
                                            child: Text(
                                          f.format(_cartList[index].total),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )),
                                      ],
                                    ),
                                    subtitle: Text(
                                        _cartList[index].price!.toString() +
                                            ' x ' +
                                            _cartList[index].qty.toString()),
                                    // leading: Text(_cartList[index].noinvoice!),
                                  ),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                child: Align(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        title: Align(
                          child: Text('Clear All Carts'),
                          alignment: Alignment(-1.4, 0),
                        ),
                        onTap: () async {
                          await _cartService.deleteAll();
                          // getAllCart();
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (context) => HomeScreen()));
                          setState(() {
                            getAllCart();
                          });
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.local_atm,
                          color: Colors.green,
                          size: 40,
                        ),
                        title: Align(
                          alignment: Alignment(-1.2, 0),
                          child: Text('SubTotal: ' + f.format(_subTotal),
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                        ),
                        onTap: () async {
                          print(_subTotal);
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            _cartList.isEmpty
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Stack(
                                          clipBehavior: Clip.none,
                                          children: <Widget>[
                                            Positioned(
                                              right: -40.0,
                                              top: -40.0,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: CircleAvatar(
                                                  child: Icon(Icons.close),
                                                  backgroundColor: Colors.red,
                                                ),
                                              ),
                                            ),
                                            Text('Carts is Empty'),
                                          ],
                                        ),
                                      );
                                    })
                                : Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                            // invoice: store +
                                            //     dateNow +
                                            //     count.toString(),
                                            )));
                          },
                          child: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(color: Colors.amber, spreadRadius: 3),
                              // ],
                            ),
                            child: Center(
                              child: Text(
                                'PAYMENT',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _portraitMode();
          } else {
            return _landscapeMode();
          }
        },
      ),
    );
  }

  Widget _landscapeMode() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
                itemExtent: 150,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                      child: Container(
                        child: Center(
                            child: Text(
                          _categoryList[index].name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.amber[100],
                              fontSize: 20),
                        )),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[600],
                        ),
                      ),
                      onTap: () {
                        print(_categoryList[index].name!);
                        _productbyCat(context, _categoryList[index].name);
                      },
                    ),
                itemCount: _categoryList.length),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => GestureDetector(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        _productList[index].name!,
                        // overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      Spacer(),
                      Text(f.format(_productList[index].price).toString()),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5.0),
                // color: Colors.yellow,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber[100],
                  // image: DecorationImage(
                  //     colorFilter: new ColorFilter.mode(
                  //         Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  //     image: NetworkImage(
                  //         "https://e7.pngegg.com/pngimages/165/189/png-clipart-food-bowl-computer-icons-soup-menu-soup-food.png"),
                  //     fit: BoxFit.cover),
                  border: Border.all(color: Colors.amber, width: 3),
                ),
              ),
              onTap: () {
                print(_productList[index].name!);
                print(_productList[index].category!);
                _toCartProduct(context, _productList[index].id);
              },
            ),
            childCount: _productList.length,
          ),
        ),
      ],
    );
  }

  Widget _portraitMode() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
                itemExtent: 150,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => GestureDetector(
                      child: Container(
                        child: Center(
                            child: Text(
                          _categoryList[index].name!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.amber[100],
                              fontSize: 20),
                        )),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber[600],
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.amber, spreadRadius: 4),
                          // ],
                        ),
                      ),
                      onTap: () {
                        print(_categoryList[index].name!);
                        _productbyCat(context, _categoryList[index].name);
                      },
                    ),
                itemCount: _categoryList.length),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => GestureDetector(
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        _productList[index].name!,
                        // overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      Spacer(),
                      // Text(''),
                      Text(f.format(_productList[index].price).toString()),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5.0),
                // color: Colors.yellow,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber[100],
                  // image: DecorationImage(
                  //     colorFilter: new ColorFilter.mode(
                  //         Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  //     image: NetworkImage(
                  //         "https://e7.pngegg.com/pngimages/165/189/png-clipart-food-bowl-computer-icons-soup-menu-soup-food.png"),
                  //     fit: BoxFit.cover),
                  border: Border.all(color: Colors.amber, width: 3),
                  // boxShadow: [
                  //   BoxShadow(color: Colors.amber, spreadRadius: 3),
                  // ],
                ),
              ),
              onTap: () {
                print(_productList[index].name!);
                print(_productList[index].category!);
                _toCartProduct(context, _productList[index].id);
              },
            ),
            childCount: _productList.length,
          ),
        ),
      ],
    );
  }

  _cartFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                print(_productQtyController.text);
                print(_productPriceController.text);

                print(double.parse(_productPriceController.text) *
                    int.parse(_productQtyController.text));
                print(store + dateNow + count.toString());
                _cart.name = _productNameController.text;
                _cart.price = double.parse(_productPriceController.text);
                _cart.total = double.parse(_productPriceController.text) *
                    int.parse(_productQtyController.text);
                _cart.qty = int.parse(_productQtyController.text);
                _cart.noinvoice = store + dateNow + count.toString();

                //result
                await _cartService.saveCart(_cart);
                Navigator.pop(context);
                getAllCart();
              },
              child: Text(
                'ADD CART',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Center(child: Text('ADD CART')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  enabled: false,
                  controller: _productNameController,
                  decoration: InputDecoration(
                      hintText: "Input Name", labelText: "Name"),
                ),
                TextField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _productPriceController,
                  decoration: InputDecoration(
                      hintText: "Input Price", labelText: "Price"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (int.parse(_productQtyController.text) > 1) {
                              _productQtyController.text =
                                  (int.parse(_productQtyController.text) - 1)
                                      .toString();
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _productQtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(

                              // labelText: "Discount",
                              hintText: "Qty"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _productQtyController.text =
                                (int.parse(_productQtyController.text) + 1)
                                    .toString();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final C = Get.put(ProductsController());
  final A = Get.put(CategoriesController());
  final S = Get.put(StoresController());
  final T = Get.put(CartsController());
  final P = Get.put(TypePaymentController());
  final trx = Get.put(TransactionsController());

  final f = NumberFormat("Rp #,##0", "en_US");

  //
  // var _id;
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productQtyController = TextEditingController();
  final _productSubtotalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //mediaquery
    SizeConfig().init(context);

    // double _subTotal = 0;

    return Scaffold(
        appBar: AppBar(
          // toolbarHeight: 40,
          backgroundColor: Colors.amber[600],
          actions: [
            // Builder(
            //   builder: (context) => TextButton(
            //     onPressed: () {
            //       C.getData();
            //     },
            //     child: Text(
            //       'Show All',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  C.getData();
                }),
            // ),

            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        drawer: DrawerNavigate(),
        endDrawer: CartNavigate(),
        body: _portraitMode());
  }

  Widget _portraitMode() {
    return CustomScrollView(
      slivers: <Widget>[
        GetX<CategoriesController>(
          init: CategoriesController(),
          initState: (_) {},
          builder: (x) {
            return SliverToBoxAdapter(
              child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                      itemExtent: 150,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                            child: Container(
                              child: Center(
                                  child: Text(
                                x.data[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.amber[100],
                                    fontSize: 20),
                              )),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber[600],
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Colors.amber, spreadRadius: 4),
                                // ],
                              ),
                            ),
                            onTap: () {
                              C.filterProduct(A.data[index].name);
                            },
                          ),
                      itemCount: x.data.length)),
            );
          },
        ),
        GetX<ProductsController>(
          init: ProductsController(),
          initState: (_) {},
          builder: (_) {
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            C.data[index].name.toUpperCase(),
                            // overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                          Spacer(),
                          Text(
                            f.format(C.data[index].price).toString(),
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(5.0),
                    // color: Colors.yellow,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber[100],
                      // image: DecorationImage(
                      //     colorFilter: new ColorFilter.mode(
                      //         Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      //     image: NetworkImage(
                      //         "https://e7.pngegg.com/pngimages/165/189/png-clipart-food-bowl-computer-icons-soup-menu-soup-food.png"),
                      //     fit: BoxFit.cover),
                      border: Border.all(color: Colors.amber, width: 3),
                      // boxShadow: [
                      //   BoxShadow(color: Colors.amber, spreadRadius: 3),
                      // ],
                    ),
                  ),
                  onTap: () {
                    _productNameController.text = C.data[index].name;
                    _productPriceController.text =
                        C.data[index].price.toString();
                    _productSubtotalController.text = "0";
                    _productQtyController.text = "0";
                    _cartFormDialog(context, C.data[index].id);
                  },
                ),
                childCount: C.data.length,
              ),
            );
          },
        ),
      ],
    );
  }

  _cartFormDialog(BuildContext context, id) {
    return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (_productQtyController.text != "0") {
                  T.saveData(
                    id,
                    _productNameController.text,
                    double.parse(_productPriceController.text),
                    int.parse(_productQtyController.text),
                    double.parse(_productSubtotalController.text),
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(
                'ADD CART',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
          title: Center(child: Text('ADD CART')),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  enabled: false,
                  controller: _productNameController,
                  decoration: InputDecoration(
                      hintText: "Input Name", labelText: "Name"),
                ),
                TextField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _productPriceController,
                  decoration: InputDecoration(
                      hintText: "Input Price", labelText: "Price"),
                ),
                TextField(
                  enabled: false,
                  keyboardType: TextInputType.number,
                  controller: _productSubtotalController,
                  decoration: InputDecoration(
                      hintText: "Subtotal", labelText: "SubTotal"),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (int.parse(_productQtyController.text) > 1) {
                            _productQtyController.text =
                                (int.parse(_productQtyController.text) - 1)
                                    .toString();
                            _productSubtotalController.text =
                                (double.parse(_productPriceController.text) *
                                        int.parse(_productQtyController.text))
                                    .toString();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              '-',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: TextField(
                          enabled: false,
                          textAlign: TextAlign.center,
                          controller: _productQtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(hintText: "Qty"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _productQtyController.text =
                              (int.parse(_productQtyController.text) + 1)
                                  .toString();
                          _productSubtotalController.text =
                              (double.parse(_productPriceController.text) *
                                      int.parse(_productQtyController.text))
                                  .toString();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[200],
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
