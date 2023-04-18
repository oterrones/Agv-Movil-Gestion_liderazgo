import 'dart:convert';

List<RespuestaInserTrabajador_model> welcomeFromJson(String str) => List<RespuestaInserTrabajador_model>.from(json.decode(str).map((x) => RespuestaInserTrabajador_model.fromJson(x)));

String welcomeToJson(List<RespuestaInserTrabajador_model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RespuestaInserTrabajador_model {
  RespuestaInserTrabajador_model({
    required this.resultado,
    required this.row,
    required this.state,
  });

  String resultado;
  int row;
  bool state;

  factory RespuestaInserTrabajador_model.fromJson(Map<String, dynamic> json) => RespuestaInserTrabajador_model(
    resultado: json["resultado"],
    row: json["row"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "resultado": resultado,
    "row": row,
    "state": state,
  };
}
