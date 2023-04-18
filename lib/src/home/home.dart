import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rrhh/model/DetalleResultado_model.dart';
import 'package:rrhh/model/Resultado_model.dart';

import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/tema/primary.dart';

class packingHome extends StatefulWidget {
  @override
  State<packingHome> createState() => _packingHomeState();
}

class _packingHomeState extends State<packingHome> {
  String error = "hola";
  bool isCargando = true;
  bool isError = false;
  bool isSuccess = false;
  String cosechaSem = "";

  List<String> escuela = [
    'Frío',
    'Acopio',
    'Producción',
    'Entrenamiento',
    'Saneamiento'
  ];
  String? escuelaSelected = 'Frío';

  List<String> unidad = ['Un palto', 'Un vid', 'Un espárrago', 'Un arándano'];
  String? unidadSelected = 'Un palto';

  List<String> tipo = [
    'Capacitación',
    'Seguimiento I',
    'Seguimiento II',
    'Seguimiento III',
    'Seguimiento IV'
  ];
  String? tipoSelected = 'Capacitación';

  List<String> canal = ['Evaluador', 'Jefe'];
  String? canalSelected = 'Evaluador';

  String? nombres_text = '';
  String? dni_text = '';
  String? puesto_text = '';
  String? area_text = '';
  int? codigo_int;

  String? nombresJefe_text = '';
  String? dniJefe_text = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController txtDniTrabajador_Controller =
      new TextEditingController();
  final TextEditingController txtNombreTrabajador_Controller =
      new TextEditingController();
  final TextEditingController txtAreaTrabajador_Controller =
      new TextEditingController();
  final TextEditingController txtPuestoTrabajador_Controller =
      new TextEditingController();
  final TextEditingController txtDniJefe_Controller =
      new TextEditingController();
  final TextEditingController txtNombreJefe_Controller =
      new TextEditingController();

  //

  List<Map<String, dynamic>> _lSesionLogeado = [];
  String usuarioLogeado_dni = "";
  int usuarioLogeado_codigo = 0;
  int _selectedIndex = 0;

  Future<void> leerSesionLogeado() async {
    final data = await DBProvider.db.getSesionLogeado();
    setState(() {
      _lSesionLogeado = data;
    });
    usuarioLogeado_dni = _lSesionLogeado[0]["dni_sesion"];
  }

  @override
  void initState() {
    super.initState();
    datosSeleccion();
    leerSesionLogeado();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future datosSeleccion() async {
    setState(() => isCargando = true);

    await Future.delayed(Duration(milliseconds: 0));

    setState(() => isCargando = false);
  }

  Future<void> BuscarTrabajador(
      int tipo_filtro,
      String dni_trabajador,
      String dni_jefe,
      String escuela,
      String unidad,
      String canal,
      String tipo_concepto) async {
    final codigoResultado = await DBProvider.db.getTrabajadorById(dni_trabajador);

    nombres_text = codigoResultado?.nombres;
    dni_text = codigoResultado?.dni;
    codigo_int = codigoResultado?.idtrabajador;
    puesto_text = codigoResultado?.puesto;
    area_text = codigoResultado?.area;

    // print("Base: "+nombres_text.toString());

    if (nombres_text.toString() == "" ||
        nombres_text.toString() == null ||
        nombres_text.toString() == "null" ||
        dni_trabajador == "") {
      txtNombreTrabajador_Controller.text = '';
      txtAreaTrabajador_Controller.text = '';
      txtPuestoTrabajador_Controller.text = '';
    } else {
      txtNombreTrabajador_Controller.text = nombres_text.toString();
      txtAreaTrabajador_Controller.text = area_text.toString();
      txtPuestoTrabajador_Controller.text = puesto_text.toString();
    }

    //SE CONTROLA SOLO AL INTENTAR REALIZAR UNA EVALUACION
    if (tipo_filtro == 2) {
      if (nombres_text.toString() == "" ||
          nombres_text.toString() == null ||
          nombres_text.toString() == "null" ||
          dni_trabajador == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Trabajador no encontrado!',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ));
      } else {
        String resultado = await BuscarTrabajadorJefe(dni_jefe, 3);

        print (tipo_concepto);
        if (resultado.toString() == "ok") {
          if (tipo_concepto == "Capacitación") {
            mFormBottomSheetCapacitacion(context,  tipo_concepto.toString() + " en packing", usuarioLogeado_dni
                , dni_trabajador, txtNombreTrabajador_Controller.text, dni_jefe
                , txtNombreJefe_Controller.text, escuela, unidad, canal);
          } else {
            mFormBottomSheet(context,  tipo_concepto.toString() + " en packing", usuarioLogeado_dni
                , dni_trabajador, txtNombreTrabajador_Controller.text, dni_jefe
                , txtNombreJefe_Controller.text, escuela, unidad, canal,tipo_concepto);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Jefe no encontrado!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange)),
          ));
        }
      }
    }

    nombres_text = '';
    area_text = '';
    puesto_text = '';
  }

  Future<String> BuscarTrabajadorJefe(String dni_jefe, int tipo_filtro) async {
    String resultado = "ok";

    final codigoResultado = await DBProvider.db.getTrabajadorById(dni_jefe);

    nombresJefe_text = codigoResultado?.nombres;
    dniJefe_text = codigoResultado?.dni;

    if (nombresJefe_text.toString() == "" ||
        nombresJefe_text.toString() == "null" ||
        nombresJefe_text.toString() == null ||
        dni_jefe == "") {
      txtNombreJefe_Controller.text = '';
      resultado = "vacio";
    } else {
      txtNombreJefe_Controller.text = nombresJefe_text.toString();
      resultado = "ok";
    }

    if (tipo_filtro == 2) {
      if (nombresJefe_text.toString() == "" ||
          nombresJefe_text.toString() == null ||
          nombresJefe_text.toString() == "null" ||
          dni_jefe == "") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Jefe no encontrado!',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ));
      }
    }

    nombresJefe_text = '';
    return resultado;
  }

  @override
  Widget build(BuildContext context) {
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
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.indigoAccent,
                // called when one tab is selected
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                    print(_selectedIndex);
                    if (_selectedIndex == 1) {
                      Navigator.pushReplacementNamed(context, 'listLidirazgo');
                    } else if (_selectedIndex == 2) {
                      Navigator.pushReplacementNamed(context, 'planAccion');
                    }
                  });
                },
                // bottom tab items
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed_outlined), label: 'Evaluar'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.view_list), label: 'Evaluados'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.speaker_notes), label: 'Plan Acción')
                ]),
            body: Column(
              children: <Widget>[
                getAppBarUI(),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.topCenter,
                      child: this.isCargando
                          ? Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Primary.azul,
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Cargando formulario, espere...",
                                    style: TextStyle(
                                        color: Primary.azul,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.85,
                                child: Form(
                                    key: _formKey,
                                    child: ListView(
                                      padding: EdgeInsets.only(top: 15),
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        Card(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: Column(
                                                  children: <Widget>[
                                                    //INICIA TRABAJADOR
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    top: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'TRABAJADOR:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              17)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                TextFormField(
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .search,
                                                                  onFieldSubmitted:
                                                                      (value) {
                                                                    BuscarTrabajador(
                                                                        1,
                                                                        txtDniTrabajador_Controller
                                                                            .text,
                                                                        "",
                                                                        "",
                                                                        "",
                                                                        "",
                                                                        "");
                                                                  },
                                                                  maxLength: 8,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,

                                                                  controller:
                                                                      txtDniTrabajador_Controller,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ingrese Dni',
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Dni requerida';
                                                                    }
                                                                    return null;
                                                                  },

                                                                  maxLines:
                                                                      null,
                                                                  //keyboardType: TextInputType.multiline,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 15),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                MaterialButton(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7)),
                                                                  disabledColor:
                                                                      Primary
                                                                          .azul,
                                                                  elevation: 0,
                                                                  color: Colors
                                                                          .cyan[
                                                                      600],
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 100,
                                                                    child: Text(
                                                                        "Buscar",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Primary.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 17)),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    BuscarTrabajador(
                                                                      1,
                                                                        txtDniTrabajador_Controller
                                                                            .text,
                                                                        "",
                                                                        "",
                                                                        "",
                                                                        "",
                                                                        "");
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            new FocusNode());
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'NOMBRES:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15)),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      txtNombreTrabajador_Controller,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ingrese nombre del trabajador',
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  readOnly:
                                                                      true,
                                                                  enabled:
                                                                      false,
                                                                  // initialValue: 'sas',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        //SizedBox(width: 10,),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'ÁREA:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15)),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      txtAreaTrabajador_Controller,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Área',
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  readOnly:
                                                                      true,
                                                                  enabled:
                                                                      false,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'PUESTO:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15)),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      txtPuestoTrabajador_Controller,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Puesto',
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  readOnly:
                                                                      true,
                                                                  enabled:
                                                                      false,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15),
                                                  ],
                                                ))),
                                        SizedBox(height: 0),

                                        Card(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: Column(
                                                  children: <Widget>[
                                                    //INICIA JEFE
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10,
                                                                    top: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'JEFE:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              17)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                TextFormField(
                                                                  textInputAction:
                                                                      TextInputAction
                                                                          .search,
                                                                  onFieldSubmitted:
                                                                      (value) {
                                                                    BuscarTrabajadorJefe(
                                                                        txtDniJefe_Controller
                                                                            .text,
                                                                        1);
                                                                  },
                                                                  maxLength: 8,
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,

                                                                  controller:
                                                                  txtDniJefe_Controller,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ingrese Dni Jefe',
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Dni requerida';
                                                                    }
                                                                    return null;
                                                                  },

                                                                  maxLines:
                                                                      null,
                                                                  //keyboardType: TextInputType.multiline,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 25),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                MaterialButton(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7)),
                                                                  disabledColor:
                                                                      Primary
                                                                          .azul,
                                                                  elevation: 0,
                                                                  color: Color.fromRGBO(255, 193, 7, 1),
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 100,
                                                                    child: Text(
                                                                        "Buscar",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Primary.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 17)),
                                                                  ),
                                                                  onPressed:
                                                                      () async {

                                                                    BuscarTrabajadorJefe(
                                                                        txtDniJefe_Controller
                                                                            .text,
                                                                        1);
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            new FocusNode());
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'NOMBRES:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15)),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      txtNombreJefe_Controller,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Ingrese nombre del Jefe',
                                                                  ),
                                                                  validator:
                                                                      (String?
                                                                          value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please enter some text';
                                                                    }
                                                                    return null;
                                                                  },
                                                                  readOnly:
                                                                      true,
                                                                  enabled:
                                                                      false,
                                                                  // initialValue: 'sas',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ))),
                                        SizedBox(height: 0),
                                        Card(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                child: Column(
                                                  children: <Widget>[
                                                    //INICIA ETAPA Y CAMPO
                                                    SizedBox(
                                                      height: 12,
                                                    ),

                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'TIPO:',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                          15)),
                                                                  alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                                ),
                                                                DropdownButton(
                                                                  isExpanded:
                                                                  true,
                                                                  value:
                                                                  tipoSelected,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                  ),
                                                                  onChanged:
                                                                      (dynamic
                                                                  newValue) {
                                                                    setState(
                                                                            () {
                                                                          tipoSelected =
                                                                              newValue;
                                                                        });
                                                                  },
                                                                  items: tipo
                                                                      .map(
                                                                          (category) {
                                                                        return DropdownMenuItem(
                                                                          child: Text(
                                                                              category),
                                                                          value:
                                                                          category,
                                                                        );
                                                                      }).toList(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'CANAL:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15)),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                DropdownButton(
                                                                  isExpanded:
                                                                      true,
                                                                  value:
                                                                      canalSelected,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                  ),
                                                                  onChanged:
                                                                      (dynamic
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      canalSelected =
                                                                          newValue;
                                                                    });
                                                                  },
                                                                  items: canal.map(
                                                                      (category) {
                                                                    return DropdownMenuItem(
                                                                      child: Text(
                                                                          category),
                                                                      value:
                                                                          category,
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'ESCUELA:',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                          15)),
                                                                  alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                                ),
                                                                DropdownButton(
                                                                  isExpanded:
                                                                  true,
                                                                  value:
                                                                  escuelaSelected,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                  ),
                                                                  onChanged:
                                                                      (dynamic
                                                                  newValue) {
                                                                    setState(
                                                                            () {
                                                                          escuelaSelected =
                                                                              newValue;
                                                                        });
                                                                  },
                                                                  items: escuela
                                                                      .map(
                                                                          (category) {
                                                                        return DropdownMenuItem(
                                                                          child: Text(
                                                                              category),
                                                                          value:
                                                                          category,
                                                                        );
                                                                      }).toList(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 15),
                                                        Expanded(
                                                          child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                      'UNIDAD:',
                                                                      textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                          15)),
                                                                  alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                                ),
                                                                DropdownButton(
                                                                  isExpanded:
                                                                  true,
                                                                  value:
                                                                  unidadSelected,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                  ),
                                                                  onChanged:
                                                                      (dynamic
                                                                  newValue) {
                                                                    setState(
                                                                            () {
                                                                          unidadSelected =
                                                                              newValue;
                                                                        });
                                                                  },
                                                                  items: unidad.map(
                                                                          (category) {
                                                                        return DropdownMenuItem(
                                                                          child: Text(
                                                                              category),
                                                                          value:
                                                                          category,
                                                                        );
                                                                      }).toList(),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ))),

                                        //Inicia Botones
                                        SizedBox(
                                          height: 17,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(bottom: 10),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: <Widget>[
                                                    MaterialButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7)),
                                                      disabledColor:
                                                          Primary.verde,
                                                      elevation: 0,
                                                      color: Colors.blue[700],
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 120,
                                                        child: Text("Evaluar",
                                                            style: TextStyle(
                                                                color: Primary
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17)),
                                                      ),
                                                      onPressed: () async {
                                                        BuscarTrabajador(2, txtDniTrabajador_Controller.text, txtDniJefe_Controller.text,
                                                             escuelaSelected.toString(), unidadSelected.toString(),
                                                            canalSelected.toString(), tipoSelected.toString());

                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                            )),
                ),
                SizedBox(height: 4),

                // Expanded(child: _mainContents[_selectedIndex]),
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
                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'home');
                    },
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Evaluar en packing',
                      textAlign: TextAlign.right,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}

