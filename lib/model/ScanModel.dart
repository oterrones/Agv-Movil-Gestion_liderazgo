import 'dart:convert';

List<ScanModel> welcomeFromJson(String str) => List<ScanModel>.from(json.decode(str).map((x) => ScanModel.fromJson(x)));

String welcomeToJson(List<ScanModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ScanModel {
  ScanModel({
    required this.id,
    required this.tipo,
    required this.valor,
  }){
    if( this.valor.contains('http')){
      this.tipo = 'http';
    }else{
      this.tipo = 'geo';
    }
  }

  int id;
  String tipo;
  String valor;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    id: json["id"],
    tipo: json["tipo"],
    valor: json["valor"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tipo": tipo,
    "valor": valor,
  };
}
