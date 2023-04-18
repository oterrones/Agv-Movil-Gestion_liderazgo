import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/providers/login_form_provider.dart';

import '../tema/primary.dart';
import 'login_form.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}



class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height * 1,
              child: FittedBox(
                child: Image.asset('static/images/login/fondo_login.png'),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: size.height * 1,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.08),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "static/images/logo_b_g.png",
                          color: Primary.white,
                          height: size.height * 0.1,
                        ),
                        SizedBox(height: 4),
                        Text('Versión 1.0.6',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Primary.white,
                                fontSize: size.height * 0.013))
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    margin: EdgeInsets.all(size.height * 0.015),
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(size.height * 0.015),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Primary.background.withOpacity(0.6),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8)),
                          ),
                          child: ChangeNotifierProvider(
                            create: (_) => LoginFormProvider(),
                            child: LoginForm(),
                          ),
                        ),
                        InkWell(
                          child:Container(
                          padding: EdgeInsets.all(size.height * 0.015),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Primary.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                  child: Text("|",
                                      style: TextStyle(color: Primary.white))),
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(child: SizedBox()),
                                        Icon(Icons.restart_alt_rounded,
                                            color: Primary.white),
                                        SizedBox(width: 5),
                                        Text("Sincronizar",
                                            style: TextStyle(
                                                color: Primary.white)),
                                        Expanded(child: SizedBox()),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    mFormBottomSheet(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                  child: Text("|",
                                      style: TextStyle(color: Primary.white))),
                            ],
                          ),

                        ),
                        onTap: () {
                          mFormBottomSheet(context);
                        },
                      ),

                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

mFormBottomSheet(BuildContext aContext) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: aContext,
    isScrollControlled: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(50),
            ),
            color: Primary.background),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.031),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SelectSync(),
          ],
        ),
      );
    },
  );
}

class SelectSync extends StatefulWidget {
  @override
  _SelectSyncState createState() => _SelectSyncState();
}

class _SelectSyncState extends State<SelectSync> {
  List<String> listCultivos = ['Arándano'];
  String? selectedIndexCultivo = 'Arándano';

  List<String> perfil = ['Trabajador', 'Evaluador'];
  String? perfilSelect = 'Trabajador';

  String nameBtnSincronizar = "Sincronizar trabajadores";

  String error = "";
  bool isLoading = true;
  bool isError = false;
  bool isSuccess = false;

  @override
  void initState() {
    super.initState();
    datosSeleccion();
  }

  @override
  void dispose() {
    //AgrovisionDataBase.bd.close();
    super.dispose();
  }

  Future datosSeleccion() async {
    setState(() => isLoading = true);

    await Future.delayed(Duration(milliseconds: 1000));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: isSuccess
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.025),
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check, color: Primary.azul, size: 40),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                      Text("Sincronización completada!.",
                          style: TextStyle(
                              color: Primary.azul, fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              : isLoading
                  ? Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.height * 0.025),
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(
                            color: Primary.azul,
                            semanticsLabel: "Iniciando...",
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.025),
                          Text("Iniciando...",
                              style: TextStyle(
                                  color: Primary.azul, fontWeight: FontWeight.bold))
                        ],
                      ),
                    )
                  : isError
                      ? Container(
                          padding: EdgeInsets.all(25),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                  Icons
                                      .signal_wifi_statusbar_connected_no_internet_4_rounded,
                                  size: 50,
                                  color: Primary.azul),
                              SizedBox(height: 20),
                              Text(
                                "No tienes una conexión activa a internet o nuestros servidores se encuentran en mantenimiento. Inténtalo nuevamente más tarde.",
                                textAlign: TextAlign.justify,
                              ),
                              Text(
                                this.error,
                                textAlign: TextAlign.justify,
                              )
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: ListView(shrinkWrap: true, children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Sincronizar",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                      onPressed: () {
                                        datosSeleccion();
                                      },
                                      icon: Icon(
                                        Icons.sync_rounded,
                                        size: 25,
                                      )),
                                ),
                                Container(
                                  child: IconButton(
                                      onPressed: () {
                                        finish(context);
                                      },
                                      icon: Icon(
                                        Icons.close_rounded,
                                        size: 25,
                                      )),
                                )
                              ],
                            ),
                            Divider(),

                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.010),
                            Row(
                              children: <Widget>[
                                Text('Perfil: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                SizedBox(width: 15),
                                Expanded(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: perfilSelect,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        perfilSelect = newValue;
                                        nameBtnSincronizar = "Sincronizar "+newValue;
                                      });
                                    },
                                    items: perfil.map((category) {
                                      return DropdownMenuItem(
                                        child: Text(category),
                                        value: category,
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.010),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              disabledColor: Primary.azul,
                              elevation: 0,
                              color: Primary.azul,
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(nameBtnSincronizar,
                                    style: TextStyle(
                                        color: Primary.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                              ),
                              onPressed: () async {


                                setState(() => {
                                    isLoading = true,
                                    });

                                print("Iniciando Sincronización");
                                await Future.delayed(Duration(milliseconds: 1900));
                                var response = "";
                                try {
                                    if(perfilSelect == "Evaluador"){
                                      response = await DBProvider.db.GetAppDataEvaluador_insertMovil();


                                    }else{
                                      response = await DBProvider.db.GetAppDataTrabajador_insertMovil();
                                    }
                                    print(response.toString());
                                    if(response.toString()!="ok"){
                                      setState(() => {
                                        isLoading = false,
                                      });
                                      setState(() {
                                        this.isError = true;
                                      });

                                      await Future.delayed(Duration(milliseconds: 10000));
                                      finish(context);
                                    }else{
                                      setState(() {
                                        this.isSuccess = true;
                                      });
                                      await Future.delayed(Duration(milliseconds: 1000));
                                      finish(context);
                                    }
                                } on Exception catch (_) {
                                  print('never reached');
                                  setState(() => {
                                    isLoading = false,
                                  });
                                  setState(() {
                                    this.isError = true;
                                  });

                                  await Future.delayed(Duration(milliseconds: 10000));
                                  finish(context);
                                }





                               // await Future.delayed(Duration(milliseconds: 1000));
                               // finish(context);
                                print("Fin de Sincronización");
                              },
                            )
                          ]),
                        ),
        )
    );
  }

  mFormBottomSheetCapacitacion(BuildContext context, String titulo,String mensaje) {


    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(50),
              ),
              color: Primary.background),
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      titulo,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 6,),
                  Container(
                    child: IconButton(
                        onPressed: () {
                          finish(context);
                        },
                        icon: Icon(
                          Icons.close_rounded,
                          size: 25,
                        )),
                  )
                ],
              ),
              Divider(color: Colors.black),
              SizedBox(height: 25,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 2),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text('Error', textAlign: TextAlign.justify,  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            alignment: Alignment.centerLeft,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.025),

              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)),
                disabledColor: Primary.azul,
                elevation: 0,
                color: Primary.azul,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text("Ok",
                      style: TextStyle(
                          color: Primary.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                ),
                onPressed: () async {

                },
              )

            ],
          ),

        );
      },
    );
  }
}

