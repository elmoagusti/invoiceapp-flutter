import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../ui/home.dart';

class CategoryScreen extends StatefulWidget {
  // const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _categoryNameController = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = <Category>[];

  var category;

  @override
  void initState() {
    super.initState();
    getAllCategories();
    clearform();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  clearform() async {
    _categoryNameController.clear();
  }

  getAllCategories() async {
    _categoryList = <Category>[].toList();
    var categories = await _categoryService.readCategory();
    categories.forEach((a) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = a['name'];

        categoryModel.id = a['id'];
        _categoryList.add(categoryModel);
      });
    });
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
        title: Text('Categories'),
      ),
      body: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
              child: Card(
                // elevation: 11,
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Container(
                          child: Text(
                        _categoryList[index].name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (params) {
          return AlertDialog(
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
                  if (_categoryNameController.text.isEmpty) {
                    _showSnackbar(Text("please fill name"));
                  } else {
                    _category.name = _categoryNameController.text;

                    await _categoryService.saveCategory(_category);
                    Navigator.pop(context);
                    getAllCategories();
                    _showSnackbar(Text("Saved"));
                    clearform();
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
            ],
            title: Text("Category Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: "Input Name", labelText: "Name"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
