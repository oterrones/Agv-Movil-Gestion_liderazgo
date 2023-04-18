import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rrhh/model/Album.dart';
import 'package:rrhh/model/Category_model.dart';
import 'package:rrhh/model/Evaluador_model.dart';
import 'package:rrhh/model/RespuestaInserTrabajador.dart';
import 'package:rrhh/model/ResultApi.dart';
import 'package:rrhh/model/DetalleResultado_model.dart';
import 'package:rrhh/model/ResultadoTrabajadorAWS_model.dart';
import 'package:rrhh/model/Resultado_model.dart';
import 'package:rrhh/model/ResultA.dart';
import 'package:rrhh/model/ScanModel.dart';
import 'package:rrhh/model/TrabajadorListSap.dart';
import 'package:rrhh/model/TrabajadorList_model.dart';
import 'package:rrhh/model/TrabajadorMovil_model.dart';
import 'package:rrhh/model/Trabajador_model.dart';
//import 'package:rrhh/model/ScanModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

class DBProvider {

  static Database? _database;

  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future <Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future <Database> initDB() async {
    //PACH DE DONDE SE ALMACENARA LA BASE DATOS
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'LiderazgoRRHH00_V6.db');
    print(path);
    return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          String sql_tbl1 = '''
               Create table liderazgo_evaluador
               (
                  idevaluador INTEGER PRIMARY  KEY,
                  dni varchar (8) not null,
                  nombres text not null
               );
               ''';
          String sql_tbl2 = '''
               Create table liderazgo_trabajador
               (
                  idtrabajador INTEGER PRIMARY  KEY,
                  dni varchar (8) not null,
                  nombres text not null,
                  area text,
                  puesto text,
                  telefono text
               );       
               ''';
          String sql_tbl3 = '''
               Create table liderazgo_preguntas (
                  idpregunta INTEGER PRIMARY  KEY,
                  nombre TEXT
               );
			        ''';
          String sql_tbl4 = '''              
               create table liderazgo_category(
                       id INTEGER PRIMARY  KEY,
                        nombre_category text	
               );
               ''';

          String sql_tbl5 = '''
                Create table liderazgo_resultado 
                (
                  idresultado INTEGER PRIMARY  KEY AutoIncrement,
                  fecha date,
                  hora time,          
                  type_evaluacion varchar (15) not null,
                  dni_evaluador varchar (8) not null	,
                  dni_trabajador varchar (10),
                  nombres_trabajador text,
                  dni_jefe varchar (10),
                  nombres_jefe text,
                  etapa text,
                  campo text,
                  escuela text,
                  unidad text,
                  name_categoria text,
                  concepto text,
                  tipo_concepto text,
                  canal text,
                  accion char(1) not null  default '0',
                  capacitacion char(1) not null  default '0', -- (0):NOTA TRABAJADOR ,(3): NOTA INICIAL EVALUADOR, (4): NOTA FINAL EVALUADOR, (5): ENCUESTA DE SATISFACCION
                  estado varchar (1) not null, -- (1): ACTIVO, (2): SINCRONIZADO
                  observacion_seguimiento text
               );			   
               ''';
          String sql_tbl6 = '''              
                create table liderazgo_detalle_resultado(
                  iddetalleresultado INTEGER PRIMARY  KEY AutoIncrement,
                  id_pregunta integer not null,
                  idresultado integer references liderazgo_resultado(idresultado),
                  respuesta integer not null				
			          );		
               
               ''';

          String sql_tbl7 = '''              
                create table liderazgo_detalle_resultado_accion(
                  iddetalleresultado INTEGER PRIMARY  KEY AutoIncrement,
                  id_pregunta integer not null,
                  idresultado integer references liderazgo_resultado(idresultado),
                  respuesta integer not null,
                  concepto text,
                  tipo_concepto text,
                  fecha date,
                  hora time
			          );		               
               ''';

          String sql_tbl8 = '''              
               create table liderazgo_sesion(
                       id_sesion INTEGER PRIMARY  KEY,
                        idusuario varchar (10),
                        nombres text,
                        dni_sesion varchar (10) not null				
               );
               ''';

          String sql_tbl9 = '''              
                create table liderazgo_detalle_resultado_capacitacion(
                  iddetalleresultadocapacitacion INTEGER PRIMARY  KEY AutoIncrement,
                  id_pregunta integer not null,
                  idresultado integer references liderazgo_resultado(idresultado),
                  respuesta integer not null,
                  evaluacion_satisfaccion text,
                  observacion text,
                  concepto text,
                  tipo_concepto text,
                  fecha date,
                  hora time
			          );		               
               ''';

          List<String> consultas = [
            sql_tbl1,
            sql_tbl2,
            sql_tbl3,
            sql_tbl4,
            sql_tbl5,
            sql_tbl6,
            sql_tbl7,
            sql_tbl8,
            sql_tbl9
          ];

