
import 'dart:convert';

List<ResultadoTrabajadorAWS_model> welcomeFromJson(String str) => List<ResultadoTrabajadorAWS_model>.from(json.decode(str).map((x) => ResultadoTrabajadorAWS_model.fromJson(x)));

String welcomeToJson(List<ResultadoTrabajadorAWS_model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResultadoTrabajadorAWS_model {
  ResultadoTrabajadorAWS_model({
    required this.idresultado,
    required this.id_pregunta,
    required this.respuesta,
    required this.fecha,
    required this.hora,
    required this.type_evaluacion,
    required this.dni_trabajador,
    required this.nombres_trabajador,
    required this.area,
    required this.puesto,
    required this.telefono,
    required this.estado,
    required this.idevaluador,
    required this.dni_evaluador,
    required this.nombres_evaluador,
    required this.name_categoria,
    required this.dni_jefe,
    required this.nombres_jefe,
    required this.campo,
    required this.etapa,
    required this.escuela,
    required this.unidad,
    required this.concepto,
    required this.tipo_concepto,
    required this.canal,
    required this.evaluacion_satisfaccion,
    required this.observacion,
    required this.observacion_seguimiento,

  });

  int? idresultado;
  int? id_pregunta;
  int? respuesta;
  String? fecha;
  String? hora;
  String? type_evaluacion;
  String? dni_trabajador;
  String? nombres_trabajador;
  String? area;
  String? puesto;
  String? telefono;
  String? estado;
  int? idevaluador;
  String? dni_evaluador;
  String? nombres_evaluador;
  String? name_categoria;
  String? dni_jefe;
  String? nombres_jefe;
  String? campo;
  String? etapa;
  String? escuela;
  String? unidad;
  String? concepto;
  String? tipo_concepto;
  String? canal;
  String? evaluacion_satisfaccion;
  String? observacion;
  String? observacion_seguimiento;

  factory ResultadoTrabajadorAWS_model.fromJson(Map<String, dynamic> json) => ResultadoTrabajadorAWS_model(

      idresultado: json["idresultado"],
      id_pregunta: json["id_pregunta"],
      respuesta: json["respuesta"],
      fecha: json["fecha"],
      hora: json["hora"],
      type_evaluacion: json["type_evaluacion"],
      dni_trabajador: json["dni_trabajador"],
      nombres_trabajador: json["nombres_trabajador"],
      area: json["area"],
      puesto: json["puesto"],
      telefono: json["telefono"],
      estado: json["estado"],
      idevaluador: json["idevaluador"],
      dni_evaluador: json["dni_evaluador"],
      nombres_evaluador: json["nombres_evaluador"],
      name_categoria: json["name_categoria"],
      dni_jefe: json["dni_jefe"],
      nombres_jefe: json["nombres_jefe"],
      campo: json["campo"],
      etapa: json["etapa"],
      escuela: json["escuela"],
      unidad: json["unidad"],
      concepto: json["concepto"],
      tipo_concepto: json["tipo_concepto"],
      canal: json["canal"],
      evaluacion_satisfaccion: json["evaluacion_satisfaccion"],
      observacion: json["observacion"],
      observacion_seguimiento: json["observacion_seguimiento"]


  );

  Map<String, dynamic> toJson() => {
    "idresultado": idresultado,
    "id_pregunta": id_pregunta,
    "respuesta": respuesta,
    "fecha": fecha,
    "hora": hora,
    "type_evaluacion": type_evaluacion,
    "dni_trabajador": dni_trabajador,
    "nombres_trabajador": nombres_trabajador,
    "area": area,
    "puesto": puesto,
    "telefono": telefono,
    "estado": estado,
    "idevaluador": idevaluador,
    "dni_evaluador":dni_evaluador,
    "nombres_evaluador":nombres_evaluador,
    "name_categoria":name_categoria,
    "dni_jefe":dni_jefe,
    "nombres_jefe":nombres_jefe,
    "campo":campo,
    "etapa":etapa,
    "escuela":escuela,
    "unidad":unidad,
    "concepto":concepto,
    "tipo_concepto":tipo_concepto,
    "canal":canal,
    "evaluacion_satisfaccion":evaluacion_satisfaccion,
    "observacion":observacion,
    "observacion_seguimiento":observacion_seguimiento
  };
}
