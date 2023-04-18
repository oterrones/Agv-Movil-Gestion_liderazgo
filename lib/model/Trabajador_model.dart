import 'dart:convert';

List<Trabajador_model> welcomeFromJson(String str) => List<Trabajador_model>.from(json.decode(str).map((x) => Trabajador_model.fromJson(x)));

String welcomeToJson(List<Trabajador_model> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trabajador_model {
  Trabajador_model({
    required this.idtrabajador,
    required this.dni,
    required this.nombres,
    required this.area,
    required this.puesto,
  });

  int? idtrabajador;
  String? dni;
  String? nombres;
  String? area;
  String? puesto;

  factory Trabajador_model.fromJson(Map<String, dynamic> json) => Trabajador_model(
    idtrabajador: json["idtrabajador"],
    dni: json["dni"],
    nombres: json["nombres"],
    area: json["area"],
    puesto: json["puesto"],
  );

  Map<String, dynamic> toJson() => {
    "idtrabajador": idtrabajador,
    "dni": dni,
    "nombres": nombres,
    "area": area,
    "puesto": puesto,
  };
}
