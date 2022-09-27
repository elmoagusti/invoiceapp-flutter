import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/controller/helper.dart';
import 'package:untitled2/controller/store.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/services/main_service.dart';
import 'package:untitled2/ui/settings/dbsetting.dart';

import '../home.dart';

class MainScreen extends StatelessWidget {
  final help = Get.put(HelpC());
  final store = Get.put(StoresController());

  final _controllerOutlet = TextEditingController();
  final _controllerStore = TextEditingController();
  final _controllerAddress = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerTax = TextEditingController(text: "10");
  final _controllerHeader = TextEditingController();
  final _controllerFooter = TextEditingController();

  clearform() {
    _controllerStore.clear();
    _controllerOutlet.clear();
    _controllerAddress.clear();
    _controllerAddress.clear();
    // _typetax = 0;
    _controllerTax.clear();
    _controllerHeader.clear();
    _controllerFooter.clear();
  }

  showSnackbar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: message));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          store.data.isEmpty
              ?
              //     ?
              IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    help.stats.value = 0;
                    help.imgPath.value = "";
                    _showFormDialog(context, 0);
                  },
                )
              : Text(""),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => DbSetting()));
            },
          )
        ],
        title: Text('Main Settings'),
      ),
      body: Obx(
        () => store.data.length == 0
            ? Center(
                child: Text("No Data"),
              )
            : ListView.builder(
                itemCount: store.data.length,
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
                              store.data[index].store,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                            Spacer(
                              flex: 2,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.mode_edit,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                help.stats.value = 1;

                                _controllerStore.text = store.data[index].store;
                                _controllerOutlet.text =
                                    store.data[index].outlet;
                                _controllerAddress.text =
                                    store.data[index].address;
                                _controllerPhone.text = store.data[index].phone;
                                _controllerTax.text =
                                    store.data[index].tax.toString();
                                _controllerHeader.text =
                                    store.data[index].header;
                                _controllerFooter.text =
                                    store.data[index].footer;

                                help.imgPath.value = store.data[index].logo;
                                help.a.value = store.data[index].typetax;

                                _showFormDialog(context, store.data[index].id);
                              },
                            ),
                          ],
                        ),
                        // ignore: unnecessary_null_comparison
                        leading: store.data[index].logo.toString() != ""
                            ? Image.file(
                                File(
                                  store.data[index].logo.toString(),
                                ),
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                      color: Colors.grey,
                                      width: 50,
                                      height: 50,
                                      child: const Center(
                                          child: const Text('Error img',
                                              textAlign: TextAlign.center)));
                                },
                              )
                            : Text("No img"),
                        subtitle: Text(store.data[index].logo.toString()),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  _showFormDialog(BuildContext context, int id) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (params) {
          return Obx(() => AlertDialog(
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (help.stats.value == 1) {
                        print("update data");

                        store.editData(
                            id,
                            _controllerOutlet.text,
                            _controllerStore.text,
                            _controllerAddress.text,
                            _controllerPhone.text,
                            help.a.value,
                            _controllerTax.text,
                            _controllerHeader.text,
                            _controllerFooter.text,
                            help.imgPath.value);
                        store.getData();
                        Navigator.pop(context);
                        showSnackbar(context,
                            Text("Update Data " + _controllerStore.text));
                        clearform();
                      } else {
                        print("save data");
                        store.saveData(
                            _controllerOutlet.text,
                            _controllerStore.text,
                            _controllerAddress.text,
                            _controllerPhone.text,
                            help.a.value,
                            _controllerTax.text,
                            _controllerHeader.text,
                            _controllerFooter.text,
                            help.imgPath.value);

                        store.getData();
                        Navigator.pop(context);
                        showSnackbar(context,
                            Text("Saved Data " + _controllerStore.text));
                        clearform();
                      }
                    },
                    child: Text(
                      help.stats.value == 0 ? 'Save' : 'Update',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
                title: Text("Main Form"),
                content: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Add Logo Struk")),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () {
                                help.onImageButtonPressed(ImageSource.gallery);
                              },
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: help.imgPath.value != ""
                                ? Image.file(
                                    File(help.imgPath.value),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                          color: Colors.grey,
                                          width: 50,
                                          height: 50,
                                          child: const Center(
                                              child: const Text('Error img',
                                                  textAlign:
                                                      TextAlign.center)));
                                    },
                                  )
                                : Text(""),
                          )
                        ],
                      ),
                      TextField(
                        controller: _controllerStore,
                        decoration: InputDecoration(
                            hintText: "Input Store", labelText: "Store"),
                      ),
                      TextField(
                        controller: _controllerOutlet,
                        decoration: InputDecoration(
                            hintText: "Input Outlet", labelText: "Outlet"),
                      ),
                      TextField(
                        controller: _controllerAddress,
                        decoration: InputDecoration(
                            hintText: "Input Address", labelText: "Address"),
                      ),
                      TextField(
                        controller: _controllerPhone,
                        decoration: InputDecoration(
                            hintText: "Input Phone", labelText: "Phone"),
                      ),
                      Row(
                        children: [
                          Text(
                            "Tax Inclusive",
                            overflow: TextOverflow.ellipsis,
                          ),
                          CupertinoSwitch(
                            activeColor: Colors.amber[700],
                            value: help.a.value == 0 ? false : true,
                            onChanged: (value) {
                              // setState(() {
                              help.a.value = value == false ? 0 : 1;
                              print(help.a);
                            },
                          ),
                          Text(
                            "Tax Exclusive",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _controllerTax,
                        decoration: InputDecoration(
                            hintText: "Input Tax example: 10%",
                            labelText: "Tax %"),
                      ),
                      TextField(
                        controller: _controllerHeader,
                        decoration: InputDecoration(
                            hintText: "Input Header", labelText: "Header"),
                      ),
                      TextField(
                        controller: _controllerFooter,
                        decoration: InputDecoration(
                            hintText: "Input Footer", labelText: "Footer"),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  // Future<void> _displayPickImageDialog(
  //     BuildContext context, OnPickImageCallback onPick) async {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Add optional parameters'),
  //         content: Column(
  //           children: <Widget>[
  //             TextField(
  //               controller: maxWidthController,
  //               keyboardType: TextInputType.numberWithOptions(decimal: true),
  //               decoration:
  //                   InputDecoration(hintText: "Enter maxWidth if desired"),
  //             ),
  //             TextField(
  //               controller: maxHeightController,
  //               keyboardType: TextInputType.numberWithOptions(decimal: true),
  //               decoration:
  //                   InputDecoration(hintText: "Enter maxHeight if desired"),
  //             ),
  //             TextField(
  //               controller: qualityController,
  //               keyboardType: TextInputType.number,
  //               decoration:
  //                   InputDecoration(hintText: "Enter quality if desired"),
  //             ),
  //             Text(
  //               "MAX SIZE IMAGE WIDTH AND HEIGHT 300x300, IF HAVE RESIZE PLEASE OPEN IMG2GO.COM/RESIZE-IMAGE",
  //               style: TextStyle(color: Colors.red),
  //             )
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('CANCEL'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //               child: const Text('PICK'),
  //               onPressed: () {
  //                 double? width = maxWidthController.text.isNotEmpty
  //                     ? double.parse(maxWidthController.text)
  //                     : null;
  //                 double? height = maxHeightController.text.isNotEmpty
  //                     ? double.parse(maxHeightController.text)
  //                     : null;
  //                 int? quality = qualityController.text.isNotEmpty
  //                     ? int.parse(qualityController.text)
  //                     : null;
  //                 onPick(width, height, quality);
  //                 Navigator.of(context).pop();
  //               }),
  //         ],
  //       );
  //     },
  //   );
  // }
}
