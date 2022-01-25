import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'dbprintin');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);

    print(database);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database
        .execute('CREATE TABLE categories( id INTEGER PRIMARY KEY, name TEXT)');

    await database
        .execute('CREATE TABLE payments( id INTEGER PRIMARY KEY, name TEXT)');

    await database.execute(
        'CREATE TABLE products( id INTEGER PRIMARY KEY, name TEXT, category TEXT, price DOUBLE)');

    await database.execute(
        'CREATE TABLE transactions( id INTEGER PRIMARY KEY, noinvoice TEXT, name TEXT,tax DOUBLE,subtotal DOUBLE, discount DOUBLE, nettotal DOUBLE, type TEXT, date INT,money DOUBLE, change DOUBLE )');

    await database.execute(
        'CREATE TABLE transactions_details( id INTEGER PRIMARY KEY, noinvoice TEXT,name TEXT, price DOUBLE, qty INTEGER, total DOUBLE, date INT )');

    await database.execute(
        'CREATE TABLE carts( id INTEGER PRIMARY KEY, noinvoice TEXT, name TEXT, price DOUBLE, qty INTEGER, total DOUBLE )');

    await database.execute(
        'CREATE TABLE invoices( id INTEGER PRIMARY KEY, number INTEGER )');

    await database.execute(
        'CREATE TABLE mains( id INTEGER PRIMARY KEY, outlet TEXT, store TEXT, address TEXT, phone TEXT,typetax INT, tax DOUBLE, header TEXT, footer TEXT, logo TEXT )');
  }
}
