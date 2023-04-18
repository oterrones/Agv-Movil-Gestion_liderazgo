import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/providers/scan_list_provider.dart';
import 'package:rrhh/widgets/scan_tiles.dart';

class MapasPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();
  // final scanListProvider =  Provider.of<ScanListProvider>(context);
   //final scans = scanListProvider.scans;
    return ScanTiles(tipo: 'geo');

   /*
   return ListView.builder(
       itemCount: scans.length,
       itemBuilder: (_,i) => Dismissible(
         key: UniqueKey() ,
         background: Container(
           color:  Colors.red,
         ),
         onDismissed: (DismissDirection direction){
           Provider.of<ScanListProvider>(context, listen: false).borrarPorId(scans[i].id);
         },
         child:ListTile(
         leading: Icon(Icons.map,color: Theme.of(context).primaryColor),
         title: Text(scans[i].valor),
         subtitle: Text((scans[i].id.toString())),
         trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
         onTap: () =>print(scans[i].id),
       )
       )
   );
   */
/*
//Lista todos los datpos
   return ListView.builder(
       itemCount: scans.length,
       itemBuilder: (_,i) => ListTile(
         leading: Icon(Icons.map,color: Theme.of(context).primaryColor),
         title: Text(scans[i].valor),
         subtitle: Text((scans[i].id.toString())),
         trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
         onTap: () =>print(scans[i].id),
       )
   );*/

   /* return ListView.builder(
        itemCount: 10,
        itemBuilder: (_,i) => ListTile(
          leading: Icon(Icons.map,color: Theme.of(context).primaryColor),
          title: Text('http://wwww.goo....'),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: () =>print('abrir algo..'),
        )
    );*/
  }

}