          for (var sql in consultas) {
            await db.execute(sql);
          }
          //await db.execute(sql);
        }
    );
  }

  Future<int> createTrabajdorSap(int idtrabajdor, String? dni,String? nombres,String? area,String? puesto,String? telefono) async {
    final db = await database;

    final data = {'idtrabajador': idtrabajdor, 'dni': dni,'nombres':nombres,'area':area,'puesto':puesto,'telefono':telefono};
    final id = await db.insert('liderazgo_trabajador', data);
    return id;
  }

  Future<int> nuevoResultado(Resultado_Model nuevoResultado) async {
    final db = await database;
    final res = await db.insert('liderazgo_resultado', nuevoResultado.toJson());
    print(res);
    return res;
  }

  Future<int> nuevoDetalleResultado(
      DetalleResultado_Model nuevoDetalleResultado) async {
    final db = await database;
    final res = await db.insert(
        'liderazgo_detalle_resultado', nuevoDetalleResultado.toJson());
    return res;
  }

  Future<int> setDataTrabajadorSap(
      TrabajadorMovil1 objTrabajadorMovil1) async {
    final db = await database;
    final res = await db.insert(
        'liderazgo_trabajador', objTrabajadorMovil1.toJson());
    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScant) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScant.toJson());
    print(res);
    //Este es el último registro insertado
    return res;
  }

  Future<List<Trabajador_model>?> getTrabajador(String dni) async {
    final db = await database;
    final sql = '''
                SELECT * FROM liderazgo_trabajador WHERE dni = '$dni'
                ''';
    final res = await db.query(sql);
    return res.isNotEmpty
        ? res.map((s) => Trabajador_model.fromJson(s)).toList()
        : [];
  }



  Future <Trabajador_model?> getTrabajadorById(String dni) async {
    final db = await database;

    final dni_text = '$dni';
    //final res = await db.query('Scans',where: 'id = ? and otracosa = ?', whereArgs: [id,otracosa]);
    // final res = await db.query(" select nombres from liderazgo_trabajador where dni = '47557590' limit 1");
    final res = await db.query(
        'liderazgo_trabajador', where: 'dni = ? ', whereArgs: [dni_text]);

    print(res);
    return res.isNotEmpty
        ? Trabajador_model.fromJson(res.first)
        : null;
  }

  Future <ScanModel?> getSanById(int id) async {
    final db = await database;
    //final res = await db.query('Scans',where: 'id = ? and otracosa = ?', whereArgs: [id,otracosa]);
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty
        ? ScanModel.fromJson(res.first)
        : null;
  }


  Future<Album> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  Future<TrabajadorList> fetchTrabaj() async {
    final response = await http
        .get(Uri.parse(
        'http://etl.agvperu.com/etl_firmPro/getFirmproDataCalidadTest'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TrabajadorList.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<AppDataSap> GetAppDataTrabajador() async {
    final response = await http
        .get(Uri.parse(
        'https://etlagro.agvperu.com/backend_etl/api/getPersonalMovil/?estado=A&dni=T'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final registros = AppDataSap.fromJson(jsonDecode(response.body));

      var test = "";
      print(registros.trabajador_movil.length);
      registros.trabajador_movil.forEach(
              (element) =>
                  test = (element.nombres.toString()) ,
      );
      print ("Tes: "+test);
      //   DBProvider.db.createTrabajadoresSap(TrabajadorMovil.fromJson(registros.trabajador_sap));
      return registros;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<String> GetAppDataTrabajador_insertMovil() async {

    var response_status="ok";
    try {

      //INICIA OK
      var response;
      int valorRetornook = 0;
      response = await http
          .get(Uri.parse(
          'https://etlagro.agvperu.com/backend_etl/api/getPersonalMovil/?estado=A&dni=T'));

      var tamanioLectura = 0;

      int ultimoInsercion = 0;
      print ("Status Lectura: "+(response.statusCode).toString());
      if (response.statusCode == 200) {
        response_status="ok";
        valorRetornook = 1;
        final eliminados = this.deleteAllTrabajadores();

        print("Eliminados Local: "+eliminados.toString());
        print(jsonDecode(response.body));
        final registros = AppDataSap.fromJson(jsonDecode(response.body));
        print(registros);

        tamanioLectura = registros.trabajador_movil.length;
        print("Total Registros: "+tamanioLectura.toString());

        for(var i = 0;i < tamanioLectura; i++){
          await createTrabajdorSap((i+1), registros.trabajador_movil[i].dni,registros.trabajador_movil[i].nombres,registros.trabajador_movil[i].area,registros.trabajador_movil[i].puesto,registros.trabajador_movil[i].telefono);
          ultimoInsercion = (i+1);
        }

        print("Ultimo Registro: "+ultimoInsercion.toString());
        /*
      if(ultimoInsercion == tamanioLectura){
        valorRetorno = 1; // SINCRONIZACIÓN EXITOSA
      }else if(ultimoInsercion < tamanioLectura){
        valorRetorno = 2; // SINCRONIZACIÓN MENOR A LO LEIDO
      }else{
        valorRetorno = 3;
      }*/

      } else {
        throw Exception('Error al leer los datos del servidor');
      }
      //FIN OK

    } on SocketException {
      response_status = "No Internet connection";
    } on HttpException {
      response_status = "Couldn't find the post";
    } on FormatException {
      response_status = "Bad response format";
    }

    return response_status;
  }

  createTrabajadoresSap(TrabajadorMovil1 newTrabajador) async {
    await deleteAllTrabajadores();
    final db = await database;
    // final batch = db.batch();
    // batch.insert('liderazgo_trabajador', newTrabajador.toJson());
    // final res = await batch.commit();
    final res = await db.insert('liderazgo_trabajador', newTrabajador.toJson());
    //await db.close();

    return res;
  }

  // Delete all trabajadores
  Future<int> deleteAllTrabajadores() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM liderazgo_trabajador');
    return res;
  }


  Future<int> insertByHelper(String tableName,
      Map<String, Object> paramters) async {
      final db = await database;
      return await db.insert(tableName, paramters);
  }

  Future<Batch> getBatch() async {
    final db = await database;

    return db.batch();
  }

  void insertData() async {
    final db = await database;
    Map<String, Object> par = Map<String, Object>();

    par['uid'] = 2;
    par['fuid'] = 2;
    par['type'] = 2;

    int flag = await insertByHelper('relation', par);
    //int flag = await dbUtil.insert('INSERT INTO relation(uid, fuid, type) VALUES("111111", "2222222", 1)');
    print('flag:$flag');
    //await db.close();
  }

  Future<List<Trabajador_model>?> getAllTrabajadores() async {
    final db = await database;
    final sql = '''
                SELECT * FROM liderazgo_trabajador 
                ''';
    final res = await db.query('liderazgo_trabajador');
    //  final res = await db.query(sql);
    return res.isNotEmpty
        ? res.map((s) => Trabajador_model.fromJson(s)).toList()
        : [];
  }

  Future<List<ResultadoTrabajadorAWS_model>?> getAllResultadoTrabajadorPackingMovil() async {
    final db = await database;
    final sql = '''
                select  
                    distinct 
                      dres.idresultado,
                      id_pregunta,		
                      respuesta,
                      fecha,
                      hora, 
                      type_evaluacion,	
                      dni_trabajador,
                      nombres_trabajador,
                      area,
                      puesto,
                      telefono,
                      estado,
                      eval.idevaluador as idevaluador,
                      dni_evaluador,
                      eval.nombres as nombres_evaluador,
                      name_categoria,
                      dni_jefe,
                      nombres_jefe,
                      campo,
                      etapa,
                      escuela,
                      unidad,
                      concepto,
                      tipo_concepto,
                      canal,
                      '' as evaluacion_satisfaccion,
                      '' as observacion,
                      '' as observacion_seguimiento
                      
                 from liderazgo_detalle_resultado dres
                 inner join liderazgo_resultado res on (dres.idresultado = res.idresultado)
                 inner join liderazgo_trabajador trab on (trim(res.dni_trabajador) = trim(trab.dni)) 
				         inner join liderazgo_evaluador eval on (trim(res.dni_evaluador) = trim(eval.dni)) 				 
                 where estado = '1' and type_evaluacion = 'PACKING' and capacitacion = '5'
				 
				        UNION ALL 
				 
				        select  
                    distinct 
                      dres.idresultado,
                      id_pregunta,		
                      respuesta,
                      res.fecha,
                      res.hora, 
                      type_evaluacion,	
                      dni_trabajador,
                      nombres_trabajador,
                      area,
                      puesto,
                      telefono,
                      estado,
                      eval.idevaluador as idevaluador,
                      dni_evaluador,
                      eval.nombres as nombres_evaluador,
                      name_categoria,
                      dni_jefe,
                      nombres_jefe,
                      campo,
                      etapa,
                      escuela,
                      unidad,
                      res.concepto,
                      dres.tipo_concepto,
                      canal,
                      evaluacion_satisfaccion,
                      observacion,
                      observacion_seguimiento
                      
                 from liderazgo_detalle_resultado_capacitacion dres
                 inner join liderazgo_resultado res on (dres.idresultado = res.idresultado)
                 inner join liderazgo_trabajador trab on (trim(res.dni_trabajador) = trim(trab.dni)) 
				         inner join liderazgo_evaluador eval on (trim(res.dni_evaluador) = trim(eval.dni)) 				 
                 where estado = '1' and type_evaluacion = 'PACKING' and capacitacion = '5'
                 
                ''';
    final res = await db.rawQuery(sql);
    return res.isNotEmpty
        ? res.map((s) => ResultadoTrabajadorAWS_model.fromJson(s)).toList()
        : [];
  }
  Future<List<ResultadoTrabajadorAWS_model>?> getAllResultadoTrabajadorPackingMovil_Accion() async {
    final db = await database;
    final sql = '''
                select  
                    distinct 
                      dres.idresultado,
                      id_pregunta,		
                      respuesta,
                      dres.fecha,
                      dres.hora, 
                      type_evaluacion,	
                      dni_trabajador,
                      nombres_trabajador,
                      area,
                      puesto,
                      telefono,
                      estado,
                      eval.idevaluador as idevaluador,
                      dni_evaluador,
                      eval.nombres as nombres_evaluador,
                      res.tipo_concepto as name_categoria,
                      dni_jefe,
                      nombres_jefe,
                      campo,
                      etapa,
                      escuela,
                      unidad,
                      dres.concepto,
                      dres.tipo_concepto,
                      canal,
                       '' as evaluacion_satisfaccion,
                       '' as observacion
                      
                 from liderazgo_detalle_resultado_accion dres
                 inner join liderazgo_resultado res on (dres.idresultado = res.idresultado)
                 inner join liderazgo_trabajador trab on (trim(res.dni_trabajador) = trim(trab.dni)) 
				         inner join liderazgo_evaluador eval on (trim(res.dni_evaluador) = trim(eval.dni)) 				 
                 where accion = '1' and type_evaluacion = 'PACKING'
                 
                ''';
    final res = await db.rawQuery(sql);
    return res.isNotEmpty
        ? res.map((s) => ResultadoTrabajadorAWS_model.fromJson(s)).toList()
        : [];
  }

  Future<List<ResultadoTrabajadorAWS_model>?> getAllResultadoTrabajadorCampoMovil() async {
    final db = await database;
    final sql = '''
               select  
                    distinct 
                      dres.idresultado,
                      id_pregunta,		
                      respuesta,
                      fecha,
                      hora, 
                      type_evaluacion,	
                      dni_trabajador,
                      nombres_trabajador,
                      area,
                      puesto,
                      telefono,
                      estado,
                      eval.idevaluador as idevaluador,
                      dni_evaluador,
                      eval.nombres as nombres_evaluador,
                      name_categoria,
                      dni_jefe,
                      nombres_jefe,
                      campo,
                      etapa,
                      escuela,
                      unidad,
                      concepto,
                      tipo_concepto,
                      canal,
                      '' as evaluacion_satisfaccion,
                      '' as observacion,
                      observacion_seguimiento
                      
                 from liderazgo_detalle_resultado dres
                 inner join liderazgo_resultado res on (dres.idresultado = res.idresultado)
                 inner join liderazgo_trabajador trab on (trim(res.dni_trabajador) = trim(trab.dni)) 
				         inner join liderazgo_evaluador eval on (trim(res.dni_evaluador) = trim(eval.dni)) 				 
                 where estado = '1' and type_evaluacion = 'CAMPO' and capacitacion = '5'
				 
				        UNION ALL 
				 
				        select  
                    distinct 
                      dres.idresultado,
                      id_pregunta,		
                      respuesta,
                      res.fecha,
                      res.hora, 
                      type_evaluacion,	
                      dni_trabajador,
                      nombres_trabajador,
                      area,
                      puesto,
                      telefono,
                      estado,
                      eval.idevaluador as idevaluador,
                      dni_evaluador,
                      eval.nombres as nombres_evaluador,
                      name_categoria,
                      dni_jefe,
                      nombres_jefe,
                      campo,
                      etapa,
                      escuela,
                      unidad,
                      res.concepto,
                      dres.tipo_concepto,
                      canal,
                      evaluacion_satisfaccion,
                      observacion,
                      observacion_seguimiento
                      
                 from liderazgo_detalle_resultado_capacitacion dres
                 inner join liderazgo_resultado res on (dres.idresultado = res.idresultado)
                 inner join liderazgo_trabajador trab on (trim(res.dni_trabajador) = trim(trab.dni)) 
				         inner join liderazgo_evaluador eval on (trim(res.dni_evaluador) = trim(eval.dni)) 				 
                 where estado = '1' and type_evaluacion = 'CAMPO' and capacitacion = '5'  
                ''';
    final res = await db.rawQuery(sql);
    return res.isNotEmpty
        ? res.map((s) => ResultadoTrabajadorAWS_model.fromJson(s)).toList()
        : [];
  }

  Future<List<ResultadoTrabajadorAWS_model>?> getAllResultadoTrabajadorCampoMovil_Accion() async {
    final db = await database;
    final sql = '''
                select  
                    distinct 
                      dres.idresultado,
                      id_pregunta,		
                      respuesta,
                      dres.fecha,
                      dres.hora, 
                      type_evaluacion,	
                      dni_trabajador,
                      nombres_trabajador,
                      area,
                      puesto,
                      telefono,
                      estado,
                      eval.idevaluador as idevaluador,
                      dni_evaluador,
                      eval.nombres as nombres_evaluador,
                      res.tipo_concepto as name_categoria,
                      dni_jefe,
                      nombres_jefe,
                      campo,
                      etapa,
                      escuela,
                      unidad,
                      dres.concepto,
                      dres.tipo_concepto,
                      canal,
                      '' as evaluacion_satisfaccion,
                      '' as observacion
                      
                 from liderazgo_detalle_resultado_accion dres
                 inner join liderazgo_resultado res on (dres.idresultado = res.idresultado)
                 inner join liderazgo_trabajador trab on (trim(res.dni_trabajador) = trim(trab.dni)) 
				         inner join liderazgo_evaluador eval on (trim(res.dni_evaluador) = trim(eval.dni)) 				 
                 where accion = '1' and type_evaluacion = 'CAMPO'
                 
                ''';
    final res = await db.rawQuery(sql);
    return res.isNotEmpty
        ? res.map((s) => ResultadoTrabajadorAWS_model.fromJson(s)).toList()
        : [];
  }

  Future<RespuestaInserTrabajador_model> enviarRegistrosLiderazgo () async{

    final resultado = await DBProvider.db.getAllTrabajadores();
   // List <Trabajador_model> trabajador = [];
    //trabajador = [...?resultado];
    String jsonTrabajadores = jsonEncode(resultado);

    Map datos  = {"datos":jsonTrabajadores};

    String url =  "http://etl.agvperu.com/LiderazgoCampoPacking/registrarEvaluacionCampoPacking";

    final respuesta = await http.post(Uri.parse(url),body: datos);

    print ("Página: "+(respuesta.statusCode).toString());
    if (respuesta.statusCode == 200) {

      final response = RespuestaInserTrabajador_model.fromJson(jsonDecode(respuesta.body));
      return response;

    } else {
      throw Exception('Failed to load album');
    }

  }

  Future <List<Map<String, dynamic>>>  enviarDataLiderazgoPackingAWS () async{

    List<Map<String, dynamic>> _respuestasInsert = [];

    try {
    //inicia ok
    final resultado = await DBProvider.db.getAllResultadoTrabajadorPackingMovil();

    String jsonTrabajadores = jsonEncode(resultado);

    Map datos  = {"datos":jsonTrabajadores};

    String url =  "http://etl.agvperu.com/LiderazgoCampoPacking/registrarDetalleEvaluacionCampoPacking_v6";

    final respuesta = await http.post(Uri.parse(url),body: datos);

    print ("Página: "+(respuesta.statusCode).toString());
    if (respuesta.statusCode == 200) {
      final response = RespuestaInserTrabajador_model.fromJson(jsonDecode(respuesta.body));
      print(response.resultado);

      Map<String, dynamic> _map_respuesta = {
        "resultado": response.resultado,
        "state": response.state,
        "state": response.state
      };
      _respuestasInsert.add(_map_respuesta);

      AllUpdateResultadoActivoPacking();
      return _respuestasInsert;

    } else {
      throw Exception('Failed to load album');
    }
    //fin ok
    } on SocketException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "No Internet connection"
      };
      _respuestasInsert.add(_map_respuesta);
    } on HttpException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "Couldn't find the post"
      };
      _respuestasInsert.add(_map_respuesta);
    } on FormatException {
      Map<String, dynamic> _map_respuesta = {
      "resultado":  "Bad response format"
    };
    _respuestasInsert.add(_map_respuesta);
  }
    return _respuestasInsert;

  }
  Future <List<Map<String, dynamic>>>  enviarDataLiderazgoPackingAWS_Accion () async{

    List<Map<String, dynamic>> _respuestasInsert = [];

    try {
      //inicia ok
      final resultado = await DBProvider.db.getAllResultadoTrabajadorPackingMovil_Accion();

      String jsonTrabajadores = jsonEncode(resultado);

      Map datos  = {"datos":jsonTrabajadores};

      String url =  "http://etl.agvperu.com/LiderazgoCampoPacking/registrarDetalleEvaluacionCampoPacking";

      final respuesta = await http.post(Uri.parse(url),body: datos);

      print ("Página: "+(respuesta.statusCode).toString());
      if (respuesta.statusCode == 200) {
        final response = RespuestaInserTrabajador_model.fromJson(jsonDecode(respuesta.body));
        print(response.resultado);

        Map<String, dynamic> _map_respuesta = {
          "resultado": response.resultado,
          "state": response.state,
          "state": response.state
        };
        _respuestasInsert.add(_map_respuesta);

        AllUpdateResultadoActivoPacking_Accion();
        return _respuestasInsert;

      } else {
        throw Exception('Failed to load album');
      }
      //fin ok
    } on SocketException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "No Internet connection"
      };
      _respuestasInsert.add(_map_respuesta);
    } on HttpException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "Couldn't find the post"
      };
      _respuestasInsert.add(_map_respuesta);
    } on FormatException {
      Map<String, dynamic> _map_respuesta = {
        "resultado":  "Bad response format"
      };
      _respuestasInsert.add(_map_respuesta);
    }
    return _respuestasInsert;

  }

  Future <List<Map<String, dynamic>>>  enviarDataLiderazgoCampoAWS () async{

    List<Map<String, dynamic>> _respuestasInsert = [];
    try {
    //inicia ok

    final resultado = await DBProvider.db.getAllResultadoTrabajadorCampoMovil();

    String jsonTrabajadores = jsonEncode(resultado);
    print(jsonTrabajadores);


    Map datos  = {"datos":jsonTrabajadores};

    String url =  "http://etl.agvperu.com/LiderazgoCampoPacking/registrarDetalleEvaluacionCampoPacking_v6";

    final respuesta = await http.post(Uri.parse(url),body: datos);

    print ("Página: "+(respuesta.body).toString());
    if (respuesta.statusCode == 200) {
      final response = RespuestaInserTrabajador_model.fromJson(jsonDecode(respuesta.body));
      print(response.resultado);

      Map<String, dynamic> _map_respuesta = {
        "resultado": response.resultado,
        "state": response.state,
        "state": response.state
      };
      _respuestasInsert.add(_map_respuesta);

      AllUpdateResultadoActivoCampo();

    } else {
      throw Exception('Failed to load album');
    }
    //fin ok

    } on SocketException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "No Internet connection"
      };
      _respuestasInsert.add(_map_respuesta);
    } on HttpException {
      Map<String, dynamic> _map_respuesta = {
      "resultado": "Couldn't find the post"
      };
      _respuestasInsert.add(_map_respuesta);
    } on FormatException {
        Map<String, dynamic> _map_respuesta = {
        "resultado":  "Bad response format"
      };
      _respuestasInsert.add(_map_respuesta);
    }
    return _respuestasInsert;

  }
  Future <List<Map<String, dynamic>>>  enviarDataLiderazgoCampoAWS_Accion () async{

    List<Map<String, dynamic>> _respuestasInsert = [];

    try {
      //inicia ok
      final resultado = await DBProvider.db.getAllResultadoTrabajadorCampoMovil_Accion();

      String jsonTrabajadores = jsonEncode(resultado);

      Map datos  = {"datos":jsonTrabajadores};

      String url =  "http://etl.agvperu.com/LiderazgoCampoPacking/registrarDetalleEvaluacionCampoPacking";

      final respuesta = await http.post(Uri.parse(url),body: datos);

      print ("Página: "+(respuesta.statusCode).toString());
      if (respuesta.statusCode == 200) {
        final response = RespuestaInserTrabajador_model.fromJson(jsonDecode(respuesta.body));
        print(response.resultado);

        Map<String, dynamic> _map_respuesta = {
          "resultado": response.resultado,
          "state": response.state,
          "state": response.state
        };
        _respuestasInsert.add(_map_respuesta);

        AllUpdateResultadoActivoCampo_Accion();
        return _respuestasInsert;

      } else {
        throw Exception('Failed to load album');
      }
      //fin ok
    } on SocketException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "No Internet connection"
      };
      _respuestasInsert.add(_map_respuesta);
    } on HttpException {
      Map<String, dynamic> _map_respuesta = {
        "resultado": "Couldn't find the post"
      };
      _respuestasInsert.add(_map_respuesta);
    } on FormatException {
      Map<String, dynamic> _map_respuesta = {
        "resultado":  "Bad response format"
      };
      _respuestasInsert.add(_map_respuesta);
    }
    return _respuestasInsert;

  }

  Future<List<Map<String, dynamic>>> getAllResultadosPacking() async {
    final db = await database;
   // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    String Sql = '''
          SELECT  idresultado,nombres_trabajador  as nombres ,fecha,hora,concepto,tipo_concepto,accion,capacitacion
          FROM liderazgo_resultado lre         
          where type_evaluacion = 'PACKING' and estado = '1'
          order by fecha desc, hora desc
    ''';
    final resultado = await db.rawQuery(Sql);
    return resultado;
   // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getAllResultadosPacking_validar_existencia() async {
    final db = await database;
    // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    String Sql = '''
          SELECT  idresultado,fecha,hora
          FROM liderazgo_resultado 
          where type_evaluacion = 'PACKING' and estado = '1' AND  capacitacion = '5' 
          limit 1
    ''';
    final resultado = await db.rawQuery(Sql);
    return resultado;
    // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getAllResultadosCampo_validar_existencia() async {
    final db = await database;
    // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    String Sql = '''
          SELECT  idresultado,fecha,hora
          FROM liderazgo_resultado 
          where type_evaluacion = 'CAMPO' and estado = '1' AND  capacitacion = '5' 
          limit 1
    ''';
    final resultado = await db.rawQuery(Sql);
    return resultado;
    // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getAllResultadosCampo_() async {
    final db = await database;
    // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    /*String Sql = '''
          SELECT  idresultado,nombres,fecha,hora,concepto,tipo_concepto,accion,capacitacion
          FROM liderazgo_resultado lre
          inner join liderazgo_trabajador ltr on ( trim(lre.dni_trabajador) = trim(ltr.dni))
          where type_evaluacion = 'CAMPO' and estado = '1'  
          order by fecha desc, hora desc
    ''';*/
    String Sql = '''
          SELECT  idresultado,nombres_trabajador as nombres,fecha,hora,concepto,tipo_concepto,accion,capacitacion
          FROM liderazgo_resultado lre          
          where type_evaluacion = 'CAMPO' and estado = '1'  
          order by fecha desc, hora desc
    ''';
    final resultado = await db.rawQuery(Sql);
    return resultado;
    // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getAllResultadosPackingAccion() async {
    final db = await database;
    // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    String Sql = '''
          SELECT  idresultado,nombres,fecha,hora,concepto,tipo_concepto,accion
          FROM liderazgo_resultado lre
          inner join liderazgo_trabajador ltr on ( trim(lre.dni_trabajador) = trim(ltr.dni))
          where type_evaluacion = 'PACKING' and accion in ('1','0','3') and UPPER(TRIM(tipo_concepto))  IN ('SEGUIMIENTO III','SEGUIMIENTO I','INTELIGENCIA EMOCIONAL CAPACITACIÓN 5') 
          order by fecha desc, hora desc
    ''';

    final resultado = await db.rawQuery(Sql);
    return resultado;
    // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getAllResultadosCampoAccion() async {
    final db = await database;
    // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    String Sql = '''
          SELECT  idresultado,nombres,fecha,hora,concepto,tipo_concepto,accion
          FROM liderazgo_resultado lre
          inner join liderazgo_trabajador ltr on ( trim(lre.dni_trabajador) = trim(ltr.dni))
          where type_evaluacion = 'CAMPO' and accion in ('1','0','3') and  UPPER(TRIM(tipo_concepto))  IN ('SEGUIMIENTO III','SEGUIMIENTO I','INTELIGENCIA EMOCIONAL CAPACITACIÓN 5')
          order by fecha desc, hora desc
    ''';
    final resultado = await db.rawQuery(Sql);
    return resultado;
    // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getAllResultadosCampo() async {
    final db = await database;
    // final resultado = await db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPriority ASC");
    String Sql = '''
          SELECT  idresultado,nombres,fecha,hora
          FROM liderazgo_resultado lre
          inner join liderazgo_trabajador ltr on ( trim(lre.dni_trabajador) = trim(ltr.dni))
          where type_evaluacion = 'CAMPO' and estado = '1'
          order by fecha desc, hora desc
    ''';
    final resultado = await db.rawQuery(Sql);
    return resultado;
    // return db.query('liderazgo_resultado', orderBy: "idresultado");
  }

  Future<List<Map<String, dynamic>>> getRespuestaPorId(int id) async {
    final db = await database;
    final resultado = await db.query(
        'liderazgo_detalle_resultado', where: 'idresultado = ? ', whereArgs: [id]);
    return resultado;
  }

  Future<int> updateRespuesta(
      int resultado, int pregunta, int respuesta) async {
    final db = await database;

    final data = {
      'respuesta': respuesta
    };

    final result =
    await db.update('liderazgo_detalle_resultado', data, where: "idresultado = ? and id_pregunta = ?", whereArgs: [resultado,pregunta]);
    return result;
  }
  Future<int> registrarRespuestaCapacitacion( int resultado, int pregunta,int respuesta,String concepto, String tipo_concepto, String  fecha,
      String hora ) async {
    final  data  = {'id_pregunta': pregunta, 'idresultado': resultado,'respuesta':respuesta,'concepto':concepto,'tipo_concepto':tipo_concepto,'fecha':fecha,'hora':hora};
    final db = await database;
    final id = await db.insert('liderazgo_detalle_resultado_capacitacion', data);
    return id;
  }

  Future<int> registrarRespuestaCapacitacionSatisfaccion( int resultado, int pregunta,int respuesta,String concepto, String tipo_concepto, String  fecha,
      String hora, String satisfaccion, String observacion ) async {
    final  data  = {
                    'id_pregunta': pregunta,
                    'idresultado': resultado,
                    'respuesta':respuesta,
                    'concepto':concepto,
                    'tipo_concepto':tipo_concepto,
                    'fecha':fecha,
                    'hora':hora,
                    'evaluacion_satisfaccion':satisfaccion,
                    'observacion':observacion
                  };
    final db = await database;
    final id = await db.insert('liderazgo_detalle_resultado_capacitacion', data);
    return id;
  }


  //TABLA ACCIÓN
  Future<int> registrarRespuestaAccion22( List listAccion) async {
    final  data  = {'id_pregunta': 1, 'idresultado': 1,'respuesta':2,'concepto':'concepto','tipo_concepto':'tip_concepto'};
    listAccion.add(data);
    //Map<String, Object> map = listAccion.asMap().cast<String, Object>();
    final  datass = jsonDecode(data.toString());
    //Map<String, Object> mapss = datass as Map<String, Object>;
    print(datass);
    final db = await database;
    final id = await db.insert('liderazgo_detalle_resultado_accion', datass);
    return 8;
  }

  Future<int> registrarRespuestaAccion( int pregunta,int resultado, int respuesta,String concepto, String tipo_concepto, String  fecha,
      String hora ) async {
    final  data  = {'id_pregunta': pregunta, 'idresultado': resultado,'respuesta':respuesta,'concepto':concepto,'tipo_concepto':tipo_concepto,'fecha':fecha,'hora':hora};
    final db = await database;
    final id = await db.insert('liderazgo_detalle_resultado_accion', data);
    return id;
  }

  Future<int> updateResultadoCapacitacion(
      int resultado, String capacitacion) async {

    print(resultado);
    print(capacitacion);
    final db = await database;

    final data = {
      'capacitacion': capacitacion
    };

    final result =
    await db.update('liderazgo_resultado', data, where: "idresultado = ? ", whereArgs: [resultado]);
    return result;
  }

  Future<int> updateResultadoAccion(
      int resultado, String accion) async {
    final db = await database;

    final data = {
      'accion': accion
    };

    final result =
    await db.update('liderazgo_resultado', data, where: "idresultado = ? ", whereArgs: [resultado]);
    return result;
  }

  //TABLA SESION

  Future<List<Map<String, dynamic>>> getSesion(String dni) async {
    final db = await database;
    String Sql = "Select * from liderazgo_evaluador where dni ='$dni'";
    final resultado = await db.rawQuery(Sql);
    return resultado;
  }

  Future<int> setSesion(int idsesion, String? idusuario,String? nombres) async {
    await deleteAllSesion();
    final db = await database;
    final data = {'id_sesion': idsesion, 'idusuario': idusuario,'nombres':nombres,'dni_sesion':idusuario};
    final id = await db.insert('liderazgo_sesion', data);
    return id;
  }

  Future<int> deleteAllSesion() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM liderazgo_sesion');
    return res;
  }

  Future<int> AllUpdateResultadoActivoCampo() async {
    final db = await database;
    final sql = "UPDATE liderazgo_resultado set estado = '2' where estado = '1' and type_evaluacion = 'CAMPO' and capacitacion = '5' ";
    final res = await db.rawUpdate(sql);
    return res;
  }
  Future<int> AllUpdateResultadoActivoPacking() async {
    final db = await database;
    final sql = "UPDATE liderazgo_resultado set estado = '2' where estado = '1' and type_evaluacion = 'PACKING' and capacitacion = '5' ";
    final res = await db.rawUpdate(sql);
    return res;
  }

  Future<int> AllUpdateResultadoActivoPacking_Accion() async {
    final db = await database;
    final sql = "UPDATE liderazgo_resultado set accion = '2' where accion = '1' and type_evaluacion = 'PACKING' ";
    final res = await db.rawUpdate(sql);
    return res;
  }

  Future<int> AllUpdateResultadoActivoCampo_Accion() async {
    final db = await database;
    final sql = "UPDATE liderazgo_resultado set accion = '2' where accion = '1' and type_evaluacion = 'CAMPO' ";
    final res = await db.rawUpdate(sql);
    return res;
  }

  Future<List<Map<String, dynamic>>>  getSesionLogeado() async {
    final db = await database;
    String Sql = "select * from liderazgo_sesion";
    final resultado = await db.rawQuery(Sql);
    return resultado;
  }

  Future<String> GetAppDataEvaluador_insertMovil() async {


    var response_status="ok";
    try {
      //INICA OK
      final response = await http
          .get(Uri.parse(
          'http://etl.agvperu.com/LiderazgoCampoPacking/getDataEvaluador'));

      var tamanioLectura = 0;
      int ultimoInsercion = 0;
      print ("Status Lectura: "+(response.statusCode).toString());
      if (response.statusCode == 200) {
        response_status="ok";
        final eliminados = this.DeleteAllEvaluador();
        print("Eliminados Local: "+eliminados.toString());
        final registros = AppDataEvaluador.fromJson(jsonDecode(response.body));
        tamanioLectura = registros.evaluador_list.length;
        print("Total Registros: "+tamanioLectura.toString());

        for(var i = 0;i < tamanioLectura; i++){
          await createEvaluador( registros.evaluador_list[i].idevaluador,registros.evaluador_list[i].dni,registros.evaluador_list[i].nombres);
          ultimoInsercion = (i+1);
        }
        print("Ultimo Registro: "+ultimoInsercion.toString());
      } else {
        throw Exception('Error al leer los datos del servidor');
      }
      // await db.close();
     // await GetAppDataCategory_insertMovil();
      //FIN OK
    } on SocketException {
      response_status = "No Internet connection";
    } on HttpException {
      response_status = "Couldn't find the post";
    } on FormatException {
      response_status = "Bad response format";
    }

    return response_status;

  }

  Future<int> GetAppDataCategory_insertMovil() async {

    final response = await http
        .get(Uri.parse(
        'http://etl.agvperu.com/LiderazgoCampoPacking/getDataCategory'));



    var tamanioLectura = 0;
    int valorRetorno = 0;
    int ultimoInsercion = 0;
    if (response.statusCode == 200) {
      final eliminados = this.DeleteAllCategory();
      final registros = AppDataCategory.fromJson(jsonDecode(response.body));
      tamanioLectura = registros.category_list.length;
      for(var i = 0;i < tamanioLectura; i++){
        await createCategory(registros.category_list[i].id,registros.category_list[i].nombre_category);
        ultimoInsercion = (i+1);
      }
    } else {
      valorRetorno = 4; //FALLO LECTURA
      throw Exception('Error al leer los datos del servidor');
    }
    // await db.close();
    return valorRetorno;
  }

  Future<int> createEvaluador(String? idtrabajdor, String? dni,String? nombres) async {
    final db = await database;
    final data = {'idevaluador': idtrabajdor, 'dni': dni,'nombres':nombres};
    final id = await db.insert('liderazgo_evaluador', data);
    return id;
  }

  Future<int> createCategory(String? idc,String? nombres) async {
    final db = await database;
    final data = {'id': idc, 'nombre_category':nombres};
    final id = await db.insert('liderazgo_category', data);
    return id;
  }

  Future<int> DeleteAllEvaluador() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM liderazgo_evaluador');
    return res;
  }

  Future<int> DeleteAllCategory() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM liderazgo_category');
    return res;
  }



}