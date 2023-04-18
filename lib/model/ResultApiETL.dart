
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
  final String id;
  final String nfp;
  final String numero_recepcion;



  const Movierecent({
    required this.id,
    required this.nfp,
    required this.numero_recepcion,
  });

  factory Movierecent.fromJson(Map<String, dynamic> json) {
    return Movierecent(
      id : json['id'],
      nfp :json['nfp'],
      numero_recepcion :json['numero_recepcion'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nfp": nfp,
    "numero_recepcion": numero_recepcion,
  };
}