mFormBottomSheet(
    BuildContext aContext,
    String titulo,
    String dni_sesion,
    String dni_trabajador,
    String nombres_trabajador,
    String dni_jefe,
    String nombres_jefe,
    String escuela,
    String unidad,
    String canal,
    String tipo_concepto) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: aContext,
    isScrollControlled: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(50),
            ),
            color: Primary.background),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
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
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 6,
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
            Divider(color: Colors.black),
            SelectSync(dni_sesion, dni_trabajador, nombres_trabajador, dni_jefe,
                nombres_jefe, escuela, unidad, canal, tipo_concepto),
          ],
        ),
      );
    },
  );
}

mFormBottomSheetCapacitacion(
    BuildContext context,
    String titulo,
    String dni_sesion,
    String dni_trabajador,
    String nombres_trabajador,
    String dni_jefe,
    String nombres_jefe,
    String escuela,
    String unidad,
    String canal) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7),
              topRight: Radius.circular(50),
            ),
            color: Primary.background),
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
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
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 6,
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
            Divider(color: Colors.black),
            SelectCapacitacion(dni_sesion, dni_trabajador, nombres_trabajador,
                dni_jefe, nombres_jefe, escuela, unidad, canal),
          ],
        ),
      );
    },
  );
}

//MODAL DE LAS 11 PREGUNTAS
class SelectSync extends StatefulWidget {
  final String dni_sesion;
  final String dni_trabajador;
  final String nombres_trabajador;
  final String dni_jefe;
  final String nombres_jefe;
  final String escuela;
  final String unidad;
  final String canal;
  final String tipo_concepto;

  const SelectSync(
      this.dni_sesion,
      this.dni_trabajador,
      this.nombres_trabajador,
      this.dni_jefe,
      this.nombres_jefe,
      this.escuela,
      this.unidad,
      this.canal,
      this.tipo_concepto);

  @override
  _SelectSyncState createState() => _SelectSyncState();
}

class _SelectSyncState extends State<SelectSync> {
  String error = "";
  bool isLoading = false;
  bool isError = false;
  bool isSuccess = false;

  //Fila Pregunta 01;
  bool isChecked1_01 = false;
  bool isChecked1_02 = false;
  bool isChecked1_03 = false;
  bool isChecked1_04 = false;

  //Fila Pregunta 02;
  bool isChecked2_01 = false;
  bool isChecked2_02 = false;
  bool isChecked2_03 = false;
  bool isChecked2_04 = false;

  //Fila Pregunta 03;
  bool isChecked3_01 = false;
  bool isChecked3_02 = false;
  bool isChecked3_03 = false;
  bool isChecked3_04 = false;

  //Fila Pregunta 04;
  bool isChecked4_01 = false;
  bool isChecked4_02 = false;
  bool isChecked4_03 = false;
  bool isChecked4_04 = false;

  //Fila Pregunta 05;
  bool isChecked5_01 = false;
  bool isChecked5_02 = false;
  bool isChecked5_03 = false;
  bool isChecked5_04 = false;

  //Fila Pregunta 06;
  bool isChecked6_01 = false;
  bool isChecked6_02 = false;
  bool isChecked6_03 = false;
  bool isChecked6_04 = false;

  //Fila Pregunta 07;
  bool isChecked7_01 = false;
  bool isChecked7_02 = false;
  bool isChecked7_03 = false;
  bool isChecked7_04 = false;

  //Fila Pregunta 08;
  bool isChecked8_01 = false;
  bool isChecked8_02 = false;
  bool isChecked8_03 = false;
  bool isChecked8_04 = false;

  //Fila Pregunta 09;
  bool isChecked9_01 = false;
  bool isChecked9_02 = false;
  bool isChecked9_03 = false;
  bool isChecked9_04 = false;

  //Fila Pregunta 10;
  bool isChecked10_01 = false;
  bool isChecked10_02 = false;
  bool isChecked10_03 = false;
  bool isChecked10_04 = false;

  //Fila Pregunta 11;
  bool isChecked11_01 = false;
  bool isChecked11_02 = false;
  bool isChecked11_03_1 = false;
  bool isChecked11_04 = false;

  String gender = 'hombre';
  int correctScore = 0;

  int RespuestaPreg_01 = 0;
  int RespuestaPreg_02 = 0;
  int RespuestaPreg_03 = 0;
  int RespuestaPreg_04 = 0;
  int RespuestaPreg_05 = 0;
  int RespuestaPreg_06 = 0;
  int RespuestaPreg_07 = 0;
  int RespuestaPreg_08 = 0;
  int RespuestaPreg_09 = 0;
  int RespuestaPreg_10 = 0;
  int RespuestaPreg_11 = 0;

  final TextEditingController txtObservaciones =new TextEditingController();

