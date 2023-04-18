
import 'package:flutter/material.dart';
import 'package:rrhh/model/ScanModel.dart';
import 'package:rrhh/providers/db_provider.dart';

class ScanListProvider  extends ChangeNotifier{
  List <ScanModel> scans = [];
  String tipoSeleccionado = 'htpp';

  nuevoScan (int ids , String tipo,String valor) async{

    final nuevoScant = new ScanModel(id: ids, tipo: tipo, valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScant);
    nuevoScant.id = id;

    if(this.tipoSeleccionado == nuevoScant.tipo){
      this.scans.add(nuevoScant);
      notifyListeners();
    }
  }

  cargarScansAll() async{
    final scans = await DBProvider.db.getAllScans();
    this.scans = [...?scans];
    notifyListeners();
  }
  cargarScansPorTipo(String tipo) async{
    final scans = await DBProvider.db.getAllScansPorTipo(tipo);
    this.scans = [...?scans];
    this.tipoSeleccionado = tipo;
    notifyListeners();
  }
  borrarAll()async{
    await DBProvider.db.deleteAllScanUno();
    this.scans = [];
    notifyListeners();
  }
  borrarPorId(int id)async{
    await DBProvider.db.deleteScan(id);
    this.cargarScansPorTipo(this.tipoSeleccionado);
   // notifyListeners();
  }

}