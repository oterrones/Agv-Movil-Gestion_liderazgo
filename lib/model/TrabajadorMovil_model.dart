import 'dart:convert';

import 'dart:convert';

List<TrabajadorMovil1> welcomeFromJson(String str) => List<TrabajadorMovil1>.from(json.decode(str).map((x) => TrabajadorMovil1.fromJson(x)));

String welcomeToJson(List<TrabajadorMovil1> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TrabajadorMovil1 {
  String? idtrabajador;
  String? dni;
  String? nombres;
  String? area;
  String? puesto;
  String? telefono;


  TrabajadorMovil1({
    required this.idtrabajador,
    required this.dni,
    required this.nombres,
    required this.area,
    required this.puesto,
    required this.telefono,
  });

  factory TrabajadorMovil1.fromJson(Map<String, dynamic> json) => TrabajadorMovil1(
    idtrabajador: json["idtrabajador"],
    dni: json["dni"],
    nombres: json["nombres"],
    area: json["area"],
    puesto: json["puesto"],
    telefono: '#',
  );

  Map<String, dynamic> toJson() => {
    "idtrabajador": idtrabajador,
    "dni": dni,
    "nombres": nombres,
    "area": area,
    "puesto": puesto,
    "telefono": telefono
  };
}