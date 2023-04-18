import 'dart:convert';

class AppDataEvaluador {
  final bool state;
  final List<Evaluador_Model> evaluador_list;
  AppDataEvaluador({required this.state, required this.evaluador_list});

  factory AppDataEvaluador.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['resultado'] as List;
    List<Evaluador_Model> response_aws_list = list.map((i) => Evaluador_Model.fromJson(i)).toList();

    return AppDataEvaluador(
        state: parsedJson['state'],
        evaluador_list: response_aws_list
    );
  }
}

class Evaluador_Model {
  Evaluador_Model({
    required this.idevaluador,
    required this.dni,
    required this.nombres
  });

  String? idevaluador;
  String? dni;
  String? nombres;


  factory Evaluador_Model.fromJson(Map<String, dynamic> json) => Evaluador_Model(
    idevaluador: json["idevaluador"],
    dni: json["dni"],
    nombres: json["nombres"],
  );

  Map<String, dynamic> toJson() => {
    "idevaluador": idevaluador,
    "dni": dni,
    "nombres": nombres
  };
}
