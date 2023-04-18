import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rrhh/model/ScanModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DBProvider{

  static Database? _database ;
  static final DBProvider  db = DBProvider._();
  DBProvider._();

   Future <Database> get database async {
    if( _database!= null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future <Database> initDB() async{

     //PACH DE DONDE SE ALMACENARA LA BASE DATOS
     Directory  documentDirectory = await getApplicationDocumentsDirectory();
     final path = join (documentDirectory.path,'ScansDB.db');
     print(path);
     return  await openDatabase(
         path,
         version: 1,
       onOpen: (db) {},
       onCreate: ( Database db, int version) async{
           String sql = '''
               Create table Scans (
                id INTEGER PRIMERY KEY,
                tipo TEXT,
                valor TEXT
               )
               ''';
           await db.execute(sql);
       }
     );
  }
  nuevoScanRaw( ScanModel nuevoScant ) async{
     //Verifica la base datos
      final id = nuevoScant.id;
      final tipo = nuevoScant.tipo;
      final valor = nuevoScant.valor;
      final db = await database;
      final sql = '''
            insert into Scans (id, tipo, valor)
            values ($id,'$tipo','$valor')
          ''';
      final rs = await db.rawInsert(sql);
  }

  Future<int> nuevoScan( ScanModel nuevoScant ) async{

    final db = await database;
    final  res = await db.insert('Scans', nuevoScant.toJson());
    print(res);
    //Este es el último registro insertado
    return res;
  }
  
  Future <ScanModel?> getSanById (int id) async{
     final db =  await database;
     //final res = await db.query('Scans',where: 'id = ? and otracosa = ?', whereArgs: [id,otracosa]);
     final res = await db.query('Scans',where: 'id = ?', whereArgs: [id]);
     return res.isNotEmpty
         ? ScanModel.fromJson(res.first)
         : null;
  }

  Future<List<ScanModel>?> getAllScans () async{
    final db =  await database;
    final res = await db.query('Scans');
    return res.isNotEmpty
        ? res.map( (s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future<List<ScanModel>?> getAllScansPorTipo ( String tipo) async{
    final db =  await database;
    final sql = '''
                SELECT * FROM Scans WHERE tipo = '$tipo'
                ''';
    final res = await db.query(sql);
    return res.isNotEmpty
        ? res.map( (s) => ScanModel.fromJson(s)).toList()
        : [];
  }

  Future <int> updateScan(ScanModel nuevoScan) async{
      final db = await database;
      final res = await db.update('Scans', nuevoScan.toJson(),where: 'id = ?', whereArgs: [nuevoScan.id] );
      return res;
  }


  Future <int> deleteScan(int id) async{
    final db = await database;
    final res = await db.delete('Scans',where: 'id = ?', whereArgs: [id] );
    return res;
  }
  Future <int> DeleteAllScanUno() async{
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }

  Future <int> DeleteAllScanDos() async{
    final db = await database;
    final sql = '''
    delete from Scans
    ''';
    final res = await db.rawDelete(sql);
    return res;
  }

}

