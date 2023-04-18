
import 'dart:convert';

AppData moviesFirstLoadFromJson(String str) {
  final jsonData = json.decode(str);
  return AppData.fromJson(jsonData);
}

String moviesFirstToJson(AppData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class AppData {
  List<Movierecent> movierecent;

  AppData({
    required this.movierecent,
  });

  factory AppData.fromJson(Map<String, dynamic> json) => new AppData(
    movierecent: new List<Movierecent>.from(
        json["movierecent"].map((x) => Movierecent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "movierecent":
    new List<dynamic>.from(movierecent.map((x) => x.toJson())),
  };
}
class Movierecent {
  final String? idtrabajador;
  final String? idempresasap;
  final String? idplanilla;
  final String? appaterno;
  final String? apmaterno;
  final String? nombres;
  final String? nombresall;
  final String? idestadotrab;
  final String? codigo;
  final String? idtipodocumento;
  final String? desc_tipodocumento;
  final String? firma;
  final String? sexo;
  final String? nrodocumento;
  final String? fecha_ingreso;
  final String? fecha_cese;
  final String? cargo;
  final String? iniciocontrato;
  final String? fincontrato;
  final String? idareanomina;
  final String? desc_areanomina;
  final String? idareapersonal;
  final String? areapersonal;
  final String? idposicion;
  final String? fechacreacion;
  final String? fechaalteracion;
  final String? codigo_departamento;
  final String? departamento;
  final String? area;
  final String? seccion;
  final String? codigo_division;
  final String? codigo_subdivision;
  final String? relacionlaboral;



  const Movierecent({
    required this.idtrabajador,
    required this.idempresasap,
    required this.idplanilla,
    required this.appaterno,
    required this.apmaterno,
    required this.nombres,
    required this.nombresall,
    required this.idestadotrab,
    required this.codigo,
    required this.idtipodocumento,
    required this.desc_tipodocumento,
    required this.firma,
    required this.sexo,
    required this.nrodocumento,
    required this.fecha_ingreso,
    required this.fecha_cese,
    required this.cargo,
    required this.iniciocontrato,
    required this.fincontrato,
    required this.idareanomina,
    required this.desc_areanomina,
    required this.idareapersonal,
    required this.areapersonal,
    required this.idposicion,
    required this.fechacreacion,
    required this.fechaalteracion,
    required this.codigo_departamento,
    required this.departamento,
    required this.area,
    required this.seccion,
    required this.codigo_division,
    required this.codigo_subdivision,
    required this.relacionlaboral,
  });

  factory Movierecent.fromJson(Map<String, dynamic> json) {
    return Movierecent(
      idtrabajador : json['idtrabajador'],
      idempresasap :json['idempresasap'],
      idplanilla :json['idplanilla'],
      appaterno :json['appaterno'],
      apmaterno :json['apmaterno'],
      nombres :json['nombres'],
      nombresall :json['nombresall'],
      idestadotrab :json['idestadotrab'],
      codigo :json['codigo'],
      idtipodocumento :json['idtipodocumento'],
      desc_tipodocumento :json['desc_tipodocumento'],
      firma :json['firma'],
      sexo :json['sexo'],
      nrodocumento :json['nrodocumento'],
      fecha_ingreso :json['fecha_ingreso'],
      fecha_cese :json['fecha_cese'],
      cargo :json['cargo'],
      iniciocontrato :json['iniciocontrato'],
      fincontrato :json['fincontrato'],
      idareanomina :json['idareanomina'],
      desc_areanomina :json['desc_areanomina'],
      idareapersonal :json['idareapersonal'],
      areapersonal :json['areapersonal'],
      idposicion :json['idposicion'],
      fechacreacion :json['fechacreacion'],
      fechaalteracion :json['fechaalteracion'],
      codigo_departamento :json['codigo_departamento'],
      departamento :json['departamento'],
      area :json['area'],
      seccion :json['seccion'],
      codigo_division :json['codigo_division'],
      codigo_subdivision :json['codigo_subdivision'],
      relacionlaboral :json['relacionlaboral'],
    );
  }

  Map<String, dynamic> toJson() => {
    "idtrabajador": idtrabajador,
    "idempresasap": idempresasap,
    "idplanilla": idplanilla,
    "appaterno": appaterno,
    "apmaterno": apmaterno,
    "nombres": nombres,
    "nombresall": nombresall,
    "idestadotrab": idestadotrab,
    "codigo": codigo,
    "idtipodocumento": idtipodocumento,
    "desc_tipodocumento": desc_tipodocumento,
    "firma": firma,
    "sexo": sexo,
    "nrodocumento": nrodocumento,
    "fecha_ingreso": fecha_ingreso,
    "fecha_cese": fecha_cese,
    "cargo": cargo,
    "iniciocontrato": iniciocontrato,
    "fincontrato": fincontrato,
    "idareanomina": idareanomina,
    "desc_areanomina": desc_areanomina,
    "idareapersonal": idareapersonal,
    "areapersonal": areapersonal,
    "idposicion": idposicion,
    "fechacreacion": fechacreacion,
    "fechaalteracion": fechaalteracion,
    "codigo_departamento": codigo_departamento,
    "departamento": departamento,
    "area": area,
    "seccion": seccion,
    "codigo_division": codigo_division,
    "codigo_subdivision": codigo_subdivision,
    "relacionlaboral": relacionlaboral,
  };
}

