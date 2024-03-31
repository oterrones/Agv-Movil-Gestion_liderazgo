import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/tema/primary.dart';

class HomeAccionCampo extends StatefulWidget {
  @override
  State<HomeAccionCampo> createState() => _HomeAccionCampoState();
}

class _HomeAccionCampoState extends State<HomeAccionCampo> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _respuestas = [];
  List<Map<String, dynamic>> _respuestasUpdate = [];
  List<Map<String, dynamic>> _sincronizacionList = [];
  int codigoResultado = 0;
  bool existeAccionResultado = false;

  String error = "";
  bool _isLoading = true;
  bool isCargando = true;
  bool _isLoading_eval = false;
  bool _isSuccess_eval = false;
  bool _isError_eval = false;
  bool _isSinregistro_eval = false;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    //final data = await SQLHelper.getItems();
    final data = await DBProvider.db.getAllResultadosCampoAccion();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  Future datosSeleccion() async {
    setState(() => _isSuccess_eval = false);
    setState(() => isCargando = true);

    await Future.delayed(Duration(milliseconds: 1000));

    setState(() => isCargando = false);
    if(_journals.length <=0){
      setState(() => _isSinregistro_eval= true);
    }
    for (var i = 0; i < _journals.length; i++) {
      if(_journals[i]['accion'] == '1'){
        existeAccionResultado = true;
        break;
      }
    }
  }



  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
    datosSeleccion();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController checbox1 = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item

  Future<bool> _showExit_atras() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => AlertDialog(
        title: Text("Confirmar Sincronización",textAlign: TextAlign.center,
            style: TextStyle(
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              // letterSpacing: 6.0,
            )),
        content: Text("Esta seguro de enviar al servidor?"),
        actions: [

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text("Cancelar"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),

          ),
          ElevatedButton(
            onPressed: () {

              Navigator.of(context).pop(true);
              _sincronizacion_data();
              // Navigator.pushReplacementNamed(context, 'registroPacking');

            },
            //return true when click on "Yes"
            child: Text("Aceptar"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
  Future<bool> showExitPopup(int numero_eva) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => AlertDialog(
        title: Text("Confirmar Sincronización",textAlign: TextAlign.center,
            style: TextStyle(
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
             // letterSpacing: 6.0,
            )),
        content: Text("Esta seguro de enviar al servidor?"),
        actions: [

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text("Cancelar"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),

          ),
          ElevatedButton(
            onPressed: () {

              Navigator.of(context).pop(true);
              _sincronizacion_data();
             // Navigator.pushReplacementNamed(context, 'registroPacking');

            },
            //return true when click on "Yes"
            child: Text("Aceptar"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
  Future<bool> showExitPopupSinRegistro_sincronizacion(int numero_eva) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => AlertDialog(
        title: Text("Status de Sincronización",
            style: TextStyle(
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              // letterSpacing: 6.0,
            )),
        content: Text("No existe registros para enviar al servidor"),
        actions: [

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text("Ok"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),

          ),
        ],

      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
  Future<bool> showExitPopupSinRegistro(int numero_eva) async {

    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => AlertDialog(
        title: Text("Mensaje",
            style: TextStyle(
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              // letterSpacing: 6.0,
            )),
        content: Text("Trabajador ya cuenta con un plan de acción"),
        actions: [

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text("Ok"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),

          ),
        ],

      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }

  void _showForm(int? id,String accion,String tipo_concepto) async {

    String vr_tipo_concepto = tipo_concepto;
    if(accion=="1"){
      showExitPopupSinRegistro(0);
     return;
    }
    if(tipo_concepto  !="SEGUIMIENTO I" && tipo_concepto != "SEGUIMIENTO III"){
      if(accion=="0"){
        vr_tipo_concepto = "CAPACITACIÓN PRIORIDAD";
      }else{
        vr_tipo_concepto = "CAPACITACIÓN 24 HRS";
      }
    }


    String titulo = '';
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['idresultado'] == id);
      _titleController.text = existingJournal['fecha'];
      _descriptionController.text = existingJournal['nombres'];
      titulo = existingJournal['nombres'];
      codigoResultado = id;
      final dataRespuestas = await DBProvider.db.getRespuestaPorId(id);
      setState(() {
        _respuestas = dataRespuestas;
      });
    }
    //print("Tamaño: "+(_respuestas.length).toString());
    int rpta_01=1,rpta_02=0,rpta_03=0,rpta_04=0,rpta_05=0,rpta_06=0;
    int rpta_07=0,rpta_08=0,rpta_09=0,rpta_10=0,rpta_11=0;

    //rint("Condicion: "+ (_respuestas[0]["id_pregunta"]).toString());
    for (var i = 0; i < _respuestas.length; i++) {

      if(_respuestas[i]["id_pregunta"] == 1){
        rpta_01 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 2){
        rpta_02 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 3){
        rpta_03 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 4){
        rpta_04 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 5){
        rpta_05 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 6){
        rpta_06 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 7){
        rpta_07 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 8){
        rpta_08 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 9){
        rpta_09 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 10){
        rpta_10 = _respuestas[i]["respuesta"];
      }else if(_respuestas[i]["id_pregunta"] == 11){
        rpta_11 = _respuestas[i]["respuesta"];
      }
    }


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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                //MyStatefulWidget(key: 'true'),

               SelectSync(codigoResultado,_respuestas.length,vr_tipo_concepto),
               // SingingCharacter(context),
               // modalPreguntas(rpta_01, rpta_02, rpta_03, rpta_04, rpta_05, rpta_06, rpta_07, rpta_08, rpta_09, rpta_10, rpta_11),
              ],
            ),

          );
        },
      );


  }


  // Update an existing journal
  Future<void> _updateRespuestas(int idresultado,int pregunta,int respuesta) async {
    await DBProvider.db.updateRespuesta(idresultado,pregunta,respuesta);
    //_refreshJournals();
  }
  int _selectedIndex = 2;

  Future<void> _sincronizacion_data() async {
    setState(() => _isLoading_eval = true);
    await Future.delayed(Duration(milliseconds: 2000));
    //setState(() => _isLoading_eval = true);

    final data = await DBProvider.db.enviarDataLiderazgoCampoAWS_Accion();
    setState(() {
      _sincronizacionList = data;
    });

    String resultado = _sincronizacionList[0]["resultado"];
    if(resultado=="true"){
      setState(() => _isLoading_eval = false);
      setState(() => _isSuccess_eval = true);
      await Future.delayed(Duration(milliseconds: 2000));
    }else{
      setState(() => _isLoading_eval = false);
      setState(() => _isError_eval = true);
      await Future.delayed(Duration(milliseconds: 4000));
    }

    Navigator.pushReplacementNamed(context, 'planAccionCampo');

  }

  @override
  Widget build(BuildContext context) {
    return

      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Primary.white.withOpacity(0),
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Primary.azul,
            systemNavigationBarIconBrightness: Brightness.light),
        child: Container(
          color: Primary.background,


          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar:  BottomNavigationBar(
                currentIndex: _selectedIndex,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.indigoAccent,
                // called when one tab is selected
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                    print(_selectedIndex);
                    if(_selectedIndex==0){
                      Navigator.pushReplacementNamed(context, 'registroCampo');
                    }else if(_selectedIndex==1){
                      Navigator.pushReplacementNamed(context, 'listLidirazgoCampo');
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
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.topCenter,
                      child:
                      this.isCargando
                          ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 30),

                            child: Column(

                              children: <Widget>[
                                CircularProgressIndicator(
                                  color: Primary.azul,
                                  semanticsLabel: "Iniciando...",
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.025),
                                Text("Obteniendo datos, espere...",
                                    style: TextStyle(
                                        color: Primary.azul, fontWeight: FontWeight.bold,  fontSize: 18))
                              ],
                            ),
                          )
                          : _isSinregistro_eval
                          ?Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.height * 0.025),
                            child: Column(
                              children: <Widget>[
                                Icon(Icons.more_horiz, color: Primary.azul, size: 40),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                                Text("No se encuentrarón registros.",
                                    style: TextStyle(
                                        color: Primary.azul, fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                          :this._isSuccess_eval
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
                          :this._isLoading_eval
                          ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 25),
                            child: Column(
                              children: <Widget>[
                                CircularProgressIndicator(
                                  color: Primary.azul,
                                  semanticsLabel: "Iniciando...",
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.025),
                                Text("Iniciando Sincronización, espere...",
                                    style: TextStyle(
                                        color: Primary.azul, fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                          :this._isError_eval
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
                          :Container(
                            child:  ListView.builder(
                        itemCount:  _journals.length,
                        itemBuilder: (context, index) => Card(
                        //  color: Colors.orange[200],
                          elevation: 6,
                          margin: EdgeInsets.all(7),
                          child: ListTile(
                              leading: CircleAvatar(
                                child: Text((index+1).toString()),
                                backgroundColor: Colors.blue[600],
                              ),
                              title: Text(_journals[index]['nombres']),
                              subtitle: RichText(
                                text: TextSpan(
                                  children: <InlineSpan>[

                                    WidgetSpan(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 2, bottom: 2),
                                            child:Row(
                                              children:[
                                                Text(_journals[index]['fecha']+'  '+_journals[index]['hora']),
                                              ],)
                                        )
                                    ),
                                    WidgetSpan(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 1, bottom: 5),
                                          child: (_journals[index]['tipo_concepto'].toUpperCase() == 'SEGUIMIENTO I' || _journals[index]['tipo_concepto'].toUpperCase() == 'SEGUIMIENTO III')
                                            ?Row(
                                              children:[ Text(_journals[index]['tipo_concepto'].toUpperCase(),style: TextStyle(  fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],)
                                            :Row(
                                              children:[ Text('CAPACITACIÓN'+' - 5', style: TextStyle(  fontWeight: FontWeight.bold,fontSize: 12,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],)
                                        )
                                    ),
                                    WidgetSpan(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 5, right: 10,top: 1, bottom: 2),
                                          // alignment: Alignment.centerLeft,
                                          child: (_journals[index]['accion'] == '0')
                                              ? Text('SIN PLAN ACCIÓN',
                                            //   textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  height: 1.3,
                                                  color: Colors.white,
                                                  fontSize: 11
                                                ),
                                              )
                                              :(_journals[index]['accion'] == '3')
                                              ? Text('PLAN ACCIÓN EN PROCESO',
                                                  //   textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      height: 1.3,
                                                      color: Colors.white,
                                                      fontSize: 11
                                                  ),
                                                )
                                              :Text('CON PLAN ACCIÓN',
                                              // textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  height: 1.3,
                                                  color: Colors.white,
                                                  fontSize: 11
                                                ),
                                              ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: (_journals[index]['accion'] == '0')
                                                  ? Color.fromRGBO(200, 48, 63, 7)
                                                  : (_journals[index]['accion'] == '3')
                                                    ? Color.fromRGBO(255, 165, 0, 7)
                                                    :Color.fromRGBO(23, 135, 84, 7)),

                                        )
                                    ),

                                  ],

                                ),
                              ),

                              trailing: SizedBox(
                                width: 70,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.note_add,color: Colors.teal),
                                      onPressed: () => _showForm(_journals[index]['idresultado'],_journals[index]['accion'],_journals[index]['tipo_concepto'].toUpperCase()),
                                    ),
                                   ],
                                ),
                              )),
                        ),
                      ),

                          ),


                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],

            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: ()  {


                if(_journals.length<=0){
                  showExitPopupSinRegistro_sincronizacion(_journals.length);
                }else if(existeAccionResultado==false){
                  showExitPopupSinRegistro_sincronizacion(_journals.length);
                }else{
                  showExitPopup(_journals.length);
                }

              },
              tooltip: 'Capture Picture',
              label: Row(
                children: [
                  IconButton(onPressed: () {
                    /*
                    setState(() => {
                      this._isLoading = true,
                    });*/

                    //Future.delayed(Duration(milliseconds: 1000000));
                    if(_journals.length<=0){
                      showExitPopupSinRegistro_sincronizacion(_journals.length);
                    }else{
                      showExitPopup(_journals.length);
                    }
                  } , icon: Icon(Icons.save)),
                  //IconButton(onPressed: () {}, icon: Icon(Icons.library_add_check)),
                  Text('Sincronizar'),
                  // Text('2'),
                ],
              ),

            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      'Plan acción en campo',
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