  Future<bool> showExitPopup(String pregunta) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (context) => AlertDialog(
            title: Text("Completar respuesta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 6.0,
                )),
            content: (pregunta=="12")?Text("Revisar observaciones"):Text("Revisar pregunta N°. " + pregunta),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text("OK"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showDialogoRegistro() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
            Navigator.pushReplacementNamed(context, 'registroPacking');

          });
          return AlertDialog(
            title: Text('Mensaje',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  //  Text('This is a demo alert dialog.'),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 33.0,
                  ),
                  Text("Registro exitoso",textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }) ??
        false; //if showDialouge had returned null, then return false
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //dateinput.text = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future datosSeleccion() async {
    setState(() => isLoading = true);

    await Future.delayed(Duration(milliseconds: 1000));

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Color getColorOpt1(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    Color getColorOpt2(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.orangeAccent;
    }

    Color getColorOpt3(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.lime;
    }

    Color getColorOpt4(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    final textOpt1_ = " No sabe que tiene que hacerlo.";
    final textOpt2_ = " Lo sabe, pero no lo hace.";
    final textOpt3_ = " Lo hace con esfuerzo.";
    final textOpt4_ = " Lo hace de manera natural.";

    String vr_dni_logeado = widget.dni_sesion;
    String vr_dni_trabajdor = widget.dni_trabajador;
    String vr_nombres_trabajador = widget.nombres_trabajador;
    String vr_dni_jefe = widget.dni_jefe;
    String vr_nombres_jefe = widget.nombres_jefe;
    String vr_escuela = widget.escuela;
    String vr_unidad = widget.unidad;
    String vr_canal = widget.canal;
    String vr_tipo_concepto = widget.tipo_concepto;

    Future<void> resgitrarRespuestas(
        Map<String, dynamic> _map_respuesta,String observacion) async {
      final fechaActual = DateFormat("yyyy-MM-dd").format(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .parseUTC(DateTime.now().toString())
              .toUtc());
      final HoraActual = DateFormat("HH:mm:ss").format(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .parseUTC(DateTime.now().toString())
              .toUtc());

      final objResultado = new Resultado_Model(
          fecha: fechaActual,
          hora: HoraActual,
          type_evaluacion: 'PACKING',
          dni_evaluador: vr_dni_logeado,
          dni_trabajador: vr_dni_trabajdor,
          nombres_trabajador: vr_nombres_trabajador,
          dni_jefe: vr_dni_jefe,
          nombres_jefe: vr_nombres_jefe,
          etapa: "",
          campo: "",
          escuela: vr_escuela,
          unidad: vr_unidad,
          name_categoria: "SEGUIMIENTO",
          concepto: "SEGUIMIENTO",
          tipo_concepto: vr_tipo_concepto,
          canal: vr_canal,
          estado: '1',
          capacitacion: '5',
        observacion_seguimiento: observacion,
      );

      final codigoResultado = await DBProvider.db.nuevoResultado(objResultado);

      for (var i = 0; i < _map_respuesta.length; i++) {
        int respuesta = _map_respuesta["rpta_" + (i + 1).toString()];
        final objDetalleResultado = new DetalleResultado_Model(
            id_pregunta: ((i + 1)).toString(),
            idresultado: codigoResultado.toString(),
            respuesta: (respuesta).toString());
        DBProvider.db.nuevoDetalleResultado(objDetalleResultado);
      }

      Navigator.of(context).pop();
      showDialogoRegistro();

      EasyLoading.addStatusCallback((status) {
        print('EasyLoading Status $status');
      });
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.76,
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    top: 5,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                    left: 5,
                    right: 5),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'I. Realiza la pauta estilo AGROVISION de manera correcta..',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked1_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked1_01 = true;
                                                            isChecked1_02 = false;
                                                            isChecked1_03 = false;
                                                            isChecked1_04 = false;
                                                            RespuestaPreg_01 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked1_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked1_02 = true;
                                                            isChecked1_01 = false;
                                                            isChecked1_03 = false;
                                                            isChecked1_04 = false;
                                                            RespuestaPreg_01 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked1_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked1_03 = true;
                                                            isChecked1_01 = false;
                                                            isChecked1_02 = false;
                                                            isChecked1_04 = false;
                                                            RespuestaPreg_01 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked1_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked1_04 = true;
                                                            isChecked1_01 = false;
                                                            isChecked1_02 = false;
                                                            isChecked1_03 = false;
                                                            RespuestaPreg_01 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'II. Explica y demuestra a la vez en orden y con claridad los pasos o etapas de la labor.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked2_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked2_01 = true;
                                                            isChecked2_02 = false;
                                                            isChecked2_03 = false;
                                                            isChecked2_04 = false;
                                                            RespuestaPreg_02 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked2_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked2_02 = true;
                                                            isChecked2_01 = false;
                                                            isChecked2_03 = false;
                                                            isChecked2_04 = false;
                                                            RespuestaPreg_02 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked2_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked2_03 = true;
                                                            isChecked2_01 = false;
                                                            isChecked2_02 = false;
                                                            isChecked2_04 = false;
                                                            RespuestaPreg_02 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked2_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked2_04 = true;
                                                            isChecked2_01 = false;
                                                            isChecked2_02 = false;
                                                            isChecked2_03 = false;
                                                            RespuestaPreg_02 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'III. Enuncia con orden y claridad los parámetros de calidad o indicadores de la labor que realizan.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked3_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked3_01 = true;
                                                            isChecked3_02 = false;
                                                            isChecked3_03 = false;
                                                            isChecked3_04 = false;
                                                            RespuestaPreg_03 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked3_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked3_02 = true;
                                                            isChecked3_01 = false;
                                                            isChecked3_03 = false;
                                                            isChecked3_04 = false;
                                                            RespuestaPreg_03 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked3_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked3_03 = true;
                                                            isChecked3_01 = false;
                                                            isChecked3_02 = false;
                                                            isChecked3_04 = false;
                                                            RespuestaPreg_03 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked3_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked3_04 = true;
                                                            isChecked3_01 = false;
                                                            isChecked3_02 = false;
                                                            isChecked3_03 = false;
                                                            RespuestaPreg_03 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'IV. Narra una situación desde la perspectiva de otra persona.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked4_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked4_01 = true;
                                                            isChecked4_02 = false;
                                                            isChecked4_03 = false;
                                                            isChecked4_04 = false;
                                                            RespuestaPreg_04 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked4_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked4_02 = true;
                                                            isChecked4_01 = false;
                                                            isChecked4_03 = false;
                                                            isChecked4_04 = false;
                                                            RespuestaPreg_04 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked4_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked4_03 = true;
                                                            isChecked4_01 = false;
                                                            isChecked4_02 = false;
                                                            isChecked4_04 = false;
                                                            RespuestaPreg_04 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked4_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked4_04 = true;
                                                            isChecked4_01 = false;
                                                            isChecked4_02 = false;
                                                            isChecked4_03 = false;
                                                            RespuestaPreg_04 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'V. Identifica el rendimiento de sus colaboradores y los ubica en las áreas adecuadas.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked5_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked5_01 = true;
                                                            isChecked5_02 = false;
                                                            isChecked5_03 = false;
                                                            isChecked5_04 = false;
                                                            RespuestaPreg_05 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked5_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked5_02 = true;
                                                            isChecked5_01 = false;
                                                            isChecked5_03 = false;
                                                            isChecked5_04 = false;
                                                            RespuestaPreg_05 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked5_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked5_03 = true;
                                                            isChecked5_01 = false;
                                                            isChecked5_02 = false;
                                                            isChecked5_04 = false;
                                                            RespuestaPreg_05 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked5_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked5_04 = true;
                                                            isChecked5_01 = false;
                                                            isChecked5_02 = false;
                                                            isChecked5_03 = false;
                                                            RespuestaPreg_05 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'VI. Comenta cómo se sentiría la otra persona en una situación imaginaria.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked6_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked6_01 = true;
                                                            isChecked6_02 = false;
                                                            isChecked6_03 = false;
                                                            isChecked6_04 = false;
                                                            RespuestaPreg_06 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked6_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked6_02 = true;
                                                            isChecked6_01 = false;
                                                            isChecked6_03 = false;
                                                            isChecked6_04 = false;
                                                            RespuestaPreg_06 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked6_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked6_03 = true;
                                                            isChecked6_01 = false;
                                                            isChecked6_02 = false;
                                                            isChecked6_04 = false;
                                                            RespuestaPreg_06 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked6_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked6_04 = true;
                                                            isChecked6_01 = false;
                                                            isChecked6_02 = false;
                                                            isChecked6_03 = false;
                                                            RespuestaPreg_06 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'VII. Brinda ordenes con voz clara, alta y con energía.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked7_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked7_01 = true;
                                                            isChecked7_02 = false;
                                                            isChecked7_03 = false;
                                                            isChecked7_04 = false;
                                                            RespuestaPreg_07 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked7_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked7_02 = true;
                                                            isChecked7_01 = false;
                                                            isChecked7_03 = false;
                                                            isChecked7_04 = false;
                                                            RespuestaPreg_07 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked7_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked7_03 = true;
                                                            isChecked7_01 = false;
                                                            isChecked7_02 = false;
                                                            isChecked7_04 = false;
                                                            RespuestaPreg_07 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked7_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked7_04 = true;
                                                            isChecked7_01 = false;
                                                            isChecked7_02 = false;
                                                            isChecked7_03 = false;
                                                            RespuestaPreg_07 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('VIII. Enseña a los demás por iniciativa propia.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked8_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked8_01 = true;
                                                            isChecked8_02 = false;
                                                            isChecked8_03 = false;
                                                            isChecked8_04 = false;
                                                            RespuestaPreg_08 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked8_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked8_02 = true;
                                                            isChecked8_01 = false;
                                                            isChecked8_03 = false;
                                                            isChecked8_04 = false;
                                                            RespuestaPreg_08 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked8_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked8_03 = true;
                                                            isChecked8_01 = false;
                                                            isChecked8_02 = false;
                                                            isChecked8_04 = false;
                                                            RespuestaPreg_08 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked8_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked8_04 = true;
                                                            isChecked8_01 = false;
                                                            isChecked8_02 = false;
                                                            isChecked8_03 = false;
                                                            RespuestaPreg_08 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('IX. Las personas lo buscan para resolver sus dudas.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked9_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked9_01 = true;
                                                            isChecked9_02 = false;
                                                            isChecked9_03 = false;
                                                            isChecked9_04 = false;
                                                            RespuestaPreg_09 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked9_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked9_02 = true;
                                                            isChecked9_01 = false;
                                                            isChecked9_03 = false;
                                                            isChecked9_04 = false;
                                                            RespuestaPreg_09 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked9_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked9_03 = true;
                                                            isChecked9_01 = false;
                                                            isChecked9_02 = false;
                                                            isChecked9_04 = false;
                                                            RespuestaPreg_09 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked9_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked9_04 = true;
                                                            isChecked9_01 = false;
                                                            isChecked9_02 = false;
                                                            isChecked9_03 = false;
                                                            RespuestaPreg_09 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'X. Trata a las personas con respeto, sin levantar la voz ni molestarse',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked10_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked10_01 = true;
                                                            isChecked10_02 = false;
                                                            isChecked10_03 = false;
                                                            isChecked10_04 = false;
                                                            RespuestaPreg_10 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked10_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked10_02 = true;
                                                            isChecked10_01 = false;
                                                            isChecked10_03 = false;
                                                            isChecked10_04 = false;
                                                            RespuestaPreg_10 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked10_03,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked10_03 = true;
                                                            isChecked10_01 = false;
                                                            isChecked10_02 = false;
                                                            isChecked10_04 = false;
                                                            RespuestaPreg_10 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked10_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked10_04 = true;
                                                            isChecked10_01 = false;
                                                            isChecked10_02 = false;
                                                            isChecked10_03 = false;
                                                            RespuestaPreg_10 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('XI. Emite sus ideas de forma estructurada y lógica.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt1),
                                                        value: isChecked11_01,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked11_01 = true;
                                                            isChecked11_02 = false;
                                                            isChecked11_03_1 = false;
                                                            isChecked11_04 = false;
                                                            RespuestaPreg_11 = 1;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt1_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //  mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt2),
                                                        value: isChecked11_02,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked11_02 = true;
                                                            isChecked11_01 = false;
                                                            isChecked11_03_1 = false;
                                                            isChecked11_04 = false;
                                                            RespuestaPreg_11 = 2;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt2_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              ///mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt3),
                                                        value: isChecked11_03_1,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked11_03_1 = true;
                                                            isChecked11_01 = false;
                                                            isChecked11_02 = false;
                                                            isChecked11_04 = false;
                                                            RespuestaPreg_11 = 3;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt3_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            new Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  child: Row(
                                                    children: <Widget>[
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        fillColor:
                                                        MaterialStateProperty.resolveWith(
                                                            getColorOpt4),
                                                        value: isChecked11_04,
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isChecked11_04 = true;
                                                            isChecked11_01 = false;
                                                            isChecked11_02 = false;
                                                            isChecked11_03_1 = false;
                                                            RespuestaPreg_11 = 4;
                                                          });
                                                        },
                                                      ),
                                                      Text(textOpt4_,
                                                          style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ])),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.010),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Observaciones:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15)),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            controller:txtObservaciones,
                                            //textInputAction:TextInputAction.send,
                                            decoration:const InputDecoration(
                                              hintText:'Ingrese Observación',
                                            ),
                                            maxLines: 3, // <-- SEE HERE
                                            minLines: 3,
                                            textAlign:TextAlign.left,
                                            style: TextStyle(fontSize:15),
                                            onChanged: (text) {
                                              //print('First text field: $text');
                                              //var long2 = double.parse('$text');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    MaterialButton(
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      disabledColor: Primary.azul,
                      elevation: 0,
                      color: Primary.azul,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text("Registrar",
                            style: TextStyle(
                                color: Primary.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ),
                      onPressed: () async {
                        //            EasyLoading.init();

                        bool validate = true;

                        if (RespuestaPreg_01 == 0) {
                          validate = false;
                          showExitPopup("1");
                        } else if (RespuestaPreg_02 == 0) {
                          validate = false;
                          showExitPopup("2");
                        } else if (RespuestaPreg_03 == 0) {
                          validate = false;
                          showExitPopup("3");
                        } else if (RespuestaPreg_04 == 0) {
                          validate = false;
                          showExitPopup("4");
                        } else if (RespuestaPreg_05 == 0) {
                          validate = false;
                          showExitPopup("5");
                        } else if (RespuestaPreg_06 == 0) {
                          validate = false;
                          showExitPopup("6");
                        } else if (RespuestaPreg_07 == 0) {
                          validate = false;
                          showExitPopup("7");
                        } else if (RespuestaPreg_08 == 0) {
                          validate = false;
                          showExitPopup("8");
                        } else if (RespuestaPreg_09 == 0) {
                          validate = false;
                          showExitPopup("9");
                        } else if (RespuestaPreg_10 == 0) {
                          validate = false;
                          showExitPopup("10");
                        } else if (RespuestaPreg_11 == 0) {
                          validate = false;
                          showExitPopup("11");
                        }else if (txtObservaciones.text == "") {
                          validate = false;
                          showExitPopup("12");
                        }

                        Map<String, dynamic> _map_respuesta = {
                          "rpta_1": RespuestaPreg_01,
                          "rpta_2": RespuestaPreg_02,
                          "rpta_3": RespuestaPreg_03,
                          "rpta_4": RespuestaPreg_04,
                          "rpta_5": RespuestaPreg_05,
                          "rpta_6": RespuestaPreg_06,
                          "rpta_7": RespuestaPreg_07,
                          "rpta_8": RespuestaPreg_08,
                          "rpta_9": RespuestaPreg_09,
                          "rpta_10": RespuestaPreg_10,
                          "rpta_11": RespuestaPreg_11,
                        };

                        if (validate == true) {
                          resgitrarRespuestas(_map_respuesta,txtObservaciones.text.toString());
                        }
                      },
                    ),

                    SizedBox(height: 5),
                  ],

                )

            )
            //shrinkWrap: true,

          ),

        )
    );
  }
}

