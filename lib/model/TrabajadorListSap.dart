
import 'package:rrhh/model/TrabajadorMovil_model.dart';

class AppDataSap {
  final bool state;
  //final List<Trabajador> trabajador_sap;
  final List<TrabajadorMovil1> trabajador_movil;

  AppDataSap({required this.state,required this.trabajador_movil});

  factory AppDataSap.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['response'] as List;
    //List<Trabajador> response_sap_list = list.map((i) => Trabajador.fromJson(i)).toList();
    List<TrabajadorMovil1> response_movil_list = list.map((i) => TrabajadorMovil1.fromJson(i)).toList();

    return AppDataSap(
        state: parsedJson['state'],
        trabajador_movil:response_movil_list
    );
  }
}
class Trabajador {
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



  const Trabajador({
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

  factory Trabajador.fromJson(Map<String, dynamic> parsedJson) {
    return Trabajador(
      idtrabajador : parsedJson['idtrabajador'],
      idempresasap :parsedJson['idempresasap'],
      idplanilla :parsedJson['idplanilla'],
      appaterno :parsedJson['appaterno'],
      apmaterno :parsedJson['apmaterno'],
      nombres :parsedJson['nombres'],
      nombresall :parsedJson['nombresall'],
      idestadotrab :parsedJson['idestadotrab'],
      codigo :parsedJson['codigo'],
      idtipodocumento :parsedJson['idtipodocumento'],
      desc_tipodocumento :parsedJson['desc_tipodocumento'],
      firma :parsedJson['firma'],
      sexo :parsedJson['sexo'],
      nrodocumento :parsedJson['nrodocumento'],
      fecha_ingreso :parsedJson['fecha_ingreso'],
      fecha_cese :parsedJson['fecha_cese'],
      cargo :parsedJson['cargo'],
      iniciocontrato :parsedJson['iniciocontrato'],
      fincontrato :parsedJson['fincontrato'],
      idareanomina :parsedJson['idareanomina'],
      desc_areanomina :parsedJson['desc_areanomina'],
      idareapersonal :parsedJson['idareapersonal'],
      areapersonal :parsedJson['areapersonal'],
      idposicion :parsedJson['idposicion'],
      fechacreacion :parsedJson['fechacreacion'],
      fechaalteracion :parsedJson['fechaalteracion'],
      codigo_departamento :parsedJson['codigo_departamento'],
      departamento :parsedJson['departamento'],
      area :parsedJson['area'],
      seccion :parsedJson['seccion'],
      codigo_division :parsedJson['codigo_division'],
      codigo_subdivision :parsedJson['codigo_subdivision'],
      relacionlaboral :parsedJson['relacionlaboral'],
    );
  }
}

class TrabajadorMovil {
  String? idtrabajador;
  String? dni;
  String? nombres;
  String? area;
  String? puesto;
  String? telefono;

  TrabajadorMovil({
    required this.idtrabajador,
    required this.dni,
    required this.nombres,
    required this.area,
    required this.puesto,
    required this.telefono,
  });

  factory TrabajadorMovil.fromJson(Map<String, dynamic> json) => TrabajadorMovil(
    idtrabajador: json["idtrabajador"],
    dni: json["nrodocumento"],
    nombres: json["appaterno"]+' '+json["apmaterno"]+ ' '+json["nombres"],
    area: json["area"],
    puesto: json["cargo"],
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