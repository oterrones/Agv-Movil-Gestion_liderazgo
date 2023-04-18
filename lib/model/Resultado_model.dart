import 'dart:convert';

List<Resultado_Model> welcomeFromJson(String str) => List<Resultado_Model>.from(json.decode(str).map((x) => Resultado_Model.fromJson(x)));

String welcomeToJson(List<Resultado_Model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Resultado_Model {
  Resultado_Model({
    required this.fecha,
    required this.hora,
    required this.type_evaluacion,
    required this.dni_evaluador,
    required this.dni_trabajador,
    required this.nombres_trabajador,
    required this.dni_jefe,
    required this.nombres_jefe,
    required this.etapa,
    required this.campo,
    required this.escuela,
    required this.unidad,
    required this.name_categoria,
    required this.concepto,
    required this.tipo_concepto,
    required this.canal,
    required this.estado,
    required this.capacitacion,
    required this.observacion_seguimiento
  });

  String fecha;
  String hora;
  String type_evaluacion;
  String dni_evaluador;
  String dni_trabajador;
  String nombres_trabajador;
  String dni_jefe;
  String nombres_jefe;
  String etapa;
  String campo;
  String escuela;
  String unidad;
  String name_categoria;
  String concepto;
  String tipo_concepto;
  String canal;
  String estado;
  String capacitacion;
  String? observacion_seguimiento;


  factory Resultado_Model.fromJson(Map<String, dynamic> json) => Resultado_Model(
    fecha: json["fecha"],
    hora: json["hora"],
    type_evaluacion: json["type_evaluacion"],
    dni_evaluador: json["dni_evaluador"],
    dni_trabajador: json["dni_trabajador"],
    nombres_trabajador: json["nombres_trabajador"],
    dni_jefe: json["dni_jefe"],
    nombres_jefe: json["nombres_jefe"],
    etapa: json["etapa"],
    campo: json["campo"],
    escuela: json["escuela"],
    unidad: json["unidad"],
    name_categoria: json["name_categoria"],
    concepto: json["concepto"],
    tipo_concepto: json["tipo_concepto"],
    canal: json["canal"],
    estado: json["estado"],
    capacitacion: json["capacitacion"],
    observacion_seguimiento: json["observacion_seguimiento"],

  );

  Map<String, dynamic> toJson() => {
    "fecha": fecha,
    "hora": hora,
    "type_evaluacion": type_evaluacion,
    "dni_evaluador": dni_evaluador,
    "dni_trabajador": dni_trabajador,
    "nombres_trabajador": nombres_trabajador,
    "dni_jefe": dni_jefe,
    "nombres_jefe": nombres_jefe,
    "etapa": etapa,
    "campo": campo,
    "escuela": escuela,
    "unidad": unidad,
    "name_categoria": name_categoria,
    "concepto": concepto,
    "tipo_concepto": tipo_concepto,
    "canal":canal,
    "estado":estado,
    "capacitacion":capacitacion,
    "observacion_seguimiento":observacion_seguimiento
  };
}
