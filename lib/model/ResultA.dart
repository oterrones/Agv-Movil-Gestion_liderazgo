
class ResulA {
  final String? id;
  final String? nfp;
  final String? numero_recepcion;



  const ResulA({
    required this.id,
    required this.nfp,
    required this.numero_recepcion,
  });


  factory ResulA.fromJson(Map<String, dynamic> json) => ResulA(
    id: json["id"],
    nfp: json["nfp"],
    numero_recepcion: json["numero_recepcion"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nfp": nfp,
    "numero_recepcion": numero_recepcion,
  };


}

