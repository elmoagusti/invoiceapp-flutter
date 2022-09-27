import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/controller/categories.dart';

class CategoryScreen extends StatelessWidget {
  final categories = Get.put(CategoriesController());
  final _categoryNameController = TextEditingController();

  //helper
  clearform() {
    _categoryNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        // leading: ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => HomeScreen()));
        //   },
        //   child: Icon(
        //     Icons.arrow_back_ios,
        //     color: Colors.white,
        //   ),
        //   style: ElevatedButton.styleFrom(
        //       primary: Colors.amber[600], elevation: 0.0),
        // ),
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
      body: GetX<CategoriesController>(
        init: CategoriesController(),
        initState: (_) {},
        builder: (_) {
          return ListView.builder(
            itemCount: categories.data.length,
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
                          categories.data[index].name,
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
            },
          );
        },
      ),
    );
  }

  showSnackBar(BuildContext context, data) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data),
      ),
    );
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (params) {
        return AlertDialog(
          
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                  showSnackBar(context, "please fill name");
                } else {
                  categories.saveData(_categoryNameController.text);
                  categories.getData();
                  Navigator.pop(context);
                  showSnackBar(context, _categoryNameController.text);
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
      },
    );
  }
}
