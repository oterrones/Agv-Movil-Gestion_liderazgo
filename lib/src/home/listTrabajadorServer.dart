import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rrhh/model/ResultApiETL.dart';


class HomeScreenListTrabajador extends StatelessWidget {

  Future<AppData> fetchResultado() async {
    print('Inicio');
    var url = Uri.parse('http://etl.agvperu.com/etl_firmPro/getFirmproDataCalidadTest');

      final response = await http.post(url);
  //  Response response = await http.post(url);

    print(response.statusCode);
    if (response.statusCode == 200) {

      print(0);



      final AppData moviesFirstLoad = moviesFirstLoadFromJson(response.body);

      print(1);
      print(moviesFirstLoad);
      print(21);
      return moviesFirstLoad;


      //return AppData.fromJson(jsonDecode(response.body));

    } else {
      print('FALLIDO');
      throw Exception('Failed to load album');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Películas')),
      body: FutureBuilder(
        future: fetchResultado(),
        builder: (BuildContext context, AsyncSnapshot<AppData> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data?.movierecent.length,
            itemBuilder: (BuildContext context, int index) {
              final Movierecent?  movie = snapshot.data?.movierecent[index];
              return ListTile(
                title: Text((movie?.id).toString()),
                subtitle: Text((movie?.nfp).toString()),
              );
            },
          );
        },
      ),
    );
  }
}