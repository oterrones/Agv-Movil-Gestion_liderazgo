
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/pages/direcciones_page.dart';
import 'package:rrhh/pages/mapas_page.dart';
import 'package:rrhh/providers/UiProvider.dart';
import 'package:flutter/material.dart';
import 'package:rrhh/providers/scan_list_provider.dart';
import 'package:rrhh/widgets/scan_botton.dart';
import 'package:rrhh/widgets/custom_navigator.dart';

class HomePage  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text ('Historial'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: (){
                Provider.of<ScanListProvider>(context, listen: false)
                .borrarAll();
            },
          )
        ],
      ),
      body: _HomePageBody(),

      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

    }


}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();
    final uiProvider = Provider.of<UiProvider>(context);

    final currentIndex =  uiProvider.selectedMenuOpt;
    final scanListProvider =  Provider.of<ScanListProvider>(context, listen: false);
    switch ( currentIndex){

      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return MapasPage();
      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return DireccionesPage() ;
      default:
        return MapasPage();
    }

  }






}