import 'package:flutter/cupertino.dart';
import 'package:rrhh/model/ScanModel.dart';
import 'package:rrhh/src/providers/bd_provider.dart';

class ScanListProvider extends ChangeNotifier{
  List <ScanModel> scans = [];
  String tipoSeleccionado = 'http';
  nuevoScan (int ids, String tipo,String valor) async{

    final nuevoScan = new ScanModel(id: ids, tipo: tipo, valor: valor);

    final id = await DBProvider.db.nuevoScan(nuevoScan);
    nuevoScan.id = id;

    if((this.tipoSeleccionado == nuevoScan.tipo)){
      this.scans.add(nuevoScan);
      notifyListeners();
    }
  }
}