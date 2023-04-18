import 'dart:convert';

List<DetalleResultado_Model> welcomeFromJson(String str) => List<DetalleResultado_Model>.from(json.decode(str).map((x) => DetalleResultado_Model.fromJson(x)));

String welcomeToJson(List<DetalleResultado_Model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetalleResultado_Model {
  DetalleResultado_Model({
    required this.id_pregunta,
    required this.idresultado,
    required this.respuesta
  });

  String id_pregunta;
  String idresultado;
  String respuesta;

  factory DetalleResultado_Model.fromJson(Map<String, dynamic> json) => DetalleResultado_Model(
    id_pregunta: json["id_pregunta"],
    idresultado: json["idresultado"],
    respuesta: json["respuesta"],
  );

  Map<String, dynamic> toJson() => {
    "id_pregunta": id_pregunta,
    "idresultado": idresultado,
    "respuesta": respuesta,
  };
}
