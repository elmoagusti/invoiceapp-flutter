import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import 'package:file_picker/file_picker.dart';
import '../home.dart';

// import 'package:file_picker/file_picker.dart';
class DbSetting extends StatefulWidget {
  const DbSetting({Key? key}) : super(key: key);

  @override
  _DbSettingState createState() => _DbSettingState();
}

class _DbSettingState extends State<DbSetting> {
  String message = '';

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
        title: Text("Backup/Restore Data"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber[600],
                  // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onPressed: () async {
                final dbFolder = await getDatabasesPath();
                File source1 = File('$dbFolder/dbprintin');

                Directory copyTo = Directory("storage/emulated/0/Documents");
                if ((await copyTo.exists())) {
                  // print("Path exist");
                  var status = await Permission.storage.status;
                  if (!status.isGranted) {
                    await Permission.storage.request();
                  }
                } else {
                  print("not exist");
                  if (await Permission.storage.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    await copyTo.create();
                  } else {
                    print('Please give permission');
                  }
                }

                String newPath = "${copyTo.path}/dbprintin";
                await source1.copy(newPath);

                setState(() {
                  message = 'Successfully Copied DB to $newPath';
                });
              },
              child: const Text('Backup DataBase'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber[600],
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onPressed: () async {
                var databasesPath = await getDatabasesPath();
                var dbPath = join(databasesPath, 'dbprintin');
                await deleteDatabase(dbPath);
                setState(() {
                  message = 'Successfully deleted DB';
                });
              },
              child: const Text('Delete DataBase'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber[600],
                  // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onPressed: () async {
                var databasesPath = await getDatabasesPath();
                var dbPath = join(databasesPath, 'dbprintin');

                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File source = File(result.files.single.path!);
                  await source.copy(dbPath);
                  setState(() {
                    message =
                        'Successfully Restored DB, Please Restart Applications';
                  });
                } else {
                  // User canceled the picker

                }
              },
              child: const Text('Restore DataBase'),
            ),
          ],
        ),
      ),
    );
  }
}
