import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';
import '../../src/config.dart';
import '../home.dart';

class DbSetting extends StatelessWidget {
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
        title: Text("Backup/Restore DataBase"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber[600],
                  textStyle: TextStyle(
                    fontSize: 20,
                  )),
              onPressed: () async {
                final dbFolder = await getApplicationDocumentsDirectory();
                File source1 = File('${dbFolder.path}/dbprintin');

                Directory copyTo = Directory("storage/emulated/0/Documents");
                if ((await copyTo.exists())) {
                  var status = await Permission.manageExternalStorage.status;
                  if (!status.isGranted) {
                    await Permission.manageExternalStorage.request();
                  }
                } else {
                  print("not exist");
                  if (await Permission.manageExternalStorage
                      .request()
                      .isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    await copyTo.create();
                  } else {
                    print('Please give permission');
                  }
                }

                String newPath = "${copyTo.path}/dbprintin";
                await source1.copy(newPath);
                notif(context, "Directory: " + newPath, true);
              },
              child: const Text('Backup AllData'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber[600],
                  textStyle: TextStyle(
                    fontSize: 20,
                  )),
              onPressed: () async {
                var databasesPath = await getApplicationDocumentsDirectory();
                var dbPath = join(databasesPath.path, 'dbprintin');
                await deleteDatabase(dbPath);
                notif(context, "success clear data, please restart apps", true);
              },
              child: const Text('Delete AllData'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber[600],
                  textStyle: TextStyle(
                    fontSize: 20,
                  )),
              onPressed: () async {
                var databasesPath = await getApplicationDocumentsDirectory();
                var dbPath = join(databasesPath.path, 'dbprintin');

                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  if (result.names.toString() == "[dbprintin]") {
                    File source = File(result.files.single.path!);
                    await source.copy(dbPath);
                    notif(context, "success restore data, please restart apps",
                        true);
                  } else {
                    // User canceled the picker
                    notif(context, "file type not true ${result.names}", false);
                  }
                } else {
                  // User canceled the picker
                }
              },
              child: const Text('Restore Data'),
            ),
          ],
        ),
      ),
    );
  }

  notif(context, msg, status) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (params) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
          content: Container(
            // color: Colors.red,
            height: SizeConfig.blockSizeVertical! * 25,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  status == true
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: SizeConfig.blockSizeVertical! * 20,
                        )
                      : Icon(
                          Icons.highlight_off,
                          color: Colors.red[600],
                          size: SizeConfig.blockSizeVertical! * 20,
                        ),
                  status == true
                      ? Text(
                          "Success",
                          style: TextStyle(
                              color: Colors.green[600],
                              fontSize: SizeConfig.blockSizeVertical! * 2,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "Failed",
                          style: TextStyle(
                              color: Colors.red[600],
                              fontSize: SizeConfig.blockSizeVertical! * 2,
                              fontWeight: FontWeight.w600),
                        ),
                  Text(
                    msg,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: SizeConfig.blockSizeVertical! * 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
