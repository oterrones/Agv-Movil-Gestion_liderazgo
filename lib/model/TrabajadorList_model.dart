class TrabajadorList {
  final bool state;
  final List<Resultado> resultado;

  TrabajadorList({required this.state, required this.resultado});

  factory TrabajadorList.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['resultado'] as List;
    print(list.runtimeType);
    List<Resultado> resulList = list.map((i) => Resultado.fromJson(i)).toList();

    return TrabajadorList(
        state: parsedJson['state'],
        resultado: resulList
    );
  }

}

class Resultado {
  final String id;
  final String nfp;
  final String numero_recepcion;

  Resultado({required this.id,required this.nfp ,required this.numero_recepcion});


  factory Resultado.fromJson(Map<String, dynamic> parsedJson){
    return Resultado(
        id:parsedJson['id'],
        nfp:parsedJson['nfp'],
        numero_recepcion:parsedJson['numero_recepcion']
    );
  }
}