class SelectSync extends StatefulWidget {

  final int codigoResultado ;
  final int tamanioList ;
  final String tipo_concepto ;

  const SelectSync(
      this.codigoResultado,this.tamanioList,this.tipo_concepto);
  
  @override
  _SelectSyncState createState() => _SelectSyncState();

}

class _SelectSyncState extends State<SelectSync> {

  String error = "";

  bool isLoading = false;
  bool isError = false;
  bool isSuccess = false;

  bool isVistaCap0 = false;
  bool isVistaCap1 = false;
  bool isVistaCap2 = false;
  bool isVistaCap3 = false;



  List<String> capacitacionLid = [
    'Capacitación',
    'Seguimiento I',
    'Seguimiento III'
  ];
  String? capacitacionlidSelected = 'Capacitación';


  //Fila Pregunta I;

  bool isChecked_I_1_1 = false;
  bool isChecked_I_1_2 = false;
  bool isChecked_I_1_3 = false;
  bool isChecked_I_1_4 = false;

  bool isChecked_I_2_1 = false;
  bool isChecked_I_2_2 = false;
  bool isChecked_I_2_3 = false;
  bool isChecked_I_2_4 = false;

  bool isChecked_I_3_1 = false;
  bool isChecked_I_3_2 = false;
  bool isChecked_I_3_3 = false;
  bool isChecked_I_3_4 = false;

  bool isChecked_I_4_1 = false;
  bool isChecked_I_4_2 = false;
  bool isChecked_I_4_3 = false;
  bool isChecked_I_4_4 = false;

  //Fila Pregunta I-2;
  bool isChecked_I_II_1_1 = false;
  bool isChecked_I_II_1_2 = false;
  bool isChecked_I_II_1_3 = false;
  bool isChecked_I_II_1_4 = false;

  bool isChecked_I_II_2_1 = false;
  bool isChecked_I_II_2_2 = false;
  bool isChecked_I_II_2_3 = false;
  bool isChecked_I_II_2_4 = false;

