
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/providers/scan_list_provider.dart';

class ScanButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();
    return FloatingActionButton(
      elevation: 0,
      child: Icon(Icons.filter_center_focus),
      onPressed: () async{
        final barcadeScanRes = 'https://fernando-herrera.com';
        final scanListProvider = Provider.of<ScanListProvider>(context, listen:false);
        scanListProvider.nuevoScan(1, '2', barcadeScanRes);
        scanListProvider.nuevoScan(1, '2', 'geo:15:33,15.92');
       // print(barcadeScanRes);
      },
    );
  }

}