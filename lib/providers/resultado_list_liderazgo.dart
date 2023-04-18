
import 'package:flutter/material.dart';
import 'package:rrhh/model/Resultado_model.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';

class ResultadoListLiderazgo  extends ChangeNotifier{
  List <Resultado_Model> resultado = [];
  String tipoSeleccionado = 'htpp';

  nuevoResultado (String fecha, String hora, String type_evaluacion,int id_trabajador,int id_evaluador, String estado,String dni_trabajdor,dni_evaluador) async{

    //final nuevoResultado = new Resultado_Model(fecha: fecha, hora: hora, type_evaluacion: type_evaluacion, id_trabajador: id_trabajador, id_evaluador: id_evaluador, estado: estado,dni_trabajador:dni_trabajdor,dni_evaluador:dni_evaluador );
    //final id = await DBProvider.db.nuevoResultado(nuevoResultado);
    //nuevoResultado.idresultado= id as String;

    //this.resultado.add(nuevoResultado);
    notifyListeners();
  }





}