  bool isChecked_I_II_3_1 = false;
  bool isChecked_I_II_3_2 = false;
  bool isChecked_I_II_3_3 = false;
  bool isChecked_I_II_3_4 = false;

  bool isChecked_I_II_4_1 = false;
  bool isChecked_I_II_4_2 = false;
  bool isChecked_I_II_4_3 = false;
  bool isChecked_I_II_4_4 = false;

  //Fila Pregunta II;
  bool isChecked_II_1_1 = false;
  bool isChecked_II_1_2 = false;

  bool isChecked_II_2_1 = false;
  bool isChecked_II_2_2 = false;

  bool isChecked_II_3_1 = false;
  bool isChecked_II_3_2 = false;

  bool isChecked_II_4_1 = false;
  bool isChecked_II_4_2 = false;

  //Fila Pregunta II;
  bool isChecked_III_1_1 = false;
  bool isChecked_III_1_2 = false;

  bool isChecked_III_2_1 = false;
  bool isChecked_III_2_2 = false;

  bool isChecked_III_3_1 = false;
  bool isChecked_III_3_2 = false;

  bool isChecked_III_4_1 = false;
  bool isChecked_III_4_2 = false;

  //Fila Pregunta II;
  bool isChecked_IV_1_1 = false;
  bool isChecked_IV_1_2 = false;

  bool isChecked_IV_2_1 = false;
  bool isChecked_IV_2_2 = false;

  bool isChecked_IV_3_1 = false;
  bool isChecked_IV_3_2 = false;

  bool isChecked_IV_4_1 = false;
  bool isChecked_IV_4_2 = false;

  String gender = 'hombre';
  int correctScore = 0;

  int RespuestaPreg_01 = 0;
  int RespuestaPreg_02 = 0;
  int RespuestaPreg_03 = 0;
  int RespuestaPreg_04 = 0;

  int RespuestaPreg_01_p_II = 0;
  int RespuestaPreg_02_p_II = 0;
  int RespuestaPreg_03_p_II = 0;
  int RespuestaPreg_04_p_II = 0;