class SelectCapacitacion extends StatefulWidget {
  final String dni_sesion;
  final String dni_trabajador;
  final String nombres_trabajador;
  final String dni_jefe;
  final String nombres_jefe;
  final String escuela;
  final String unidad;
  final String canal;

  const SelectCapacitacion(
      this.dni_sesion,
      this.dni_trabajador,
      this.nombres_trabajador,
      this.dni_jefe,
      this.nombres_jefe,
      this.escuela,
      this.unidad,
      this.canal);

  @override
  _SelectCapacitacionState createState() => _SelectCapacitacionState();
}

class _SelectCapacitacionState extends State<SelectCapacitacion> {
  String error = "";
  bool isLoading = false;
  bool isError = false;
  bool isSuccess = false;

  bool isVistaCap1 = true;
  bool isVistaCap2 = false;
  bool isVistaCap3 = false;
  bool isVistaCap4 = false;
  bool isVistaCap5 = false;

  //Fila Pregunta 01;
  bool isChecked1_01 = false;
  bool isChecked1_02 = false;
  bool isChecked1_03 = false;
  bool isChecked1_04 = false;

  //Fila Pregunta 02;
  bool isChecked2_01 = false;
  bool isChecked2_02 = false;
  bool isChecked2_03 = false;
  bool isChecked2_04 = false;

  //Fila Pregunta 03;
  bool isChecked3_01 = false;
  bool isChecked3_02 = false;
  bool isChecked3_03 = false;
  bool isChecked3_04 = false;

  //Fila Pregunta 04;
  bool isChecked4_01 = false;
  bool isChecked4_02 = false;
  bool isChecked4_03 = false;
  bool isChecked4_04 = false;

  //Fila Pregunta 05;
  bool isChecked5_01 = false;
  bool isChecked5_02 = false;
  bool isChecked5_03 = false;
  bool isChecked5_04 = false;

  //Fila Pregunta 06;
  bool isChecked6_01 = false;
  bool isChecked6_02 = false;
  bool isChecked6_03 = false;
  bool isChecked6_04 = false;

  String gender = 'hombre';
  int correctScore = 0;

  int RespuestaPreg_01 = 0;
  int RespuestaPreg_02 = 0;
  int RespuestaPreg_03 = 0;
  int RespuestaPreg_04 = 0;
  int RespuestaPreg_05 = 0;
  int RespuestaPreg_06 = 0;

  List<String> capacitacionLid = [
    'Liderazgo Capacitación 1',
    'Liderazgo Capacitación 2',
    'Liderazgo Capacitación 3',
    'Inteligencia Emocional Capacitación 4',
    'Inteligencia Emocional Capacitación 5'
  ];
  String? capacitacionlidSelected = 'Liderazgo Capacitación 1';

  void reiniciarValores() {
    RespuestaPreg_01 = 0;
    RespuestaPreg_02 = 0;
    RespuestaPreg_03 = 0;
    RespuestaPreg_04 = 0;
    RespuestaPreg_05 = 0;
    RespuestaPreg_06 = 0;

    isChecked1_01 = false;
    isChecked1_02 = false;
    isChecked1_03 = false;
    isChecked1_04 = false;

    isChecked2_01 = false;
    isChecked2_02 = false;
    isChecked2_03 = false;
    isChecked2_04 = false;

    isChecked3_01 = false;
    isChecked3_02 = false;
    isChecked3_03 = false;
    isChecked3_04 = false;

    isChecked4_01 = false;
    isChecked4_02 = false;
    isChecked4_03 = false;
    isChecked4_04 = false;

    isChecked5_01 = false;
    isChecked5_02 = false;
    isChecked5_03 = false;
    isChecked5_04 = false;

    isChecked6_01 = false;
    isChecked6_02 = false;
    isChecked6_03 = false;
    isChecked6_04 = false;
  }

