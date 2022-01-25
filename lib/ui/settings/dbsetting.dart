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
        title: Text("Backup/Restore DataBase"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
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
                  message = 'Successfully backup DB to $newPath';
                });
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
                setState(() {
                  message = 'Successfully deleted DataBase';
                });
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
              child: const Text('Restore Data'),
            ),
          ],
        ),
      ),
    );
  }
}