  Color getColorOpt1(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
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


  int codigoResultado = 0;
  int tamanioList = 0;
  final textOpt1_ = " Ejecutado";
  final textOpt2_ = " No Ejecutado";

  final textOpt1_Prio = "Prioridad 1";
  final textOpt2_Prio = "Prioridad 2";
  final textOpt3_Prio = "Prioridad 3";
  final textOpt4_Prio = "Prioridad 4";


  int valor = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();
  Future<void> _RegistrarRespuestas(int pregunta,int resultado, int respuesta,String concepto, String tipo_concepto, String fecha, String hora) async {
    await DBProvider.db.registrarRespuestaAccion(pregunta, resultado, respuesta, concepto, tipo_concepto,fecha,hora);
  }

  Future<void> _UpdaterResulAccion(int resultado, String accion) async {
    await DBProvider.db.updateResultadoAccion(resultado,accion);
  }

  void reiniciarValores() {
    RespuestaPreg_01 = 0;
    RespuestaPreg_02 = 0;
    RespuestaPreg_03 = 0;
    RespuestaPreg_04 = 0;

    isChecked_I_1_1 = false;
    isChecked_I_1_2 = false;
    isChecked_I_1_3 = false;
    isChecked_I_1_4 = false;

    isChecked_I_2_1 = false;
    isChecked_I_2_2 = false;
    isChecked_I_2_3 = false;
    isChecked_I_2_4 = false;

    isChecked_I_3_1 = false;
    isChecked_I_3_2 = false;
    isChecked_I_3_3 = false;
    isChecked_I_3_4 = false;

    isChecked_I_4_1 = false;
    isChecked_I_4_2 = false;
    isChecked_I_4_3 = false;
    isChecked_I_4_4 = false;

    //Fila Pregunta II;
    isChecked_II_1_1 = false;
    isChecked_II_1_2 = false;

    isChecked_II_2_1 = false;
    isChecked_II_2_2 = false;

    isChecked_II_3_1 = false;
    isChecked_II_3_2 = false;

    isChecked_II_4_1 = false;
    isChecked_II_4_2 = false;

    //Fila Pregunta II;
    isChecked_III_1_1 = false;
    isChecked_III_1_2 = false;

    isChecked_III_2_1 = false;
    isChecked_III_2_2 = false;

    isChecked_III_3_1 = false;
    isChecked_III_3_2 = false;

    isChecked_III_4_1 = false;
    isChecked_III_4_2 = false;

    //Fila Pregunta II;
    isChecked_IV_1_1 = false;
    isChecked_IV_1_2 = false;

    isChecked_IV_2_1 = false;
    isChecked_IV_2_2 = false;

    isChecked_IV_3_1 = false;
    isChecked_IV_3_2 = false;

    isChecked_IV_4_1 = false;
    isChecked_IV_4_2 = false;

  }



  @override
  void initState() {
    dateinput.text = "";
    super.initState();
    //datosSeleccion();
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

  Future<bool> showExitPopup(String pregunta, String punto) async {
    var titulo = "Completar respuesta";
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => AlertDialog(
        title: Text(titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              // letterSpacing: 6.0,
            )),
        content: Text("Revisar punto "+punto+ " pregunta N°. " + pregunta),
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
            Navigator.pushReplacementNamed(context, 'planAccionCampo');

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

  Future<void> registraRespuestasPlanAccion ( Map<String, dynamic> _map_respuesta,Map<String, dynamic> _map_respuesta_evaluador,String capacitacionlidSelected,int codigo_resultado_accion) async {

    final fechaActual = DateFormat("yyyy-MM-dd").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parseUTC(DateTime.now().toString())
            .toUtc());
    final HoraActual = DateFormat("HH:mm:ss").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parseUTC(DateTime.now().toString())
            .toUtc());

    List list = [];
    for (var i = 0; i < _map_respuesta.length; i++) {
      int respuesta = _map_respuesta["rpta_"+(i+1).toString()];
      await _RegistrarRespuestas((i+1), codigo_resultado_accion, respuesta, 'PLAN ACCION', capacitacionlidSelected,fechaActual,HoraActual);
    }
    String accion = "1";
    if(capacitacionlidSelected=="CAPACITACIÓN PRIORIDAD"){
      accion = "3";//EN PROCESO
      for (var i = 0; i < _map_respuesta_evaluador.length; i++) {
        int respuesta = _map_respuesta_evaluador["rpta_"+(i+1).toString()];
        await _RegistrarRespuestas((i+1), codigo_resultado_accion, respuesta, 'PLAN ACCION', capacitacionlidSelected+"-E",fechaActual,HoraActual);
      }
    }
    await _UpdaterResulAccion(codigo_resultado_accion,accion);

    Navigator.of(context).pop();
    showDialogoRegistro();

  }

  final TextEditingController txtPlanSeleccion_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    int codigo_resultado_accion = widget.codigoResultado;

    print (widget.tipo_concepto);

    isVistaCap0 = (widget.tipo_concepto == 'CAPACITACIÓN PRIORIDAD' ? true : false);
    isVistaCap1 = (widget.tipo_concepto == 'CAPACITACIÓN 24 HRS' ? true : false);
    isVistaCap2 = (widget.tipo_concepto == 'SEGUIMIENTO I' ? true : false);
    isVistaCap3 = (widget.tipo_concepto == 'SEGUIMIENTO III' ? true : false);

    txtPlanSeleccion_controller.text = widget.tipo_concepto;

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
                        TextFormField(
                          controller: txtPlanSeleccion_controller,
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
                          textAlign: TextAlign.left,
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
                child: isVistaCap0
                    ?Container(
                      height: MediaQuery.of(context).size.height * 0.71,
                      child: ListView(shrinkWrap: true, children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('I. ¿Qué no está funcionando?. - Trabajador', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'RobotoMono')),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('1. Escucha Activa.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_1_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_1_1 = true;
                                                                  isChecked_I_1_2 = false;
                                                                  isChecked_I_1_3 = false;
                                                                  isChecked_I_1_4 = false;
                                                                  RespuestaPreg_01 = 1;

                                                                  isChecked_I_2_1 = false;
                                                                  isChecked_I_3_1 = false;
                                                                  isChecked_I_4_1 = false;

                                                                  if(RespuestaPreg_02 == 1){
                                                                    RespuestaPreg_02 = 0;
                                                                  }
                                                                  if(RespuestaPreg_03 == 1){
                                                                    RespuestaPreg_03 = 0;
                                                                  }
                                                                  if(RespuestaPreg_04 == 1){
                                                                    RespuestaPreg_04 = 0;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_1_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_1_1 = false;
                                                                  isChecked_I_1_2 = true;
                                                                  isChecked_I_1_3 = false;
                                                                  isChecked_I_1_4 = false;

                                                                  isChecked_I_2_2 = false;
                                                                  isChecked_I_3_2 = false;
                                                                  isChecked_I_4_2 = false;
                                                                  RespuestaPreg_01 = 2;

                                                                  if(RespuestaPreg_02 == 2){
                                                                    RespuestaPreg_02 = 0;
                                                                  }
                                                                  if(RespuestaPreg_03 == 2){
                                                                    RespuestaPreg_03 = 0;
                                                                  }
                                                                  if(RespuestaPreg_04 == 2){
                                                                    RespuestaPreg_04 = 0;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),
                                   
                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_1_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_1_1 = false;
                                                              isChecked_I_1_2 = false;
                                                              isChecked_I_1_3 = true;
                                                              isChecked_I_1_4 = false;

                                                              isChecked_I_2_3 = false;
                                                              isChecked_I_3_3 = false;
                                                              isChecked_I_4_3 = false;

                                                              RespuestaPreg_01 = 3;

                                                              if(RespuestaPreg_02 == 3){
                                                                RespuestaPreg_02 = 0;
                                                              }
                                                              if(RespuestaPreg_03 == 3){
                                                                RespuestaPreg_03 = 0;
                                                              }
                                                              if(RespuestaPreg_04 == 3){
                                                                RespuestaPreg_04 = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_1_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_1_1 = false;
                                                              isChecked_I_1_2 = false;
                                                              isChecked_I_1_3 = false;
                                                              isChecked_I_1_4 = true;
                                                              RespuestaPreg_01 = 4;

                                                              isChecked_I_2_4 = false;
                                                              isChecked_I_3_4 = false;
                                                              isChecked_I_4_4 = false;

                                                              if(RespuestaPreg_02 == 4){
                                                                RespuestaPreg_02 = 0;
                                                              }
                                                              if(RespuestaPreg_03 == 4){
                                                                RespuestaPreg_03 = 0;
                                                              }
                                                              if(RespuestaPreg_04 == 4){
                                                                RespuestaPreg_04 = 0;
                                                              }


                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),
                                      

                                      ]
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('2. Formación y buen trato.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_2_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_2_1 = true;
                                                                  isChecked_I_2_2 = false;
                                                                  isChecked_I_2_3 = false;
                                                                  isChecked_I_2_4 = false;
                                                                  RespuestaPreg_02 = 1;

                                                                  isChecked_I_1_1 = false;
                                                                  isChecked_I_3_1 = false;
                                                                  isChecked_I_4_1 = false;

                                                                  if(RespuestaPreg_01 == 1){
                                                                    RespuestaPreg_01 = 0;
                                                                  }
                                                                  if(RespuestaPreg_03 == 1){
                                                                    RespuestaPreg_03 = 0;
                                                                  }
                                                                  if(RespuestaPreg_04 == 1){
                                                                    RespuestaPreg_04 = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_2_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_2_1 = false;
                                                                  isChecked_I_2_2 = true;
                                                                  isChecked_I_2_3 = false;
                                                                  isChecked_I_2_4 = false;
                                                                  RespuestaPreg_02 = 2;

                                                                  isChecked_I_1_2 = false;
                                                                  isChecked_I_3_2 = false;
                                                                  isChecked_I_4_2 = false;

                                                                  if(RespuestaPreg_01 == 2){
                                                                    RespuestaPreg_01 = 0;
                                                                  }
                                                                  if(RespuestaPreg_03 == 2){
                                                                    RespuestaPreg_03 = 0;
                                                                  }
                                                                  if(RespuestaPreg_04 == 2){
                                                                    RespuestaPreg_04 = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_2_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_2_1 = false;
                                                              isChecked_I_2_2 = false;
                                                              isChecked_I_2_3 = true;
                                                              isChecked_I_2_4 = false;
                                                              RespuestaPreg_02 = 3;

                                                              isChecked_I_1_3 = false;
                                                              isChecked_I_3_3 = false;
                                                              isChecked_I_4_3 = false;

                                                              if(RespuestaPreg_01 == 3){
                                                                RespuestaPreg_01 = 0;
                                                              }
                                                              if(RespuestaPreg_03 == 3){
                                                                RespuestaPreg_03 = 0;
                                                              }
                                                              if(RespuestaPreg_04 == 3){
                                                                RespuestaPreg_04 = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_2_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_2_1 = false;
                                                              isChecked_I_2_2 = false;
                                                              isChecked_I_2_3 = false;
                                                              isChecked_I_2_4 = true;
                                                              RespuestaPreg_02 = 4;

                                                              isChecked_I_1_4 = false;
                                                              isChecked_I_3_4 = false;
                                                              isChecked_I_4_4 = false;

                                                              if(RespuestaPreg_01 == 4){
                                                                RespuestaPreg_01 = 0;
                                                              }
                                                              if(RespuestaPreg_03 == 4){
                                                              RespuestaPreg_03 = 0;
                                                              }
                                                              if(RespuestaPreg_04 == 4){
                                                                RespuestaPreg_04 = 0;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('3. Manejo Responsable de personas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_3_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_3_1 = true;
                                                                  isChecked_I_3_2 = false;
                                                                  isChecked_I_3_3 = false;
                                                                  isChecked_I_3_4 = false;
                                                                  RespuestaPreg_03 = 1;

                                                                  isChecked_I_1_1 = false;
                                                                  isChecked_I_2_1 = false;
                                                                  isChecked_I_4_1 = false;

                                                                  if(RespuestaPreg_01 == 1){
                                                                    RespuestaPreg_01 = 0;
                                                                  }
                                                                  if(RespuestaPreg_02 == 1){
                                                                    RespuestaPreg_02 = 0;
                                                                  }
                                                                  if(RespuestaPreg_04 == 1){
                                                                    RespuestaPreg_04 = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_3_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_3_1 = false;
                                                                  isChecked_I_3_2 = true;
                                                                  isChecked_I_3_3 = false;
                                                                  isChecked_I_3_4 = false;
                                                                  RespuestaPreg_03 = 2;

                                                                  isChecked_I_1_2 = false;
                                                                  isChecked_I_2_2 = false;
                                                                  isChecked_I_4_2 = false;

                                                                  if(RespuestaPreg_01 == 2){
                                                                    RespuestaPreg_01 = 0;
                                                                  }
                                                                  if(RespuestaPreg_02 == 2){
                                                                    RespuestaPreg_02 = 0;
                                                                  }
                                                                  if(RespuestaPreg_04 == 2){
                                                                    RespuestaPreg_04 = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_3_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_3_1 = false;
                                                              isChecked_I_3_2 = false;
                                                              isChecked_I_3_3 = true;
                                                              isChecked_I_3_4 = false;
                                                              RespuestaPreg_03 = 3;

                                                              isChecked_I_1_3 = false;
                                                              isChecked_I_2_3 = false;
                                                              isChecked_I_4_3 = false;

                                                              if(RespuestaPreg_01 == 3){
                                                                RespuestaPreg_01 = 0;
                                                              }
                                                              if(RespuestaPreg_02 == 3){
                                                                RespuestaPreg_02 = 0;
                                                              }
                                                              if(RespuestaPreg_04 == 3){
                                                                RespuestaPreg_04 = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_3_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_3_1 = false;
                                                              isChecked_I_3_2 = false;
                                                              isChecked_I_3_3 = false;
                                                              isChecked_I_3_4 = true;
                                                              RespuestaPreg_03 = 4;

                                                              isChecked_I_1_4 = false;
                                                              isChecked_I_2_4 = false;
                                                              isChecked_I_4_4 = false;

                                                              if(RespuestaPreg_01 == 4){
                                                                RespuestaPreg_01 = 0;
                                                              }
                                                              if(RespuestaPreg_02 == 4){
                                                                RespuestaPreg_02 = 0;
                                                              }
                                                              if(RespuestaPreg_04 == 4){
                                                                RespuestaPreg_04 = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('4. Inteligencia Emocional.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_4_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_4_1 = true;
                                                                  isChecked_I_4_2 = false;
                                                                  isChecked_I_4_3 = false;
                                                                  isChecked_I_4_4 = false;
                                                                  RespuestaPreg_04 = 1;

                                                                  isChecked_I_1_1 = false;
                                                                  isChecked_I_2_1 = false;
                                                                  isChecked_I_3_1 = false;

                                                                  if(RespuestaPreg_01 == 1){
                                                                    RespuestaPreg_01 = 0;
                                                                  }
                                                                  if(RespuestaPreg_02 == 1){
                                                                    RespuestaPreg_02 = 0;
                                                                  }
                                                                  if(RespuestaPreg_03 == 1){
                                                                    RespuestaPreg_03 = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_4_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_4_1 = false;
                                                                  isChecked_I_4_2 = true;
                                                                  isChecked_I_4_3 = false;
                                                                  isChecked_I_4_4 = false;
                                                                  RespuestaPreg_04 = 2;

                                                                  isChecked_I_1_2 = false;
                                                                  isChecked_I_2_2 = false;
                                                                  isChecked_I_3_2 = false;

                                                                  if(RespuestaPreg_01 == 2){
                                                                    RespuestaPreg_01 = 0;
                                                                  }
                                                                  if(RespuestaPreg_02 == 2){
                                                                    RespuestaPreg_02 = 0;
                                                                  }
                                                                  if(RespuestaPreg_03 == 2){
                                                                    RespuestaPreg_03 = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_4_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_4_1 = false;
                                                              isChecked_I_4_2 = false;
                                                              isChecked_I_4_3 = true;
                                                              isChecked_I_4_4 = false;
                                                              RespuestaPreg_04 = 3;

                                                              isChecked_I_1_3 = false;
                                                              isChecked_I_2_3 = false;
                                                              isChecked_I_3_3 = false;

                                                              if(RespuestaPreg_01 == 3){
                                                                RespuestaPreg_01 = 0;
                                                              }
                                                              if(RespuestaPreg_02 == 3){
                                                                RespuestaPreg_02 = 0;
                                                              }
                                                              if(RespuestaPreg_03 == 3){
                                                                RespuestaPreg_03 = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_4_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_4_1 = false;
                                                              isChecked_I_4_2 = false;
                                                              isChecked_I_4_3 = false;
                                                              isChecked_I_4_4 = true;
                                                              RespuestaPreg_04 = 4;

                                                              isChecked_I_1_4 = false;
                                                              isChecked_I_2_4 = false;
                                                              isChecked_I_3_4 = false;

                                                              if(RespuestaPreg_01 == 4){
                                                                RespuestaPreg_01 = 0;
                                                              }
                                                              if(RespuestaPreg_02 == 4){
                                                                RespuestaPreg_02 = 0;
                                                              }
                                                              if(RespuestaPreg_03 ==4){
                                                                RespuestaPreg_03 = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),
                                Divider(),
                                SizedBox(height: 10),
                                Text('II. ¿Qué no está funcionando?. - Evaluador', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'RobotoMono')),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('1. Escucha Activa.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_II_1_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_1_1 = true;
                                                                  isChecked_I_II_1_2 = false;
                                                                  isChecked_I_II_1_3 = false;
                                                                  isChecked_I_II_1_4 = false;
                                                                  RespuestaPreg_01_p_II = 1;

                                                                  isChecked_I_II_2_1 = false;
                                                                  isChecked_I_II_3_1 = false;
                                                                  isChecked_I_II_4_1 = false;

                                                                  if(RespuestaPreg_02_p_II == 1){
                                                                    RespuestaPreg_02_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_03_p_II == 1){
                                                                    RespuestaPreg_03_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_04_p_II == 1){
                                                                    RespuestaPreg_04_p_II = 0;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_II_1_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_1_1 = false;
                                                                  isChecked_I_II_1_2 = true;
                                                                  isChecked_I_II_1_3 = false;
                                                                  isChecked_I_II_1_4 = false;

                                                                  isChecked_I_II_2_2 = false;
                                                                  isChecked_I_II_3_2 = false;
                                                                  isChecked_I_II_4_2 = false;
                                                                  RespuestaPreg_01_p_II = 2;

                                                                  if(RespuestaPreg_02_p_II == 2){
                                                                    RespuestaPreg_02_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_03_p_II == 2){
                                                                    RespuestaPreg_03_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_04_p_II == 2){
                                                                    RespuestaPreg_04_p_II = 0;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_II_1_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_1_1 = false;
                                                              isChecked_I_II_1_2 = false;
                                                              isChecked_I_II_1_3 = true;
                                                              isChecked_I_II_1_4 = false;

                                                              isChecked_I_II_2_3 = false;
                                                              isChecked_I_II_3_3 = false;
                                                              isChecked_I_II_4_3 = false;

                                                              RespuestaPreg_01_p_II = 3;

                                                              if(RespuestaPreg_02_p_II == 3){
                                                                RespuestaPreg_02_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_03_p_II == 3){
                                                                RespuestaPreg_03_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_04_p_II == 3){
                                                                RespuestaPreg_04_p_II = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_II_1_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_1_1 = false;
                                                              isChecked_I_II_1_2 = false;
                                                              isChecked_I_II_1_3 = false;
                                                              isChecked_I_II_1_4 = true;
                                                              RespuestaPreg_01_p_II = 4;

                                                              isChecked_I_II_2_4 = false;
                                                              isChecked_I_II_3_4 = false;
                                                              isChecked_I_II_4_4 = false;

                                                              if(RespuestaPreg_02_p_II == 4){
                                                                RespuestaPreg_02_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_03_p_II == 4){
                                                                RespuestaPreg_03_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_04_p_II == 4){
                                                                RespuestaPreg_04_p_II = 0;
                                                              }


                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('2. Formación y buen trato.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_II_2_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_2_1 = true;
                                                                  isChecked_I_II_2_2 = false;
                                                                  isChecked_I_II_2_3 = false;
                                                                  isChecked_I_II_2_4 = false;
                                                                  RespuestaPreg_02_p_II = 1;

                                                                  isChecked_I_II_1_1 = false;
                                                                  isChecked_I_II_3_1 = false;
                                                                  isChecked_I_II_4_1 = false;

                                                                  if(RespuestaPreg_01_p_II == 1){
                                                                    RespuestaPreg_01_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_03_p_II == 1){
                                                                    RespuestaPreg_03_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_04_p_II == 1){
                                                                    RespuestaPreg_04_p_II = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_II_2_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_2_1 = false;
                                                                  isChecked_I_II_2_2 = true;
                                                                  isChecked_I_II_2_3 = false;
                                                                  isChecked_I_II_2_4 = false;
                                                                  RespuestaPreg_02_p_II = 2;

                                                                  isChecked_I_II_1_2 = false;
                                                                  isChecked_I_II_3_2 = false;
                                                                  isChecked_I_II_4_2 = false;

                                                                  if(RespuestaPreg_01_p_II == 2){
                                                                    RespuestaPreg_01_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_03_p_II == 2){
                                                                    RespuestaPreg_03_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_04_p_II == 2){
                                                                    RespuestaPreg_04_p_II = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_II_2_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_2_1 = false;
                                                              isChecked_I_II_2_2 = false;
                                                              isChecked_I_II_2_3 = true;
                                                              isChecked_I_II_2_4 = false;
                                                              RespuestaPreg_02_p_II = 3;

                                                              isChecked_I_II_1_3 = false;
                                                              isChecked_I_II_3_3 = false;
                                                              isChecked_I_II_4_3 = false;

                                                              if(RespuestaPreg_01_p_II == 3){
                                                                RespuestaPreg_01_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_03_p_II == 3){
                                                                RespuestaPreg_03_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_04_p_II == 3){
                                                                RespuestaPreg_04_p_II = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_II_2_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_2_1 = false;
                                                              isChecked_I_II_2_2 = false;
                                                              isChecked_I_II_2_3 = false;
                                                              isChecked_I_II_2_4 = true;
                                                              RespuestaPreg_02_p_II = 4;

                                                              isChecked_I_II_1_4 = false;
                                                              isChecked_I_II_3_4 = false;
                                                              isChecked_I_II_4_4 = false;

                                                              if(RespuestaPreg_01_p_II == 4){
                                                                RespuestaPreg_01_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_03_p_II == 4){
                                                                RespuestaPreg_03_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_04_p_II == 4){
                                                                RespuestaPreg_04_p_II = 0;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('3. Manejo Responsable de personas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_II_3_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_3_1 = true;
                                                                  isChecked_I_II_3_2 = false;
                                                                  isChecked_I_II_3_3 = false;
                                                                  isChecked_I_II_3_4 = false;
                                                                  RespuestaPreg_03_p_II = 1;

                                                                  isChecked_I_II_1_1 = false;
                                                                  isChecked_I_II_2_1 = false;
                                                                  isChecked_I_II_4_1 = false;

                                                                  if(RespuestaPreg_01_p_II == 1){
                                                                    RespuestaPreg_01_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_02_p_II == 1){
                                                                    RespuestaPreg_02_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_04_p_II == 1){
                                                                    RespuestaPreg_04_p_II = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_II_3_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_3_1 = false;
                                                                  isChecked_I_II_3_2 = true;
                                                                  isChecked_I_II_3_3 = false;
                                                                  isChecked_I_II_3_4 = false;
                                                                  RespuestaPreg_03_p_II = 2;

                                                                  isChecked_I_II_1_2 = false;
                                                                  isChecked_I_II_2_2 = false;
                                                                  isChecked_I_II_4_2 = false;

                                                                  if(RespuestaPreg_01_p_II == 2){
                                                                    RespuestaPreg_01_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_02_p_II == 2){
                                                                    RespuestaPreg_02_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_04_p_II == 2){
                                                                    RespuestaPreg_04_p_II = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_II_3_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_3_1 = false;
                                                              isChecked_I_II_3_2 = false;
                                                              isChecked_I_II_3_3 = true;
                                                              isChecked_I_II_3_4 = false;
                                                              RespuestaPreg_03_p_II = 3;

                                                              isChecked_I_II_1_3 = false;
                                                              isChecked_I_II_2_3 = false;
                                                              isChecked_I_II_4_3 = false;

                                                              if(RespuestaPreg_01_p_II == 3){
                                                                RespuestaPreg_01_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_02_p_II == 3){
                                                                RespuestaPreg_02_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_04_p_II == 3){
                                                                RespuestaPreg_04_p_II = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_II_3_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_3_1 = false;
                                                              isChecked_I_II_3_2 = false;
                                                              isChecked_I_II_3_3 = false;
                                                              isChecked_I_II_3_4 = true;
                                                              RespuestaPreg_03_p_II = 4;

                                                              isChecked_I_II_1_4 = false;
                                                              isChecked_I_II_2_4 = false;
                                                              isChecked_I_II_4_4 = false;

                                                              if(RespuestaPreg_01_p_II == 4){
                                                                RespuestaPreg_01_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_02_p_II == 4){
                                                                RespuestaPreg_02_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_04_p_II == 4){
                                                                RespuestaPreg_04_p_II = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:  Text('4. Inteligencia Emocional.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                  alignment: Alignment.centerLeft,
                                  child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          // padding: EdgeInsets.only(top: 12),
                                            child:
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                              value: isChecked_I_II_4_1,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_4_1 = true;
                                                                  isChecked_I_II_4_2 = false;
                                                                  isChecked_I_II_4_3 = false;
                                                                  isChecked_I_II_4_4 = false;
                                                                  RespuestaPreg_04_p_II = 1;

                                                                  isChecked_I_II_1_1 = false;
                                                                  isChecked_I_II_2_1 = false;
                                                                  isChecked_I_II_3_1 = false;

                                                                  if(RespuestaPreg_01_p_II == 1){
                                                                    RespuestaPreg_01_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_02_p_II == 1){
                                                                    RespuestaPreg_02_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_03_p_II == 1){
                                                                    RespuestaPreg_03_p_II = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt1_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  new Row(
                                                    // mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: (){
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Row(
                                                          children: <Widget>[

                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
                                                              value: isChecked_I_II_4_2,
                                                              onChanged: (bool? value) {
                                                                setState(() {
                                                                  isChecked_I_II_4_1 = false;
                                                                  isChecked_I_II_4_2 = true;
                                                                  isChecked_I_II_4_3 = false;
                                                                  isChecked_I_II_4_4 = false;
                                                                  RespuestaPreg_04_p_II = 2;

                                                                  isChecked_I_II_1_2 = false;
                                                                  isChecked_I_II_2_2 = false;
                                                                  isChecked_I_II_3_2 = false;

                                                                  if(RespuestaPreg_01_p_II == 2){
                                                                    RespuestaPreg_01_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_02_p_II == 2){
                                                                    RespuestaPreg_02_p_II = 0;
                                                                  }
                                                                  if(RespuestaPreg_03_p_II == 2){
                                                                    RespuestaPreg_03_p_II = 0;
                                                                  }

                                                                });
                                                              },
                                                            ),
                                                            Text(textOpt2_Prio,
                                                                style: TextStyle( fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            )
                                        ),

                                        Expanded(child:
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
                                                          value: isChecked_I_II_4_3,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_4_1 = false;
                                                              isChecked_I_II_4_2 = false;
                                                              isChecked_I_II_4_3 = true;
                                                              isChecked_I_II_4_4 = false;
                                                              RespuestaPreg_04_p_II = 3;

                                                              isChecked_I_II_1_3 = false;
                                                              isChecked_I_II_2_3 = false;
                                                              isChecked_I_II_3_3 = false;

                                                              if(RespuestaPreg_01_p_II == 3){
                                                                RespuestaPreg_01_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_02_p_II == 3){
                                                                RespuestaPreg_02_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_03_p_II == 3){
                                                                RespuestaPreg_03_p_II = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt3_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                      });
                                                    },
                                                    child: Row(
                                                      children: <Widget>[

                                                        Checkbox(
                                                          checkColor: Colors.white,
                                                          fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                          value: isChecked_I_II_4_4,
                                                          onChanged: (bool? value) {
                                                            setState(() {
                                                              isChecked_I_II_4_1 = false;
                                                              isChecked_I_II_4_2 = false;
                                                              isChecked_I_II_4_3 = false;
                                                              isChecked_I_II_4_4 = true;
                                                              RespuestaPreg_04_p_II = 4;

                                                              isChecked_I_II_1_4 = false;
                                                              isChecked_I_II_2_4 = false;
                                                              isChecked_I_II_3_4 = false;

                                                              if(RespuestaPreg_01_p_II == 4){
                                                                RespuestaPreg_01_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_02_p_II == 4){
                                                                RespuestaPreg_02_p_II = 0;
                                                              }
                                                              if(RespuestaPreg_03_p_II ==4){
                                                                RespuestaPreg_03_p_II = 0;
                                                              }

                                                            });
                                                          },
                                                        ),
                                                        Text(textOpt4_Prio,
                                                            style: TextStyle( fontSize: 16)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]
                                        )
                                        ),


                                      ]
                                  ),

                                ),


                              ],
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
                              showExitPopup("1","I");
                            } else if (RespuestaPreg_02 == 0) {
                              validate = false;
                              showExitPopup("2","I");
                            } else if (RespuestaPreg_03 == 0) {
                              validate = false;
                              showExitPopup("3","I");
                            } else if (RespuestaPreg_04 == 0) {
                              validate = false;
                              showExitPopup("4","I");
                            }else if(txtPlanSeleccion_controller.text=="CAPACITACIÓN PRIORIDAD"){
                              if (RespuestaPreg_01_p_II == 0) {
                                validate = false;
                                showExitPopup("1","II");
                              } else if (RespuestaPreg_02_p_II == 0) {
                                validate = false;
                                showExitPopup("2","II");
                              } else if (RespuestaPreg_03_p_II == 0) {
                                validate = false;
                                showExitPopup("3","II");
                              } else if (RespuestaPreg_04_p_II == 0) {
                                validate = false;
                                showExitPopup("4","II");
                              }

                            }

                            Map<String, dynamic> _map_respuesta = {
                              "rpta_1": RespuestaPreg_01,
                              "rpta_2": RespuestaPreg_02,
                              "rpta_3": RespuestaPreg_03,
                              "rpta_4": RespuestaPreg_04
                            };

                            Map<String, dynamic> _map_respuesta_evaluador = {
                              "rpta_1": RespuestaPreg_01_p_II,
                              "rpta_2": RespuestaPreg_02_p_II,
                              "rpta_3": RespuestaPreg_03_p_II,
                              "rpta_4": RespuestaPreg_04_p_II
                            };

                            if (validate == true) {
                              await registraRespuestasPlanAccion(_map_respuesta,_map_respuesta_evaluador,txtPlanSeleccion_controller.text,codigo_resultado_accion);
                            }
                          },
                        )
                      ],
                      ),
                    )
                    : isVistaCap1
                    ?Container(
                  height: MediaQuery.of(context).size.height * 0.71,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('II.  Acción que realizaré en las próximas 24 hrs.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'RobotoMono')),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('1. Escucha Activasss.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_1_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_1_1 = true;
                                                          isChecked_II_1_2 = false;
                                                          RespuestaPreg_01 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_1_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_1_1 = false;
                                                          isChecked_II_1_2 = true;
                                                          RespuestaPreg_01 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('2. Formación y buen trato.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_2_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_2_1 = true;
                                                          isChecked_II_2_2 = false;
                                                          RespuestaPreg_02 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_2_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_2_1 = false;
                                                          isChecked_II_2_2 = true;
                                                          RespuestaPreg_02 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('3. Manejo Responsable de personas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_3_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_3_1 = true;
                                                          isChecked_II_3_2 = false;
                                                          RespuestaPreg_03 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_3_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_3_1 = false;
                                                          isChecked_II_3_2 = true;
                                                          RespuestaPreg_03 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('4. Inteligencia Emocional.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_4_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_4_1 = true;
                                                          isChecked_II_4_2 = false;
                                                          RespuestaPreg_04 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_4_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_4_1 = false;
                                                          isChecked_II_4_2 = true;
                                                          RespuestaPreg_04 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                          ],
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
                          showExitPopup("1","II");
                        } else if (RespuestaPreg_02 == 0) {
                          validate = false;
                          showExitPopup("2","II");
                        } else if (RespuestaPreg_03 == 0) {
                          validate = false;
                          showExitPopup("3","II");
                        } else if (RespuestaPreg_04 == 0) {
                          validate = false;
                          showExitPopup("4","II");
                        }


                        Map<String, dynamic> _map_respuesta = {
                          "rpta_1": RespuestaPreg_01,
                          "rpta_2": RespuestaPreg_02,
                          "rpta_3": RespuestaPreg_03,
                          "rpta_4": RespuestaPreg_04
                        };

                        Map<String, dynamic> _map_respuesta_evaluador = {
                        };

                        if (validate == true) {
                          await registraRespuestasPlanAccion(_map_respuesta,_map_respuesta_evaluador,txtPlanSeleccion_controller.text,codigo_resultado_accion);
                        }
                      },
                    )
                  ],
                  ),
                )
                    :isVistaCap2
                      ? Container(
                  height: MediaQuery.of(context).size.height * 0.71,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('I. Acción que realizaré en la próxima semana.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'RobotoMono')),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('1. Escucha Activa.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_1_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_1_1 = true;
                                                          isChecked_II_1_2 = false;
                                                          RespuestaPreg_01 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_1_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_1_1 = false;
                                                          isChecked_II_1_2 = true;
                                                          RespuestaPreg_01 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('2. Formación y buen trato.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_2_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_2_1 = true;
                                                          isChecked_II_2_2 = false;
                                                          RespuestaPreg_02 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_2_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_2_1 = false;
                                                          isChecked_II_2_2 = true;
                                                          RespuestaPreg_02 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('3. Manejo Responsable de personas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_3_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_3_1 = true;
                                                          isChecked_II_3_2 = false;
                                                          RespuestaPreg_03 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_3_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_3_1 = false;
                                                          isChecked_II_3_2 = true;
                                                          RespuestaPreg_03 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:  Text('4. Inteligencia Emocional.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                              alignment: Alignment.centerLeft,
                              child:Row(
                                  children: <Widget>[
                                    Expanded(child:
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                      value: isChecked_II_4_1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_4_1 = true;
                                                          isChecked_II_4_2 = false;
                                                          RespuestaPreg_04 = 1;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt1_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2),
                                          new Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                onTap: (){
                                                  setState(() {
                                                  });
                                                },
                                                child: Row(
                                                  children: <Widget>[

                                                    Checkbox(
                                                      checkColor: Colors.white,
                                                      fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                      value: isChecked_II_4_2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          isChecked_II_4_1 = false;
                                                          isChecked_II_4_2 = true;
                                                          RespuestaPreg_04 = 2;
                                                        });
                                                      },
                                                    ),
                                                    Text(textOpt2_,
                                                        style: TextStyle( fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                    )
                                    ),

                                  ]
                              ),

                            ),
                          ],
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
                          showExitPopup("1","I");
                        } else if (RespuestaPreg_02 == 0) {
                          validate = false;
                          showExitPopup("2","I");
                        } else if (RespuestaPreg_03 == 0) {
                          validate = false;
                          showExitPopup("3","I");
                        } else if (RespuestaPreg_04 == 0) {
                          validate = false;
                          showExitPopup("4","I");
                        }

                        Map<String, dynamic> _map_respuesta = {
                          "rpta_1": RespuestaPreg_01,
                          "rpta_2": RespuestaPreg_02,
                          "rpta_3": RespuestaPreg_03,
                          "rpta_4": RespuestaPreg_04
                        };

                        Map<String, dynamic> _map_respuesta_evaluador = {
                        };

                        if (validate == true) {
                          await registraRespuestasPlanAccion(_map_respuesta,_map_respuesta_evaluador,txtPlanSeleccion_controller.text,codigo_resultado_accion);

                        }
                      },
                    )
                  ],
                  ),
                )
                      : Container(
                        height: MediaQuery.of(context).size.height * 0.71,
                        child: ListView(shrinkWrap: true, children: <Widget>[                   
                          Row(
                            children: <Widget>[
                              Expanded(child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('I. Acción que realizaré en el próximo mes.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,fontFamily: 'RobotoMono')),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:  Text('1. Escucha Activa.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:Row(
                                        children: <Widget>[
                                          Expanded(child:
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                            value: isChecked_II_1_1,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_1_1 = true;
                                                                isChecked_II_1_2 = false;
                                                                RespuestaPreg_01 = 1;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt1_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                            value: isChecked_II_1_2,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_1_1 = false;
                                                                isChecked_II_1_2 = true;
                                                                RespuestaPreg_01 = 2;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt2_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          )
                                          ),
      
                                        ]
                                    ),
      
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:  Text('2. Formación y buen trato.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:Row(
                                        children: <Widget>[
                                          Expanded(child:
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                            value: isChecked_II_2_1,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_2_1 = true;
                                                                isChecked_II_2_2 = false;
                                                                RespuestaPreg_02 = 1;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt1_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                            value: isChecked_II_2_2,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_2_1 = false;
                                                                isChecked_II_2_2 = true;
                                                                RespuestaPreg_02 = 2;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt2_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          )
                                          ),
      
                                        ]
                                    ),
      
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:  Text('3. Manejo Responsable de personas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:Row(
                                        children: <Widget>[
                                          Expanded(child:
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                            value: isChecked_II_3_1,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_3_1 = true;
                                                                isChecked_II_3_2 = false;
                                                                RespuestaPreg_03 = 1;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt1_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                            value: isChecked_II_3_2,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_3_1 = false;
                                                                isChecked_II_3_2 = true;
                                                                RespuestaPreg_03 = 2;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt2_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          )
                                          ),
      
                                        ]
                                    ),
      
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:  Text('4. Inteligencia Emocional.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                                    alignment: Alignment.centerLeft,
                                    child:Row(
                                        children: <Widget>[
                                          Expanded(child:
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
                                                            value: isChecked_II_4_1,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_4_1 = true;
                                                                isChecked_II_4_2 = false;
                                                                RespuestaPreg_04 = 1;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt1_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                                new Row(
                                                  // mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                        });
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
      
                                                          Checkbox(
                                                            checkColor: Colors.white,
                                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
                                                            value: isChecked_II_4_2,
                                                            onChanged: (bool? value) {
                                                              setState(() {
                                                                isChecked_II_4_1 = false;
                                                                isChecked_II_4_2 = true;
                                                                RespuestaPreg_04 = 2;
                                                              });
                                                            },
                                                          ),
                                                          Text(textOpt2_,
                                                              style: TextStyle( fontSize: 16)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          )
                                          ),
      
                                        ]
                                    ),
      
                                  ),
                                ],
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
                                showExitPopup("1","I");
                              } else if (RespuestaPreg_02 == 0) {
                                validate = false;
                                showExitPopup("2","I");
                              } else if (RespuestaPreg_03 == 0) {
                                validate = false;
                                showExitPopup("3","I");
                              } else if (RespuestaPreg_04 == 0) {
                                validate = false;
                                showExitPopup("4","I");
                              }

                              Map<String, dynamic> _map_respuesta = {
                                "rpta_1": RespuestaPreg_01,
                                "rpta_2": RespuestaPreg_02,
                                "rpta_3": RespuestaPreg_03,
                                "rpta_4": RespuestaPreg_04
                              };
                              Map<String, dynamic> _map_respuesta_evaluador = {
                              };
                              if(validate==true){
                                await registraRespuestasPlanAccion(_map_respuesta,_map_respuesta_evaluador,txtPlanSeleccion_controller.text,codigo_resultado_accion);

                              }

                            },
                          )
                        ],
                        ),
                )

            )
          ],
        ));


  }
}