  Future<bool> showExitPopup(String pregunta) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (context) => AlertDialog(
            title: Text("Completar respuesta",
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 6.0,
                )),
            content: Text("Revisar pregunta N°. " + pregunta),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text("OK"),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<bool> showDialogoRegistro() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
            Navigator.pushReplacementNamed(context, 'registroPacking');

          });
          return AlertDialog(
            title: Text('Mensaje',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
            //content: Text("Actualización exitosa",textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  //  Text('This is a demo alert dialog.'),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 33.0,
                  ),
                  Text("Registro exitoso",textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }) ??
        false; //if showDialouge had returned null, then return false
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future datosSeleccion() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    Color getColorOpt1(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    Color getColorOpt2(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.orangeAccent;
    }

    Color getColorOpt3(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.lime;
    }

    Color getColorOpt4(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }

    final textOpt1_ = " No sabe que tiene que hacerlo.";
    final textOpt2_ = " Lo sabe, pero no lo hace.";
    final textOpt3_ = " Lo hace con esfuerzo.";
    final textOpt4_ = " Lo hace de manera natural.";

    String vr_dni_logeado = widget.dni_sesion;
    String vr_dni_trabajdor = widget.dni_trabajador;
    String vr_nombres_trabajador = widget.nombres_trabajador;
    String vr_dni_jefe = widget.dni_jefe;
    String vr_nombres_jefe = widget.nombres_jefe;
    String vr_escuela = widget.escuela;
    String vr_unidad = widget.unidad;
    String vr_canal = widget.canal;

    Future<void> resgitrarRespuestas(
        Map<String, dynamic> _map_respuesta, String vr_tipo_concepto) async {
      final fechaActual = DateFormat("yyyy-MM-dd").format(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .parseUTC(DateTime.now().toString())
              .toUtc());

      final HoraActual = DateFormat("HH:mm:ss").format(
          DateFormat("yyyy-MM-dd HH:mm:ss")
              .parseUTC(DateTime.now().toString())
              .toUtc());

      final objResultado = new Resultado_Model(
          fecha: fechaActual,
          hora: HoraActual,
          type_evaluacion: 'PACKING',
          dni_evaluador: vr_dni_logeado,
          dni_trabajador: vr_dni_trabajdor,
          nombres_trabajador: vr_nombres_trabajador,
          dni_jefe: vr_dni_jefe,
          nombres_jefe: vr_nombres_jefe,
          etapa: "",
          campo: "",
          escuela: vr_escuela,
          unidad: vr_unidad,
          name_categoria: "CAPACITACIÓN",
          concepto: "CAPACITACIÓN",
          tipo_concepto: vr_tipo_concepto,
          canal: vr_canal,
          estado: '1',
          capacitacion: '0',
          observacion_seguimiento: ''
      );

      final codigoResultado = await DBProvider.db.nuevoResultado(objResultado);

      for (var i = 0; i < _map_respuesta.length; i++) {
        int respuesta = _map_respuesta["rpta_" + (i + 1).toString()];
        final objDetalleResultado = new DetalleResultado_Model(
            id_pregunta: ((i + 1)).toString(),
            idresultado: codigoResultado.toString(),
            respuesta: (respuesta).toString());
        DBProvider.db.nuevoDetalleResultado(objDetalleResultado);
      }

      Navigator.of(context).pop();
      showDialogoRegistro();

      EasyLoading.addStatusCallback((status) {
        print('EasyLoading Status $status');
      });
    }

    return Container(
        child: Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                    Container(
                      alignment: Alignment.centerLeft,
                      child:Text('Autoevaluación de colaborador',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color:Colors.blue, fontWeight: FontWeight.normal,fontSize: 16,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                          )),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.004),
                    DropdownButton(
                      isExpanded: true,
                      value: capacitacionlidSelected,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          capacitacionlidSelected = newValue;
                        });
                        reiniciarValores();
                        if (capacitacionlidSelected ==
                            "Liderazgo Capacitación 1") {
                          setState(() => {
                                isVistaCap1 = true,
                                isVistaCap2 = false,
                                isVistaCap3 = false,
                                isVistaCap4 = false,
                                isVistaCap5 = false,
                              });
                        } else if (capacitacionlidSelected ==
                            "Liderazgo Capacitación 2") {
                          setState(() => {
                                isVistaCap1 = false,
                                isVistaCap2 = true,
                                isVistaCap3 = false,
                                isVistaCap4 = false,
                                isVistaCap5 = false,
                              });
                        } else if (capacitacionlidSelected ==
                            "Liderazgo Capacitación 3") {
                          setState(() => {
                                isVistaCap1 = false,
                                isVistaCap2 = false,
                                isVistaCap3 = true,
                                isVistaCap4 = false,
                                isVistaCap5 = false,
                              });
                        } else if (capacitacionlidSelected ==
                            "Inteligencia Emocional Capacitación 4") {
                          setState(() => {
                                isVistaCap1 = false,
                                isVistaCap2 = false,
                                isVistaCap3 = false,
                                isVistaCap4 = true,
                                isVistaCap5 = false,
                              });
                        } else if (capacitacionlidSelected ==
                            "Inteligencia Emocional Capacitación 5") {
                          setState(() => {
                                isVistaCap1 = false,
                                isVistaCap2 = false,
                                isVistaCap3 = false,
                                isVistaCap4 = false,
                                isVistaCap5 = true,
                              });
                        }
                      },
                      items: capacitacionLid.map((category) {
                        return DropdownMenuItem(
                          child: Text(category),
                          value: category,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Center(
          child: isVistaCap1
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      // CUESTIONARIO CAPACITACÓN 01
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'I. Cuando escucho, miro a los ojos de la persona que me habla.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt1),
                                                      value: isChecked1_01,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked1_01 = true;
                                                          isChecked1_02 = false;
                                                          isChecked1_03 = false;
                                                          isChecked1_04 = false;
                                                          RespuestaPreg_01 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt2),
                                                      value: isChecked1_02,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked1_02 = true;
                                                          isChecked1_01 = false;
                                                          isChecked1_03 = false;
                                                          isChecked1_04 = false;
                                                          RespuestaPreg_01 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            ///mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt3),
                                                      value: isChecked1_03,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked1_03 = true;
                                                          isChecked1_01 = false;
                                                          isChecked1_02 = false;
                                                          isChecked1_04 = false;
                                                          RespuestaPreg_01 = 3;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt3_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt4),
                                                      value: isChecked1_04,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked1_04 = true;
                                                          isChecked1_01 = false;
                                                          isChecked1_02 = false;
                                                          isChecked1_03 = false;
                                                          RespuestaPreg_01 = 4;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt4_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.010),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'II. Cuando escucho, presto atención, y no hago otras cosas, demostrando respeto.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt1),
                                                      value: isChecked2_01,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked2_01 = true;
                                                          isChecked2_02 = false;
                                                          isChecked2_03 = false;
                                                          isChecked2_04 = false;
                                                          RespuestaPreg_02 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt2),
                                                      value: isChecked2_02,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked2_02 = true;
                                                          isChecked2_01 = false;
                                                          isChecked2_03 = false;
                                                          isChecked2_04 = false;
                                                          RespuestaPreg_02 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            ///mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt3),
                                                      value: isChecked2_03,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked2_03 = true;
                                                          isChecked2_01 = false;
                                                          isChecked2_02 = false;
                                                          isChecked2_04 = false;
                                                          RespuestaPreg_02 = 3;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt3_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt4),
                                                      value: isChecked2_04,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked2_04 = true;
                                                          isChecked2_01 = false;
                                                          isChecked2_02 = false;
                                                          isChecked2_03 = false;
                                                          RespuestaPreg_02 = 4;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt4_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.010),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'III. Cuando escucho, le hago preguntas para comprender mejor.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt1),
                                                      value: isChecked3_01,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked3_01 = true;
                                                          isChecked3_02 = false;
                                                          isChecked3_03 = false;
                                                          isChecked3_04 = false;
                                                          RespuestaPreg_03 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt2),
                                                      value: isChecked3_02,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked3_02 = true;
                                                          isChecked3_01 = false;
                                                          isChecked3_03 = false;
                                                          isChecked3_04 = false;
                                                          RespuestaPreg_03 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            ///mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt3),
                                                      value: isChecked3_03,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked3_03 = true;
                                                          isChecked3_01 = false;
                                                          isChecked3_02 = false;
                                                          isChecked3_04 = false;
                                                          RespuestaPreg_03 = 3;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt3_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt4),
                                                      value: isChecked3_04,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked3_04 = true;
                                                          isChecked3_01 = false;
                                                          isChecked3_02 = false;
                                                          isChecked3_03 = false;
                                                          RespuestaPreg_03 = 4;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt4_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.010),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'IV. Cuando converso, identifico la emoción de la otra persona y se la digo amablemente.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt1),
                                                      value: isChecked4_01,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked4_01 = true;
                                                          isChecked4_02 = false;
                                                          isChecked4_03 = false;
                                                          isChecked4_04 = false;
                                                          RespuestaPreg_04 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt2),
                                                      value: isChecked4_02,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked4_02 = true;
                                                          isChecked4_01 = false;
                                                          isChecked4_03 = false;
                                                          isChecked4_04 = false;
                                                          RespuestaPreg_04 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            ///mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt3),
                                                      value: isChecked4_03,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked4_03 = true;
                                                          isChecked4_01 = false;
                                                          isChecked4_02 = false;
                                                          isChecked4_04 = false;
                                                          RespuestaPreg_04 = 3;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt3_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt4),
                                                      value: isChecked4_04,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked4_04 = true;
                                                          isChecked4_01 = false;
                                                          isChecked4_02 = false;
                                                          isChecked4_03 = false;
                                                          RespuestaPreg_04 = 4;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt4_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.010),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'V. Al finalizar, yo resumo lo que me dijo para ver si entendí correctamente.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt1),
                                                      value: isChecked5_01,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked5_01 = true;
                                                          isChecked5_02 = false;
                                                          isChecked5_03 = false;
                                                          isChecked5_04 = false;
                                                          RespuestaPreg_05 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt2),
                                                      value: isChecked5_02,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked5_02 = true;
                                                          isChecked5_01 = false;
                                                          isChecked5_03 = false;
                                                          isChecked5_04 = false;
                                                          RespuestaPreg_05 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            ///mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt3),
                                                      value: isChecked5_03,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked5_03 = true;
                                                          isChecked5_01 = false;
                                                          isChecked5_02 = false;
                                                          isChecked5_04 = false;
                                                          RespuestaPreg_05 = 3;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt3_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt4),
                                                      value: isChecked5_04,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked5_04 = true;
                                                          isChecked5_01 = false;
                                                          isChecked5_02 = false;
                                                          isChecked5_03 = false;
                                                          RespuestaPreg_05 = 4;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt4_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.010),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'VI. Cuando me cuentan un problema, no le echo la culpa a alguien, sino busco cuál va a ser la solución..',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt1),
                                                      value: isChecked6_01,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked6_01 = true;
                                                          isChecked6_02 = false;
                                                          isChecked6_03 = false;
                                                          isChecked6_04 = false;
                                                          RespuestaPreg_06 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //  mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt2),
                                                      value: isChecked6_02,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked6_02 = true;
                                                          isChecked6_01 = false;
                                                          isChecked6_03 = false;
                                                          isChecked6_04 = false;
                                                          RespuestaPreg_06 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            ///mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt3),
                                                      value: isChecked6_03,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked6_03 = true;
                                                          isChecked6_01 = false;
                                                          isChecked6_02 = false;
                                                          isChecked6_04 = false;
                                                          RespuestaPreg_06 = 3;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt3_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5),
                                          new Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: Row(
                                                  children: <Widget>[
                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getColorOpt4),
                                                      value: isChecked6_04,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked6_04 = true;
                                                          isChecked6_01 = false;
                                                          isChecked6_02 = false;
                                                          isChecked6_03 = false;
                                                          RespuestaPreg_06 = 4;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt4_,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ])),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // BOTON REGISTRAR
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025),

                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        disabledColor: Primary.azul,
                        elevation: 0,
                        color: Primary.azul,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Text("Registrar",
                              style: TextStyle(
                                  color: Primary.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                        ),
                        onPressed: () async {
                          //            EasyLoading.init();

                          bool validate = true;

                          if (RespuestaPreg_01 == 0) {
                            validate = false;
                            showExitPopup("1");
                          } else if (RespuestaPreg_02 == 0) {
                            validate = false;
                            showExitPopup("2");
                          } else if (RespuestaPreg_03 == 0) {
                            validate = false;
                            showExitPopup("3");
                          } else if (RespuestaPreg_04 == 0) {
                            validate = false;
                            showExitPopup("4");
                          } else if (RespuestaPreg_05 == 0) {
                            validate = false;
                            showExitPopup("5");
                          } else if (RespuestaPreg_06 == 0) {
                            validate = false;
                            showExitPopup("6");
                          }
                          Map<String, dynamic> _map_respuesta = {
                            "rpta_1": RespuestaPreg_01,
                            "rpta_2": RespuestaPreg_02,
                            "rpta_3": RespuestaPreg_03,
                            "rpta_4": RespuestaPreg_04,
                            "rpta_5": RespuestaPreg_05,
                            "rpta_6": RespuestaPreg_06,
                          };

                          if (validate == true) {
                            resgitrarRespuestas(_map_respuesta,
                                capacitacionlidSelected.toString());
                          }
                        },
                      )
                    ],
                  ),
                )
              : isVistaCap2
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'I. Cuando doy la pauta, explico y demuestro cómo se hace, para que los trabajadores miren y escuchen.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                          value: isChecked1_01,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked1_01 =
                                                                  true;
                                                              isChecked1_02 =
                                                                  false;
                                                              isChecked1_03 =
                                                                  false;
                                                              isChecked1_04 =
                                                                  false;
                                                              RespuestaPreg_01 =
                                                                  1;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt1_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                          value: isChecked1_02,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked1_02 =
                                                                  true;
                                                              isChecked1_01 =
                                                                  false;
                                                              isChecked1_03 =
                                                                  false;
                                                              isChecked1_04 =
                                                                  false;
                                                              RespuestaPreg_01 =
                                                                  2;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt2_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                ///mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                          value: isChecked1_03,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked1_03 =
                                                                  true;
                                                              isChecked1_01 =
                                                                  false;
                                                              isChecked1_02 =
                                                                  false;
                                                              isChecked1_04 =
                                                                  false;
                                                              RespuestaPreg_01 =
                                                                  3;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                          value: isChecked1_04,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked1_04 =
                                                                  true;
                                                              isChecked1_01 =
                                                                  false;
                                                              isChecked1_02 =
                                                                  false;
                                                              isChecked1_03 =
                                                                  false;
                                                              RespuestaPreg_01 =
                                                                  4;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.010),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'II. Uso palabras precisas para ayudarlos a comprender cómo se hace la labor.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                          value: isChecked2_01,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked2_01 =
                                                                  true;
                                                              isChecked2_02 =
                                                                  false;
                                                              isChecked2_03 =
                                                                  false;
                                                              isChecked2_04 =
                                                                  false;
                                                              RespuestaPreg_02 =
                                                                  1;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt1_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                          value: isChecked2_02,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked2_02 =
                                                                  true;
                                                              isChecked2_01 =
                                                                  false;
                                                              isChecked2_03 =
                                                                  false;
                                                              isChecked2_04 =
                                                                  false;
                                                              RespuestaPreg_02 =
                                                                  2;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt2_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                ///mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                          value: isChecked2_03,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked2_03 =
                                                                  true;
                                                              isChecked2_01 =
                                                                  false;
                                                              isChecked2_02 =
                                                                  false;
                                                              isChecked2_04 =
                                                                  false;
                                                              RespuestaPreg_02 =
                                                                  3;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                          value: isChecked2_04,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked2_04 =
                                                                  true;
                                                              isChecked2_01 =
                                                                  false;
                                                              isChecked2_02 =
                                                                  false;
                                                              isChecked2_03 =
                                                                  false;
                                                              RespuestaPreg_02 =
                                                                  4;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.010),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'III. Pido a 2 o 3 trabajadores que expliquen y demuestran la pauta a los demás, para asegurarme que comprendieron.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                          value: isChecked3_01,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked3_01 =
                                                                  true;
                                                              isChecked3_02 =
                                                                  false;
                                                              isChecked3_03 =
                                                                  false;
                                                              isChecked3_04 =
                                                                  false;
                                                              RespuestaPreg_03 =
                                                                  1;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt1_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                          value: isChecked3_02,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked3_02 =
                                                                  true;
                                                              isChecked3_01 =
                                                                  false;
                                                              isChecked3_03 =
                                                                  false;
                                                              isChecked3_04 =
                                                                  false;
                                                              RespuestaPreg_03 =
                                                                  2;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt2_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                ///mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                          value: isChecked3_03,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked3_03 =
                                                                  true;
                                                              isChecked3_01 =
                                                                  false;
                                                              isChecked3_02 =
                                                                  false;
                                                              isChecked3_04 =
                                                                  false;
                                                              RespuestaPreg_03 =
                                                                  3;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                          value: isChecked3_04,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked3_04 =
                                                                  true;
                                                              isChecked3_01 =
                                                                  false;
                                                              isChecked3_02 =
                                                                  false;
                                                              isChecked3_03 =
                                                                  false;
                                                              RespuestaPreg_03 =
                                                                  4;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.010),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'IV. Pido que me muestren ejemplos de la pauta, para asegurarme que comprendieron.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                          value: isChecked4_01,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked4_01 =
                                                                  true;
                                                              isChecked4_02 =
                                                                  false;
                                                              isChecked4_03 =
                                                                  false;
                                                              isChecked4_04 =
                                                                  false;
                                                              RespuestaPreg_04 =
                                                                  1;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt1_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                          value: isChecked4_02,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked4_02 =
                                                                  true;
                                                              isChecked4_01 =
                                                                  false;
                                                              isChecked4_03 =
                                                                  false;
                                                              isChecked4_04 =
                                                                  false;
                                                              RespuestaPreg_04 =
                                                                  2;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt2_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                ///mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                          value: isChecked4_03,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked4_03 =
                                                                  true;
                                                              isChecked4_01 =
                                                                  false;
                                                              isChecked4_02 =
                                                                  false;
                                                              isChecked4_04 =
                                                                  false;
                                                              RespuestaPreg_04 =
                                                                  3;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                          value: isChecked4_04,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked4_04 =
                                                                  true;
                                                              isChecked4_01 =
                                                                  false;
                                                              isChecked4_02 =
                                                                  false;
                                                              isChecked4_03 =
                                                                  false;
                                                              RespuestaPreg_04 =
                                                                  4;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.010),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'V. Cuando reviso su avance, primero le digo lo que ha hecho de forma correcta y lo felicito. Luego lo ayudo a darse cuenta lo que le falta hacer.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                          value: isChecked5_01,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked5_01 =
                                                                  true;
                                                              isChecked5_02 =
                                                                  false;
                                                              isChecked5_03 =
                                                                  false;
                                                              isChecked5_04 =
                                                                  false;
                                                              RespuestaPreg_05 =
                                                                  1;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt1_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                          value: isChecked5_02,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked5_02 =
                                                                  true;
                                                              isChecked5_01 =
                                                                  false;
                                                              isChecked5_03 =
                                                                  false;
                                                              isChecked5_04 =
                                                                  false;
                                                              RespuestaPreg_05 =
                                                                  2;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt2_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                ///mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                          value: isChecked5_03,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked5_03 =
                                                                  true;
                                                              isChecked5_01 =
                                                                  false;
                                                              isChecked5_02 =
                                                                  false;
                                                              isChecked5_04 =
                                                                  false;
                                                              RespuestaPreg_05 =
                                                                  3;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                          value: isChecked5_04,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked5_04 =
                                                                  true;
                                                              isChecked5_01 =
                                                                  false;
                                                              isChecked5_02 =
                                                                  false;
                                                              isChecked5_03 =
                                                                  false;
                                                              RespuestaPreg_05 =
                                                                  4;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.010),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'VI. Trato a cada trabajador con respeto, hablándole con paciencia, con buenas palabras y sin ofenderlo.',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                          value: isChecked6_01,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked6_01 =
                                                                  true;
                                                              isChecked6_02 =
                                                                  false;
                                                              isChecked6_03 =
                                                                  false;
                                                              isChecked6_04 =
                                                                  false;
                                                              RespuestaPreg_06 =
                                                                  1;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt1_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //  mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                          value: isChecked6_02,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked6_02 =
                                                                  true;
                                                              isChecked6_01 =
                                                                  false;
                                                              isChecked6_03 =
                                                                  false;
                                                              isChecked6_04 =
                                                                  false;
                                                              RespuestaPreg_06 =
                                                                  2;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt2_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                ///mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                          value: isChecked6_03,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked6_03 =
                                                                  true;
                                                              isChecked6_01 =
                                                                  false;
                                                              isChecked6_02 =
                                                                  false;
                                                              isChecked6_04 =
                                                                  false;
                                                              RespuestaPreg_06 =
                                                                  3;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 5),
                                              new Row(
                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Checkbox(
                                                          checkColor:
                                                              Colors.white,
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                          value: isChecked6_04,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              isChecked6_04 =
                                                                  true;
                                                              isChecked6_01 =
                                                                  false;
                                                              isChecked6_02 =
                                                                  false;
                                                              isChecked6_03 =
                                                                  false;
                                                              RespuestaPreg_06 =
                                                                  4;
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_,
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ])),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // BOTON REGISTRAR
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7)),
                            disabledColor: Primary.azul,
                            elevation: 0,
                            color: Primary.azul,
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text("Registrar",
                                  style: TextStyle(
                                      color: Primary.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17)),
                            ),
                            onPressed: () async {
                              //            EasyLoading.init();

                              bool validate = true;

                              if (RespuestaPreg_01 == 0) {
                                validate = false;
                                showExitPopup("1");
                              } else if (RespuestaPreg_02 == 0) {
                                validate = false;
                                showExitPopup("2");
                              } else if (RespuestaPreg_03 == 0) {
                                validate = false;
                                showExitPopup("3");
                              } else if (RespuestaPreg_04 == 0) {
                                validate = false;
                                showExitPopup("4");
                              } else if (RespuestaPreg_05 == 0) {
                                validate = false;
                                showExitPopup("5");
                              } else if (RespuestaPreg_06 == 0) {
                                validate = false;
                                showExitPopup("6");
                              }

                              Map<String, dynamic> _map_respuesta = {
                                "rpta_1": RespuestaPreg_01,
                                "rpta_2": RespuestaPreg_02,
                                "rpta_3": RespuestaPreg_03,
                                "rpta_4": RespuestaPreg_04,
                                "rpta_5": RespuestaPreg_05,
                                "rpta_6": RespuestaPreg_06,
                              };
                              if (validate == true) {
                                resgitrarRespuestas(_map_respuesta,
                                    capacitacionlidSelected.toString());
                              }
                            },
                          )
                        ],
                      ),
                    )
                  : isVistaCap3
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.68,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'I. Comprendo que yo represento a la empresa en campo, y presento los objetivos y las decisiones desde la empresa.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                              value:
                                                                  isChecked1_01,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked1_01 =
                                                                      true;
                                                                  isChecked1_02 =
                                                                      false;
                                                                  isChecked1_03 =
                                                                      false;
                                                                  isChecked1_04 =
                                                                      false;
                                                                  RespuestaPreg_01 =
                                                                      1;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                              value:
                                                                  isChecked1_02,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked1_02 =
                                                                      true;
                                                                  isChecked1_01 =
                                                                      false;
                                                                  isChecked1_03 =
                                                                      false;
                                                                  isChecked1_04 =
                                                                      false;
                                                                  RespuestaPreg_01 =
                                                                      2;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    ///mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                              value:
                                                                  isChecked1_03,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked1_03 =
                                                                      true;
                                                                  isChecked1_01 =
                                                                      false;
                                                                  isChecked1_02 =
                                                                      false;
                                                                  isChecked1_04 =
                                                                      false;
                                                                  RespuestaPreg_01 =
                                                                      3;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt3_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                              value:
                                                                  isChecked1_04,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked1_04 =
                                                                      true;
                                                                  isChecked1_01 =
                                                                      false;
                                                                  isChecked1_02 =
                                                                      false;
                                                                  isChecked1_03 =
                                                                      false;
                                                                  RespuestaPreg_01 =
                                                                      4;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt4_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.010),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'II. Al hablar demuestro respeto por las personas y seguridad en mí mismo, logrando que mi equipo confíe en mi.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                              value:
                                                                  isChecked2_01,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked2_01 =
                                                                      true;
                                                                  isChecked2_02 =
                                                                      false;
                                                                  isChecked2_03 =
                                                                      false;
                                                                  isChecked2_04 =
                                                                      false;
                                                                  RespuestaPreg_02 =
                                                                      1;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                              value:
                                                                  isChecked2_02,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked2_02 =
                                                                      true;
                                                                  isChecked2_01 =
                                                                      false;
                                                                  isChecked2_03 =
                                                                      false;
                                                                  isChecked2_04 =
                                                                      false;
                                                                  RespuestaPreg_02 =
                                                                      2;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    ///mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                              value:
                                                                  isChecked2_03,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked2_03 =
                                                                      true;
                                                                  isChecked2_01 =
                                                                      false;
                                                                  isChecked2_02 =
                                                                      false;
                                                                  isChecked2_04 =
                                                                      false;
                                                                  RespuestaPreg_02 =
                                                                      3;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt3_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                              value:
                                                                  isChecked2_04,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked2_04 =
                                                                      true;
                                                                  isChecked2_01 =
                                                                      false;
                                                                  isChecked2_02 =
                                                                      false;
                                                                  isChecked2_03 =
                                                                      false;
                                                                  RespuestaPreg_02 =
                                                                      4;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt4_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.010),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'III. Cuando sucede algún problema, hago preguntas para comprender, y escucho activamente todas las respuestas.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                              value:
                                                                  isChecked3_01,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked3_01 =
                                                                      true;
                                                                  isChecked3_02 =
                                                                      false;
                                                                  isChecked3_03 =
                                                                      false;
                                                                  isChecked3_04 =
                                                                      false;
                                                                  RespuestaPreg_03 =
                                                                      1;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                              value:
                                                                  isChecked3_02,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked3_02 =
                                                                      true;
                                                                  isChecked3_01 =
                                                                      false;
                                                                  isChecked3_03 =
                                                                      false;
                                                                  isChecked3_04 =
                                                                      false;
                                                                  RespuestaPreg_03 =
                                                                      2;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    ///mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                              value:
                                                                  isChecked3_03,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked3_03 =
                                                                      true;
                                                                  isChecked3_01 =
                                                                      false;
                                                                  isChecked3_02 =
                                                                      false;
                                                                  isChecked3_04 =
                                                                      false;
                                                                  RespuestaPreg_03 =
                                                                      3;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt3_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                              value:
                                                                  isChecked3_04,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked3_04 =
                                                                      true;
                                                                  isChecked3_01 =
                                                                      false;
                                                                  isChecked3_02 =
                                                                      false;
                                                                  isChecked3_03 =
                                                                      false;
                                                                  RespuestaPreg_03 =
                                                                      4;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt4_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.010),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'IV. Cuando sucede algún problema, no busco de quien es la culpa, ni los mando a hablar con alguien más. Yo me hago cargo.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                              value:
                                                                  isChecked4_01,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked4_01 =
                                                                      true;
                                                                  isChecked4_02 =
                                                                      false;
                                                                  isChecked4_03 =
                                                                      false;
                                                                  isChecked4_04 =
                                                                      false;
                                                                  RespuestaPreg_04 =
                                                                      1;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                              value:
                                                                  isChecked4_02,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked4_02 =
                                                                      true;
                                                                  isChecked4_01 =
                                                                      false;
                                                                  isChecked4_03 =
                                                                      false;
                                                                  isChecked4_04 =
                                                                      false;
                                                                  RespuestaPreg_04 =
                                                                      2;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    ///mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                              value:
                                                                  isChecked4_03,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked4_03 =
                                                                      true;
                                                                  isChecked4_01 =
                                                                      false;
                                                                  isChecked4_02 =
                                                                      false;
                                                                  isChecked4_04 =
                                                                      false;
                                                                  RespuestaPreg_04 =
                                                                      3;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt3_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                              value:
                                                                  isChecked4_04,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked4_04 =
                                                                      true;
                                                                  isChecked4_01 =
                                                                      false;
                                                                  isChecked4_02 =
                                                                      false;
                                                                  isChecked4_03 =
                                                                      false;
                                                                  RespuestaPreg_04 =
                                                                      4;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt4_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.010),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'V. Cuando sucede algún problema, me enfoco en encontrar una solución con mi equipo, hasta lograr solucionarlo.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                              value:
                                                                  isChecked5_01,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked5_01 =
                                                                      true;
                                                                  isChecked5_02 =
                                                                      false;
                                                                  isChecked5_03 =
                                                                      false;
                                                                  isChecked5_04 =
                                                                      false;
                                                                  RespuestaPreg_05 =
                                                                      1;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                              value:
                                                                  isChecked5_02,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked5_02 =
                                                                      true;
                                                                  isChecked5_01 =
                                                                      false;
                                                                  isChecked5_03 =
                                                                      false;
                                                                  isChecked5_04 =
                                                                      false;
                                                                  RespuestaPreg_05 =
                                                                      2;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    ///mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                              value:
                                                                  isChecked5_03,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked5_03 =
                                                                      true;
                                                                  isChecked5_01 =
                                                                      false;
                                                                  isChecked5_02 =
                                                                      false;
                                                                  isChecked5_04 =
                                                                      false;
                                                                  RespuestaPreg_05 =
                                                                      3;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt3_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                              value:
                                                                  isChecked5_04,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked5_04 =
                                                                      true;
                                                                  isChecked5_01 =
                                                                      false;
                                                                  isChecked5_02 =
                                                                      false;
                                                                  isChecked5_03 =
                                                                      false;
                                                                  RespuestaPreg_05 =
                                                                      4;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt4_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.010),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                            'VI. Si escucho a alguien de mi equipo criticando, quejándose o amenazando, lo llevo aparte con respeto y hablo con esa persona a solas para solucionarlo.',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 4, 0, 0),
                                          alignment: Alignment.centerLeft,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt1),
                                                              value:
                                                                  isChecked6_01,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked6_01 =
                                                                      true;
                                                                  isChecked6_02 =
                                                                      false;
                                                                  isChecked6_03 =
                                                                      false;
                                                                  isChecked6_04 =
                                                                      false;
                                                                  RespuestaPreg_06 =
                                                                      1;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt2),
                                                              value:
                                                                  isChecked6_02,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked6_02 =
                                                                      true;
                                                                  isChecked6_01 =
                                                                      false;
                                                                  isChecked6_03 =
                                                                      false;
                                                                  isChecked6_04 =
                                                                      false;
                                                                  RespuestaPreg_06 =
                                                                      2;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    ///mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt3),
                                                              value:
                                                                  isChecked6_03,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked6_03 =
                                                                      true;
                                                                  isChecked6_01 =
                                                                      false;
                                                                  isChecked6_02 =
                                                                      false;
                                                                  isChecked6_04 =
                                                                      false;
                                                                  RespuestaPreg_06 =
                                                                      3;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt3_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 5),
                                                  new Row(
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              checkColor:
                                                                  Colors.white,
                                                              fillColor: MaterialStateProperty
                                                                  .resolveWith(
                                                                      getColorOpt4),
                                                              value:
                                                                  isChecked6_04,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  isChecked6_04 =
                                                                      true;
                                                                  isChecked6_01 =
                                                                      false;
                                                                  isChecked6_02 =
                                                                      false;
                                                                  isChecked6_03 =
                                                                      false;
                                                                  RespuestaPreg_06 =
                                                                      4;
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt4_,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ])),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // BOTON REGISTRAR
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025),

                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                disabledColor: Primary.azul,
                                elevation: 0,
                                color: Primary.azul,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  child: Text("Registrar",
                                      style: TextStyle(
                                          color: Primary.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17)),
                                ),
                                onPressed: () async {
                                  bool validate = true;

                                  if (RespuestaPreg_01 == 0) {
                                    validate = false;
                                    showExitPopup("1");
                                  } else if (RespuestaPreg_02 == 0) {
                                    validate = false;
                                    showExitPopup("2");
                                  } else if (RespuestaPreg_03 == 0) {
                                    validate = false;
                                    showExitPopup("3");
                                  } else if (RespuestaPreg_04 == 0) {
                                    validate = false;
                                    showExitPopup("4");
                                  } else if (RespuestaPreg_05 == 0) {
                                    validate = false;
                                    showExitPopup("5");
                                  } else if (RespuestaPreg_06 == 0) {
                                    validate = false;
                                    showExitPopup("6");
                                  }

                                  Map<String, dynamic> _map_respuesta = {
                                    "rpta_1": RespuestaPreg_01,
                                    "rpta_2": RespuestaPreg_02,
                                    "rpta_3": RespuestaPreg_03,
                                    "rpta_4": RespuestaPreg_04,
                                    "rpta_5": RespuestaPreg_05,
                                    "rpta_6": RespuestaPreg_06,
                                  };

                                  if (validate == true) {
                                    resgitrarRespuestas(_map_respuesta,
                                        capacitacionlidSelected.toString());
                                  }
                                },
                              )
                            ],
                          ),
                        )
                      : isVistaCap4
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.68,
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'I. Llamo a mis emociones por sus nombres: ira, alegría, tristeza, molestia, frustración, amor, asco, etc.',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 4, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                      new Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt1),
                                                                  value:
                                                                      isChecked1_01,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_01 =
                                                                          true;
                                                                      isChecked1_02 =
                                                                          false;
                                                                      isChecked1_03 =
                                                                          false;
                                                                      isChecked1_04 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt1_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt2),
                                                                  value:
                                                                      isChecked1_02,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_02 =
                                                                          true;
                                                                      isChecked1_01 =
                                                                          false;
                                                                      isChecked1_03 =
                                                                          false;
                                                                      isChecked1_04 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt2_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        ///mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt3),
                                                                  value:
                                                                      isChecked1_03,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_03 =
                                                                          true;
                                                                      isChecked1_01 =
                                                                          false;
                                                                      isChecked1_02 =
                                                                          false;
                                                                      isChecked1_04 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt3_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt4),
                                                                  value:
                                                                      isChecked1_04,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_04 =
                                                                          true;
                                                                      isChecked1_01 =
                                                                          false;
                                                                      isChecked1_02 =
                                                                          false;
                                                                      isChecked1_03 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt4_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.010),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'II. Cuando estoy en una situación difícil, no controlo mis emociones, sino las manejo diciéndolas, a mí o a los demás.',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 4, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                      new Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt1),
                                                                  value:
                                                                      isChecked2_01,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_01 =
                                                                          true;
                                                                      isChecked2_02 =
                                                                          false;
                                                                      isChecked2_03 =
                                                                          false;
                                                                      isChecked2_04 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt1_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt2),
                                                                  value:
                                                                      isChecked2_02,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_02 =
                                                                          true;
                                                                      isChecked2_01 =
                                                                          false;
                                                                      isChecked2_03 =
                                                                          false;
                                                                      isChecked2_04 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt2_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        ///mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt3),
                                                                  value:
                                                                      isChecked2_03,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_03 =
                                                                          true;
                                                                      isChecked2_01 =
                                                                          false;
                                                                      isChecked2_02 =
                                                                          false;
                                                                      isChecked2_04 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt3_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt4),
                                                                  value:
                                                                      isChecked2_04,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_04 =
                                                                          true;
                                                                      isChecked2_01 =
                                                                          false;
                                                                      isChecked2_02 =
                                                                          false;
                                                                      isChecked2_03 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt4_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.010),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'III. Cuando estoy en una situación difícil, identifico qué parte de esa situación me hace sentir así, para poder cambiarla o cambiar yo.',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 4, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                      new Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt1),
                                                                  value:
                                                                      isChecked3_01,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_01 =
                                                                          true;
                                                                      isChecked3_02 =
                                                                          false;
                                                                      isChecked3_03 =
                                                                          false;
                                                                      isChecked3_04 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt1_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt2),
                                                                  value:
                                                                      isChecked3_02,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_02 =
                                                                          true;
                                                                      isChecked3_01 =
                                                                          false;
                                                                      isChecked3_03 =
                                                                          false;
                                                                      isChecked3_04 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt2_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        ///mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt3),
                                                                  value:
                                                                      isChecked3_03,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_03 =
                                                                          true;
                                                                      isChecked3_01 =
                                                                          false;
                                                                      isChecked3_02 =
                                                                          false;
                                                                      isChecked3_04 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt3_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt4),
                                                                  value:
                                                                      isChecked3_04,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_04 =
                                                                          true;
                                                                      isChecked3_01 =
                                                                          false;
                                                                      isChecked3_02 =
                                                                          false;
                                                                      isChecked3_03 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt4_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // BOTON REGISTRAR
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),

                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                    disabledColor: Primary.azul,
                                    elevation: 0,
                                    color: Primary.azul,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Text("Registrar",
                                          style: TextStyle(
                                              color: Primary.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                    ),
                                    onPressed: () async {
                                      //            EasyLoading.init();

                                      bool validate = true;

                                      if (RespuestaPreg_01 == 0) {
                                        validate = false;
                                        showExitPopup("1");
                                      } else if (RespuestaPreg_02 == 0) {
                                        validate = false;
                                        showExitPopup("2");
                                      } else if (RespuestaPreg_03 == 0) {
                                        validate = false;
                                        showExitPopup("3");
                                      }

                                      Map<String, dynamic> _map_respuesta = {
                                        "rpta_1": RespuestaPreg_01,
                                        "rpta_2": RespuestaPreg_02,
                                        "rpta_3": RespuestaPreg_03,
                                      };

                                      if (validate == true) {
                                        resgitrarRespuestas(_map_respuesta,
                                            capacitacionlidSelected.toString());
                                      }
                                    },
                                  )
                                ],
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.68,
                              child: ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'I. Me levanto de la cama de buen humor, diciéndome: "éste será un buen día".',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 4, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                      new Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt1),
                                                                  value:
                                                                      isChecked1_01,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_01 =
                                                                          true;
                                                                      isChecked1_02 =
                                                                          false;
                                                                      isChecked1_03 =
                                                                          false;
                                                                      isChecked1_04 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt1_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt2),
                                                                  value:
                                                                      isChecked1_02,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_02 =
                                                                          true;
                                                                      isChecked1_01 =
                                                                          false;
                                                                      isChecked1_03 =
                                                                          false;
                                                                      isChecked1_04 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt2_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        ///mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt3),
                                                                  value:
                                                                      isChecked1_03,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_03 =
                                                                          true;
                                                                      isChecked1_01 =
                                                                          false;
                                                                      isChecked1_02 =
                                                                          false;
                                                                      isChecked1_04 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt3_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt4),
                                                                  value:
                                                                      isChecked1_04,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked1_04 =
                                                                          true;
                                                                      isChecked1_01 =
                                                                          false;
                                                                      isChecked1_02 =
                                                                          false;
                                                                      isChecked1_03 =
                                                                          false;
                                                                      RespuestaPreg_01 =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt4_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.010),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'II. Cuando sucede un problema, me enfoco en encontrar la solución, no busco culpables.',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 4, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                      new Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt1),
                                                                  value:
                                                                      isChecked2_01,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_01 =
                                                                          true;
                                                                      isChecked2_02 =
                                                                          false;
                                                                      isChecked2_03 =
                                                                          false;
                                                                      isChecked2_04 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt1_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt2),
                                                                  value:
                                                                      isChecked2_02,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_02 =
                                                                          true;
                                                                      isChecked2_01 =
                                                                          false;
                                                                      isChecked2_03 =
                                                                          false;
                                                                      isChecked2_04 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt2_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        ///mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt3),
                                                                  value:
                                                                      isChecked2_03,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_03 =
                                                                          true;
                                                                      isChecked2_01 =
                                                                          false;
                                                                      isChecked2_02 =
                                                                          false;
                                                                      isChecked2_04 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt3_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt4),
                                                                  value:
                                                                      isChecked2_04,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked2_04 =
                                                                          true;
                                                                      isChecked2_01 =
                                                                          false;
                                                                      isChecked2_02 =
                                                                          false;
                                                                      isChecked2_03 =
                                                                          false;
                                                                      RespuestaPreg_02 =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt4_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.010),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                                'III. Sé que no puedo manejar las cosas que me suceden, pero manejo positivamente mi reacción a las cosas que me suceden.',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 4, 0, 0),
                                              alignment: Alignment.centerLeft,
                                              child: Row(children: <Widget>[
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                      new Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt1),
                                                                  value:
                                                                      isChecked3_01,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_01 =
                                                                          true;
                                                                      isChecked3_02 =
                                                                          false;
                                                                      isChecked3_03 =
                                                                          false;
                                                                      isChecked3_04 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          1;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt1_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //  mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt2),
                                                                  value:
                                                                      isChecked3_02,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_02 =
                                                                          true;
                                                                      isChecked3_01 =
                                                                          false;
                                                                      isChecked3_03 =
                                                                          false;
                                                                      isChecked3_04 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          2;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt2_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        ///mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt3),
                                                                  value:
                                                                      isChecked3_03,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_03 =
                                                                          true;
                                                                      isChecked3_01 =
                                                                          false;
                                                                      isChecked3_02 =
                                                                          false;
                                                                      isChecked3_04 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          3;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt3_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(width: 5),
                                                      new Row(
                                                        //mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: MaterialStateProperty
                                                                      .resolveWith(
                                                                          getColorOpt4),
                                                                  value:
                                                                      isChecked3_04,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      isChecked3_04 =
                                                                          true;
                                                                      isChecked3_01 =
                                                                          false;
                                                                      isChecked3_02 =
                                                                          false;
                                                                      isChecked3_03 =
                                                                          false;
                                                                      RespuestaPreg_03 =
                                                                          4;
                                                                    });
                                                                  },
                                                                ),
                                                                Text(textOpt4_,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ])),
                                              ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // BOTON REGISTRAR
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),

                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(7)),
                                    disabledColor: Primary.azul,
                                    elevation: 0,
                                    color: Primary.azul,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Text("Registrar",
                                          style: TextStyle(
                                              color: Primary.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                    ),
                                    onPressed: () async {
                                      bool validate = true;
                                      if (RespuestaPreg_01 == 0) {
                                        validate = false;
                                        showExitPopup("1");
                                      } else if (RespuestaPreg_02 == 0) {
                                        validate = false;
                                        showExitPopup("2");
                                      } else if (RespuestaPreg_03 == 0) {
                                        validate = false;
                                        showExitPopup("3");
                                      }

                                      Map<String, dynamic> _map_respuesta = {
                                        "rpta_1": RespuestaPreg_01,
                                        "rpta_2": RespuestaPreg_02,
                                        "rpta_3": RespuestaPreg_03,
                                      };

                                      if (validate == true) {
                                        resgitrarRespuestas(_map_respuesta,
                                            capacitacionlidSelected.toString());
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
        )
      ],
    ));
  }
}
