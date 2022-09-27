import 'database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection? _databaseConnection;

  Repository() {
    //initializat conDATABASE
    _databaseConnection = DatabaseConnection();
  }

  //check if database exists
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _databaseConnection!.setDatabase();
    return _database!;
  }

  //insert data
  inserData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //readdata
  readData(table) async {
    var connection = await database;
    return await connection.query(
      table,
    );
  }

  sortData(table) async {
    var connection = await database;
    return await connection.query(table, orderBy: "category ASC");
  }

  //readinv
  readDataByinv(table, inv) async {
    var connection = await database;
    // print(id);
    return await connection.query(table, where: 'trxid = ?', whereArgs: [inv]);
  }

  readDataBycategory(table, category) async {
    var connection = await database;
    // print(id);
    return await connection
        .query(table, where: 'category = ?', whereArgs: [category]);
  }

  readDataWithDate(table, start, end) async {
    var connection = await database;
    return await connection
        .rawQuery('SELECT * FROM $table WHERE date BETWEEN $start AND $end');
  }

  //editdata
  readDataById(table, id) async {
    var connection = await database;
    // print(id);
    return await connection.query(table, where: 'id = ?', whereArgs: [id]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  deleteData(table, id) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $id");
  }

  deleteDatawithinv(table, notrx) async {
    var connection = await database;
    // return await connection
    //     .rawDelete("DELETE FROM $table WHERE noinvoice = $inv");
    return await connection
        .delete(table, where: 'trxid = ?', whereArgs: [notrx]);
  }

  deleteAll(table) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table");
  }

  //custom product get
  readDataJoin(table) async {
    var connection = await database;
    return await connection.rawQuery(
        'SELECT id,name,price,category,categories_name FROM products INNER JOIN categories ON products.category = categories.categories_id');
  }

  //custom trx get
  readTrxJoin(table) async {
    var connection = await database;
    return await connection.rawQuery(
        'SELECT id,name,price,category,categories_name FROM products INNER JOIN categories ON products.category = categories.categories_id');
  }
}
