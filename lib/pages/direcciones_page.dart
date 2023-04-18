
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/providers/scan_list_provider.dart';
import 'package:rrhh/widgets/scan_tiles.dart';

class DireccionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScanTiles(tipo: 'HTTP');
  }

/*
    //Perteneciente a esta clase
    final scanListProvider =  Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

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
              leading: Icon(Icons.home_outlined,color: Theme.of(context).primaryColor),
              title: Text(scans[i].valor),
              subtitle: Text((scans[i].id.toString())),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () =>print(scans[i].id),
            )
        )
    );

    // FIN DEL CONTENIDO PERTENECIENTE A ESTA CLASE
   return ListView.builder(
        itemCount: scans.length,
        itemBuilder: (_,i) => ListTile(
          leading: Icon(Icons.home_outlined,color: Theme.of(context).primaryColor),
          title: Text(scans[i].valor),
          subtitle: Text((scans[i].id.toString())),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: () =>print(scans[i].id),
        )
    );

 // }
 */

}
