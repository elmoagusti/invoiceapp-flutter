import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/models/main.dart';
import 'package:untitled2/services/main_service.dart';
import 'package:untitled2/ui/settings/picker.dart';

import '../home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //image picker
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
    print(value);
  }

  // dynamic _pickImageError;

  // String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            // _pickImageError = e;
          });
        }
      });
    } else {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFile = pickedFile;
          });
        } catch (e) {
          setState(() {
            // _pickImageError = e;
          });
        }
      });
    }
  }

  //initialdata

  var _controllerOutlet = TextEditingController();
  var _controllerStore = TextEditingController();
  var _controllerAddress = TextEditingController();
  var _controllerPhone = TextEditingController();
  int _typetax = 0;
  var _controllerTax = TextEditingController(text: "0");
  var _controllerHeader = TextEditingController();
  var _controllerFooter = TextEditingController();
//initialdata
  var main;
  var _main = Mains();
  var _mainService = MainService();
  List<Mains> _mainList = <Mains>[];

  var mains;

  @override
  void initState() {
    super.initState();
    getMains();
  }

  getMains() async {
    _mainList = <Mains>[].toList();
    var mains = await _mainService.readMain();
    mains.forEach((a) {
      setState(() {
        var mainModel = Mains();
        mainModel.outlet = a['outlet'];
        mainModel.store = a['store'];
        mainModel.address = a['address'];
        mainModel.phone = a['phone'];
        mainModel.typetax = _typetax;
        mainModel.tax = a['tax'];
        mainModel.header = a['header'];
        mainModel.footer = a['footer'];
        mainModel.logo = a['logo'];
        mainModel.id = a['id'];
        _mainList.add(mainModel);
      });
    });
    print(mains);
  }

  _editMains(BuildContext context, id) async {
    main = await _mainService.readById(id);
    setState(() {
      _controllerOutlet.text = main[0]['outlet'] ?? "";
      _controllerStore.text = main[0]['store'] ?? "";
      _controllerAddress.text = main[0]['address'] ?? "";
      _controllerPhone.text = main[0]['phone'] ?? "";
      _typetax = main[0]['typetax'];
      _controllerTax.text = main[0]['tax'].toString();
      _controllerHeader.text = main[0]['header'] ?? "";
      _controllerFooter.text = main[0]['footer'] ?? "";
    });

    _showFormDialog(context);
  }

  clearform() {
    _controllerStore.clear();
    _controllerOutlet.clear();
    _controllerAddress.clear();
    _controllerAddress.clear();
    _typetax = 0;
    _controllerTax.clear();
    _controllerHeader.clear();
    _controllerFooter.clear();
  }

  _showSnackbar(message) {
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
          _mainList.isEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showFormDialog(context);
                  },
                )
              : Text(""),
        ],
        title: Text('Main Settings'),
      ),
      body: ListView.builder(
          itemCount: _mainList.length,
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
                        _mainList[index].store.toString(),
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
                          _editMains(context, _mainList[index].id);
                        },
                      ),
                    ],
                  ),
                  leading: Image.file(File(_mainList[index].logo.toString())),
                  subtitle: Text(_mainList[index].logo.toString()),
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
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (_imageFileList != null) {
                    for (var i = 0; i < _imageFileList!.length; i++) {
                      if (_mainList.isEmpty) {
                        print(_imageFileList![i].path);
                        _main.store = _controllerStore.text;
                        _main.outlet = _controllerOutlet.text;
                        _main.address = _controllerAddress.text != ""
                            ? _controllerAddress.text
                            : "";
                        _main.phone = _controllerPhone.text != ""
                            ? _controllerPhone.text
                            : "";
                        _main.typetax = _typetax;
                        _main.tax = double.parse(_controllerTax.text);
                        _main.header = _controllerHeader.text != ""
                            ? _controllerHeader.text
                            : "";
                        _main.footer = _controllerFooter.text != ""
                            ? _controllerFooter.text
                            : "";
                        _main.logo = _imageFileList![i].path.toString();

                        await _mainService.saveMain(_main);
                        getMains();
                        Navigator.pop(context);
                        _showSnackbar(Text("Saved new Data"));
                      } else if (_mainList.isNotEmpty) {
                        print(_imageFileList![i].path);
                        _main.id = main[0]['id'];
                        _main.store = _controllerStore.text;
                        _main.outlet = _controllerOutlet.text;
                        _main.address = _controllerAddress.text != ""
                            ? _controllerAddress.text
                            : "";
                        _main.phone = _controllerPhone.text != ""
                            ? _controllerPhone.text
                            : "";
                        _main.typetax = _typetax;
                        _main.tax = double.parse(_controllerTax.text);
                        _main.header = _controllerHeader.text != ""
                            ? _controllerHeader.text
                            : "";
                        _main.footer = _controllerFooter.text != ""
                            ? _controllerFooter.text
                            : "";
                        _main.logo = _imageFileList![i].path.toString();

                        await _mainService.updateMain(_main);
                        getMains();
                        Navigator.pop(context);
                        _showSnackbar(Text("Saved Update Data"));
                      }
                    }
                  } else {
                    if (_mainList.isEmpty) {
                      _main.store = _controllerStore.text;
                      _main.outlet = _controllerOutlet.text;
                      _main.address = _controllerAddress.text != ""
                          ? _controllerAddress.text
                          : "";
                      _main.phone = _controllerPhone.text != ""
                          ? _controllerPhone.text
                          : "";
                      _main.typetax = _typetax;
                      _main.tax = double.parse(_controllerTax.text);
                      _main.header = _controllerHeader.text != ""
                          ? _controllerHeader.text
                          : "";
                      _main.footer = _controllerFooter.text != ""
                          ? _controllerFooter.text
                          : "";

                      await _mainService.saveMain(_main);
                      getMains();
                      Navigator.pop(context);
                      _showSnackbar(Text("Saved new Data"));
                    } else if (_mainList.isNotEmpty) {
                      _main.id = main[0]['id'];
                      _main.store = _controllerStore.text;
                      _main.outlet = _controllerOutlet.text;
                      _main.address = _controllerAddress.text != ""
                          ? _controllerAddress.text
                          : "";
                      _main.phone = _controllerPhone.text != ""
                          ? _controllerPhone.text
                          : "";
                      _main.typetax = _typetax;
                      _main.tax = double.parse(_controllerTax.text);
                      _main.header = _controllerHeader.text != ""
                          ? _controllerHeader.text
                          : "";
                      _main.footer = _controllerFooter.text != ""
                          ? _controllerFooter.text
                          : "";
                      _main.logo = main[0]['logo'];
                      await _mainService.updateMain(_main);
                      getMains();
                      Navigator.pop(context);
                      _showSnackbar(Text("Saved Update Data"));
                    }
                  }
                },
                child: Text(
                  'Save',
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
                  Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () {
                            _onImageButtonPressed(ImageSource.gallery,
                                context: context);
                          })),
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
                        value: _typetax == 0 ? false : true,
                        onChanged: (value) {
                          setState(() {
                            _typetax = value == false ? 0 : 1;
                            print(_typetax);
                            Navigator.pop(context);
                            _showFormDialog(context);
                          });
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
                        hintText: "Input Tax example: 10%", labelText: "Tax %"),
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
          );
        });
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add optional parameters'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: maxWidthController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration:
                    InputDecoration(hintText: "Enter maxWidth if desired"),
              ),
              TextField(
                controller: maxHeightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration:
                    InputDecoration(hintText: "Enter maxHeight if desired"),
              ),
              TextField(
                controller: qualityController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(hintText: "Enter quality if desired"),
              ),
              Text(
                "MAX SIZE IMAGE WIDTH AND HEIGHT 300x300, IF HAVE RESIZE PLEASE OPEN IMG2GO.COM/RESIZE-IMAGE",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('PICK'),
                onPressed: () {
                  double? width = maxWidthController.text.isNotEmpty
                      ? double.parse(maxWidthController.text)
                      : null;
                  double? height = maxHeightController.text.isNotEmpty
                      ? double.parse(maxHeightController.text)
                      : null;
                  int? quality = qualityController.text.isNotEmpty
                      ? int.parse(qualityController.text)
                      : null;
                  onPick(width, height, quality);
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
