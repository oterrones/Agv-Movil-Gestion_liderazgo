import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/tema/primary.dart';

class homeStar extends StatefulWidget {
  @override
  State<homeStar> createState() => _homeStarState();
}

class _homeStarState extends State<homeStar> {



  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController checbox1 = TextEditingController();

  List<Map<String, dynamic>> _lSesionLogeado = [];
  String usuarioLogeado = ".....";

  Future<void> leerSesionLogeado() async {
    final data = await DBProvider.db.getSesionLogeado();
    ///setState(() {
      _lSesionLogeado = data;

   // });
    usuarioLogeado = _lSesionLogeado[0]["nombres"];
    _titleController.text = usuarioLogeado;
  }

  @override
  Widget build(BuildContext context) {
    leerSesionLogeado();
    return AnnotatedRegion<SystemUiOverlayStyle>(

        value: SystemUiOverlayStyle(
            statusBarColor: Primary.white.withOpacity(0),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Primary.azul,
            systemNavigationBarIconBrightness: Brightness.light),
        child: Container(
          color: Primary.background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: <Widget>[
                getAppBarUI(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.topCenter,
                    child:
                       Container(
                         height: MediaQuery.of(context).size.height * 0.76,
                         child: ListView(shrinkWrap: true, children: <Widget>[
                           Padding(
                             padding: const EdgeInsets.only(
                                 left: 24, right: 24, top: 0, bottom: 18),
                             child: Container(
                               width: double.infinity,
                               height: 240,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.only(
                                     topLeft: Radius.circular(15.0),
                                     bottomLeft: Radius.circular(15.0),
                                     bottomRight: Radius.circular(15.0),
                                     topRight: Radius.circular(70.0)),
                                 image: DecorationImage(
                                   image: AssetImage('static/images/fondo_liderazgo_fon.png'),
                                   fit: BoxFit.cover,
                                 ),
                                 boxShadow: <BoxShadow>[
                                   BoxShadow(
                                       color: Primary.grey.withOpacity(0.2),
                                       offset: Offset(1.1, 1.1),
                                       blurRadius: 10.0
                                   ),
                                 ],
                               ),
                               child: Stack(
                                 children: [
                                   Container(
                                     width: double.infinity,
                                     padding: const EdgeInsets.only(
                                         left: 5, right: 2, top: 40, bottom: 18),
                                     child: Column(
                                       children: <Widget>[
                                         Text(
                                           'Liderazgo en campo',
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             fontFamily: Primary.fontName,
                                             fontWeight: FontWeight.bold,
                                             fontSize: 19,
                                             letterSpacing: -0.2,
                                             color: Primary.white,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   Container(
                                     width: double.infinity,
                                     padding: const EdgeInsets.only(
                                         left: 5, right: 2, top: 130, bottom: 18),
                                     child: Column(
                                       children: <Widget>[
                                         MaterialButton(
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(7)),
                                           disabledColor: Primary.azul,
                                           elevation: 0,
                                           color: Colors.deepOrange[800],

                                           child: Container(
                                             alignment: Alignment.center,
                                             width:120,
                                             child: Text("Iniciar",
                                                 style: TextStyle(
                                                     color: Primary.white,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 17)),
                                           ),
                                           onPressed: () async {
                                             // Navigator.pushReplacementNamed(context, 'registroCampo');
                                             Navigator.pushReplacementNamed(context, 'registroCampo');

                                           },
                                         )
                                       ],
                                     ),
                                   ),

                                 ],
                               ),
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(
                                 left: 24, right: 24, top: 0, bottom: 18),
                             child: Container(
                               width: double.infinity,
                               height: 240,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.only(
                                     topLeft: Radius.circular(15.0),
                                     bottomLeft: Radius.circular(15.0),
                                     bottomRight: Radius.circular(15.0),
                                     topRight: Radius.circular(70.0)),
                                 image: DecorationImage(
                                   image: AssetImage('static/images/paking_jpg_01.jpg'),
                                   fit: BoxFit.cover,
                                 ),
                                 boxShadow: <BoxShadow>[
                                   BoxShadow(
                                       color: Primary.grey.withOpacity(0.2),
                                       offset: Offset(1.1, 1.1),
                                       blurRadius: 10.0
                                   ),
                                 ],
                               ),
                               child: Stack(
                                 children: [
                                   Container(
                                     width: double.infinity,
                                     padding: const EdgeInsets.only(
                                         left: 5, right: 2, top: 40, bottom: 18),
                                     child: Column(
                                       children: <Widget>[
                                         Text(
                                           'Liderazgo en packing',
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             fontFamily: Primary.fontName,
                                             fontWeight: FontWeight.bold,
                                             fontSize: 19,
                                             letterSpacing: -0.2,
                                             color: Primary.white,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   Container(
                                     width: double.infinity,
                                     padding: const EdgeInsets.only(
                                         left: 5, right: 2, top: 130, bottom: 18),
                                     child: Column(
                                       children: <Widget>[
                                         MaterialButton(
                                           shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(7)),
                                           disabledColor: Primary.verde,
                                           elevation: 0,
                                           color: Colors.yellow[700],

                                           child: Container(
                                             alignment: Alignment.center,
                                             width:120,
                                             child: Text("Iniciar",
                                                 style: TextStyle(
                                                     color: Primary.white,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 17)),
                                           ),
                                           onPressed: () async {
                                             Navigator.pushReplacementNamed(context, 'registroPacking');
                                           },
                                         )
                                       ],
                                     ),
                                   ),

                                 ],
                               ),


                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(
                                 left: 24, right: 24, top: 30, bottom: 18),
                             child: Container(
                                 alignment: Alignment.centerLeft,
                                 child: Column(
                                     children: <Widget>[
                                       Container(
                                         child: Text('RESPONSABLE DE INSPECCIÓN:', textAlign: TextAlign.center,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                         alignment: Alignment.center,
                                       ),
                                       TextFormField(
                                         controller: _titleController,
                                         decoration: const InputDecoration(
                                           hintText: 'Usuario logeado',
                                         ),
                                         validator: (String? value) {
                                           if (value == null || value.isEmpty) {
                                             return 'Please enter some text';
                                           }
                                           return null;
                                         },
                                         readOnly: true,
                                         enabled: false,
                                         textAlign: TextAlign.center,
                                       ),
                                     ]
                                 )
                             ),
                           ),
                         ]

                      ),

                    ),


                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],

            ),

          ),
        ));
  }

  Widget getAppBarUI() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: Primary.azul.withOpacity(1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32.0),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Primary.azul.withOpacity(0.4 * 1),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 28,
                  width: 28,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(32.0)),
                    onTap: () {},
                    child: Center(
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'FORMATO LDC-LDP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: Primary.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                        letterSpacing: 1.2,
                        color: Primary.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                  width: 28,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(32.0)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                    child: Center(
                      child: Icon(
                        Icons.power_settings_new,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}



