import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/tema/primary.dart';

class HomeListLiderazgoCampo extends StatefulWidget {
  @override
  State<HomeListLiderazgoCampo> createState() => _homeListLiderazgoCampoState();
}

class _homeListLiderazgoCampoState extends State<HomeListLiderazgoCampo> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _tamnio_lista = [];
  List<Map<String, dynamic>> _respuestas = [];
  List<Map<String, dynamic>> _respuestasUpdate = [];
  List<Map<String, dynamic>> _sincronizacionList = [];
  int codigoResultado = 0;

  String error = "";
  bool  isCargando = true;
  bool _isLoading_eval = false;
  bool _isSuccess_eval = false;
  bool _isError_eval = false;
  bool _isSinregistro_eval = false;
  bool _isSinResul_eval = false;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    //final data = await SQLHelper.getItems();
    final data = await DBProvider.db.getAllResultadosCampo_();
    final data_tamanio_lista = await DBProvider.db.getAllResultadosCampo_validar_existencia();
    setState(() {
      _journals = data;
      _tamnio_lista = data_tamanio_lista;
      print(_tamnio_lista.length);
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
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
    datosSeleccion();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController checbox1 = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item

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


  Future<bool> showExitPopupSinRegistro(int numero_eva) async {
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

  void _showForm(int? id,String concepto,String tipo_concepto,String proceso) async {
    String titulo = '';
    if (id != null) {

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
              (concepto=="SEGUIMIENTO")
                  ? SelectSync(rpta_01, rpta_02, rpta_03, rpta_04
                  , rpta_05, rpta_06, rpta_07, rpta_08,
                  rpta_09, rpta_10, rpta_11,codigoResultado,_respuestas.length)
                  : SelectCapacitacion(rpta_01, rpta_02, rpta_03, rpta_04, rpta_05, rpta_06, codigoResultado, _respuestas.length, tipo_concepto,'A',proceso),
              // SingingCharacter(context),
              // modalPreguntas(rpta_01, rpta_02, rpta_03, rpta_04, rpta_05, rpta_06, rpta_07, rpta_08, rpta_09, rpta_10, rpta_11),
            ],
          ),

        );
      },
    );


  }

  void _showFormAddCapa(int? id,String concepto,String tipo_concepto,String proceso) async {

    String titulo = '';
    if (id != null) {

      final existingJournal =
      _journals.firstWhere((element) => element['idresultado'] == id);
      _titleController.text = existingJournal['fecha'];
      _descriptionController.text = existingJournal['nombres'];
      titulo = existingJournal['nombres'];
      codigoResultado = id;
    }
    int rpta_01=0,rpta_02=0,rpta_03=0,rpta_04=0,rpta_05=0,rpta_06=0;

    String tituloAdd = "EVALUACIÓN DE SATISFACCIÓN";
    if(proceso == "0") {
      tituloAdd = "NOTA INICIAL EVALUADOR";
    }else if(proceso == "3"){
      tituloAdd = "NOTA FINAL EVALUADOR";
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
              SizedBox(height: 6,),
              Container(
                child: Text(
                  tituloAdd,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'RobotoMono',color: Colors.blue),
                ),
              ),

              (proceso != "4")
                  ? SelectCapacitacion(rpta_01, rpta_02, rpta_03, rpta_04, rpta_05, rpta_06, codigoResultado, _respuestas.length, tipo_concepto,'R',proceso)
                  :SelectCapacitacionSatisfaccion(codigoResultado, _respuestas.length, tipo_concepto,'R',proceso)

              //SelectCapacitacion(rpta_01, rpta_02, rpta_03, rpta_04, rpta_05, rpta_06, codigoResultado, _respuestas.length, tipo_concepto,'R',proceso),
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
  int _selectedIndex = 1;

  Future<void> _sincronizacion_data() async {

    setState(() => _isLoading_eval = true);

    await Future.delayed(Duration(milliseconds: 2000));

    final data = await DBProvider.db.enviarDataLiderazgoCampoAWS();
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


    Navigator.pushReplacementNamed(context, 'listLidirazgoCampo');



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
                    }else if(_selectedIndex==2){
                      Navigator.pushReplacementNamed(context, 'planAccionCampo');
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
                          ?Container(
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
                          :_isSinregistro_eval
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
                                //subtitle: Text(_journals[index]['fecha']+'  '+_journals[index]['hora']),
                                subtitle: RichText(
                                  text: TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 2, bottom: 5),
                                            child: Text(_journals[index]['fecha']+'  '+_journals[index]['hora']),
                                          )
                                      ),
                                      WidgetSpan(
                                          child: Container(
                                            padding: EdgeInsets.only(top: 1, bottom: 5),
                                            child: (_journals[index]['capacitacion'] == '0' && _journals[index]['concepto'] == 'CAPACITACIÓN')
                                                ?Row(
                                              children:[ Text('NOTA TRABAJADOR',style: TextStyle(  fontWeight: FontWeight.normal,fontSize: 11,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],)
                                                :(_journals[index]['capacitacion'] == '3' && _journals[index]['concepto'] == 'CAPACITACIÓN')
                                                ? Row(
                                              children:[ Text('NOTA INICIAL EVALUADOR', style: TextStyle(  fontWeight: FontWeight.normal,fontSize: 11,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],)
                                                : (_journals[index]['capacitacion'] == '4' && _journals[index]['concepto'] == 'CAPACITACIÓN')
                                                ?Row(
                                              children:[ Text('NOTA FINAL EVALUADOR', style: TextStyle(  fontWeight: FontWeight.normal,fontSize: 11,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],)
                                                :(_journals[index]['concepto'] == 'CAPACITACIÓN')
                                                ?Row(
                                              children:[ Text('EVALUACIÓN SATISFACCIÓN', style: TextStyle(  fontWeight: FontWeight.normal,fontSize: 11,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],)
                                                : Row(
                                              children:[ Text('NOTA TRABAJADOR', style: TextStyle(  fontWeight: FontWeight.normal,fontSize: 11,fontFamily: 'Raleway',fontStyle: FontStyle.italic
                                              ))],),
                                          )
                                      ),
                                      WidgetSpan(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5, right: 10,top: 1, bottom: 2),
                                            // alignment: Alignment.centerLeft,
                                            child: (_journals[index]['capacitacion'] == '5' && _journals[index]['concepto'] == 'CAPACITACIÓN')
                                                ? Text('FINALIZADO',
                                              //   textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  height: 1.3,
                                                  color: Colors.white,
                                                  fontSize: 11
                                              ),
                                            )
                                                :(_journals[index]['concepto'] == 'CAPACITACIÓN')
                                                ? Text('EN PROCESO',
                                              // textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  height: 1.3,
                                                  color: Colors.white,
                                                  fontSize: 11
                                              ),
                                            )
                                                :Text('FINALIZADO',
                                              // textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  height: 1.3,
                                                  color: Colors.white,
                                                  fontSize: 11
                                              ),
                                            )
                                            ,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: (_journals[index]['capacitacion'] == '5' || _journals[index]['concepto'] == 'SEGUIMIENTO' )
                                                    ? Color.fromRGBO(23, 135, 84, 7)
                                                    : Color.fromRGBO(255, 165, 0, 7)),

                                          )
                                      ),

                                      WidgetSpan(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5, right: 10,top: 1, bottom: 5),

                                          )
                                      ),
                                      WidgetSpan(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5, right: 10,top: 1, bottom: 2),
                                            // alignment: Alignment.centerLeft,
                                            child: (_journals[index]['tipo_concepto'] == "Inteligencia Emocional Capacitación 4")
                                                ?  Text(
                                              'IE Capacitación 4',
                                              //   textAlign: TextAlign.center,
                                              style: TextStyle(
                                                height: 1.3,
                                                color: Colors.white,
                                              ),
                                            )
                                                :(_journals[index]['tipo_concepto'] == "Inteligencia Emocional Capacitación 5")
                                                ? Text(
                                              'IE Capacitación 5',
                                              // textAlign: TextAlign.center,
                                              style: TextStyle(
                                                height: 1.3,
                                                color: Colors.white,
                                              ),
                                            )
                                                : Text(
                                              _journals[index]['tipo_concepto'].replaceAll('Liderazgo','L'),
                                              //   textAlign: TextAlign.center,
                                              style: TextStyle(
                                                height: 1.3,
                                                color: Colors.white,
                                              ),
                                            ),

                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Color.fromRGBO(23, 162, 184, 7)),
                                          )
                                      ),

                                    ],

                                  ),
                                ),

                                trailing:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (_journals[index]['concepto'] == 'CAPACITACIÓN' && _journals[index]['capacitacion'] != '5') IconButton(
                                      icon: const Icon(Icons.note_add,color: Colors.teal),
                                      onPressed: () => _showFormAddCapa(_journals[index]['idresultado'],_journals[index]['concepto']
                                          ,_journals[index]['tipo_concepto'],_journals[index]['capacitacion']),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0),
                                    IconButton(
                                      icon: const Icon(Icons.edit,color: Colors.green),
                                      onPressed: () => _showForm(_journals[index]['idresultado'],_journals[index]['concepto']
                                          ,_journals[index]['tipo_concepto'],_journals[index]['capacitacion']),
                                    ),

                                  ],
                                )),
                          ),
                        ),

                      )
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],

            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: ()  {
                if(_tamnio_lista.length<=0){
                  showExitPopupSinRegistro(_journals.length);
                }else{
                  showExitPopup(_journals.length);
                }

              },
              tooltip: 'Capture Picture',
              label: Row(
                children: [
                  IconButton(onPressed: () {

                    print(_tamnio_lista.length);
                    if(_tamnio_lista.length<=0){
                      showExitPopupSinRegistro(_journals.length);
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
                      'Evaluados  en campo',
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
  final int rpta_01,rpta_02,rpta_03,rpta_04,rpta_05,rpta_06;
  final int rpta_07,rpta_08,rpta_09,rpta_10,rpta_11;
  final int codigoResultado ;
  final int tamanioList ;
  const SelectSync(this.rpta_01,this.rpta_02,this.rpta_03,this.rpta_04,this.rpta_05,
      this.rpta_06,this.rpta_07,this.rpta_08,this.rpta_09,this.rpta_10,this.rpta_11,
      this.codigoResultado,this.tamanioList);

  @override
  _SelectSyncState createState() => _SelectSyncState();

}

class _SelectSyncState extends State<SelectSync> {

  String error = "";
  bool isLoading = false;
  bool isError = false;
  bool isSuccess = false;



  //Fila Pregunta 01;
  bool isChecked1_01 = true;
  bool isChecked1_02 = false;
  bool isChecked1_03 = false;
  bool isChecked1_04 = false;

  //Fila Pregunta 02;
  bool isChecked2_01 = true;
  bool isChecked2_02 = false;
  bool isChecked2_03 = false;
  bool isChecked2_04 = false;

  //Fila Pregunta 03;
  bool isChecked3_01 = true;
  bool isChecked3_02 = false;
  bool isChecked3_03 = false;
  bool isChecked3_04 = false;

  //Fila Pregunta 04;
  bool isChecked4_01 = true;
  bool isChecked4_02 = false;
  bool isChecked4_03 = false;
  bool isChecked4_04 = false;

  //Fila Pregunta 05;
  bool isChecked5_01 = true;
  bool isChecked5_02 = false;
  bool isChecked5_03 = false;
  bool isChecked5_04 = false;

  //Fila Pregunta 06;
  bool isChecked6_01 = true;
  bool isChecked6_02 = false;
  bool isChecked6_03 = false;
  bool isChecked6_04 = false;

  //Fila Pregunta 07;
  bool isChecked7_01 = true;
  bool isChecked7_02 = false;
  bool isChecked7_03 = false;
  bool isChecked7_04 = false;

  //Fila Pregunta 08;
  bool isChecked8_01 = true;
  bool isChecked8_02 = false;
  bool isChecked8_03 = false;
  bool isChecked8_04 = false;

  //Fila Pregunta 09;
  bool isChecked9_01 = true;
  bool isChecked9_02 = false;
  bool isChecked9_03 = false;
  bool isChecked9_04 = false;

  //Fila Pregunta 10;
  bool isChecked10_01 = true;
  bool isChecked10_02 = false;
  bool isChecked10_03 = false;
  bool isChecked10_04 = false;

  //Fila Pregunta 11;
  bool isChecked11_01 = true;
  bool isChecked11_02 = false;
  bool isChecked11_03_1 = false;
  bool isChecked11_04 = false;


  String gender = 'hombre';
  int correctScore = 0;

  int RespuestaPreg_01 = 1;
  int RespuestaPreg_02 = 1;
  int RespuestaPreg_03 = 1;
  int RespuestaPreg_04 = 1;
  int RespuestaPreg_05 = 1;
  int RespuestaPreg_06 = 1;
  int RespuestaPreg_07 = 1;
  int RespuestaPreg_08 = 1;
  int RespuestaPreg_09 = 1;
  int RespuestaPreg_10 = 1;
  int RespuestaPreg_11 = 1;

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

  final textOpt1 = "1: ";
  final textOpt2 = "2: ";
  final textOpt3 = "3: ";
  final textOpt4 = "4: ";
  int codigoResultado = 0;
  int tamanioList = 0;
  final textOpt1_ = " No sabe que tiene que hacerlo.";
  final textOpt2_ = " Lo sabe, pero no lo hace.";
  final textOpt3_ = " Lo hace con esfuerzo.";
  final textOpt4_ = " Lo hace de manera natural.";
  final TextEditingController txtObservaciones =new TextEditingController();


  int valor = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dateinput = TextEditingController();
  Future<void> _updateRespuestas(int idresultado,int pregunta,int respuesta) async {
    final resultado = await DBProvider.db.updateRespuesta(idresultado,pregunta,respuesta);

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

  Future<bool> showExitActualizar() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
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
                  Text("Actualización exitosa",textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }) ??
        false; //if showDialouge had returned null, then return false
  }

  Future<void> updateRespuestasInterno ( Map<String, dynamic> _map_respuesta) async {


    //  setState(() => isSuccess = true);

    for (var i = 0; i < tamanioList; i++) {
      int respuesta = _map_respuesta["rpta_"+(i+1).toString()];
      await _updateRespuestas(codigoResultado,(i+1),respuesta);
    }
    Navigator.of(context).pop();
    showExitActualizar();
    // await Future.delayed(Duration(milliseconds: 800));
    //setState(() => isSuccess = false);
    //Navigator.of(context).pop();


  }

  @override
  Widget build(BuildContext context) {

    if(valor == 1){
      valor = 0;
      codigoResultado = widget.codigoResultado;
      tamanioList = widget.tamanioList;
      isChecked1_01 = (widget.rpta_01 == 1 ? true : false);
      isChecked1_02 = (widget.rpta_01 == 2 ? true : false);
      isChecked1_03 = (widget.rpta_01 == 3 ? true : false);
      isChecked1_04 = (widget.rpta_01 == 4 ? true : false);

      //Fila Pregunta 02;
      isChecked2_01 = (widget.rpta_02 == 1 ? true : false);
      isChecked2_02 = (widget.rpta_02 == 2 ? true : false);
      isChecked2_03 = (widget.rpta_02 == 3 ? true : false);
      isChecked2_04 = (widget.rpta_02 == 4 ? true : false);

      //Fila Pregunta 03;
      isChecked3_01 = (widget.rpta_03 == 1 ? true : false);
      isChecked3_02 = (widget.rpta_03 == 2 ? true : false);
      isChecked3_03 = (widget.rpta_03 == 3 ? true : false);
      isChecked3_04 = (widget.rpta_03 == 4 ? true : false);

      //Fila Pregunta 04;
      isChecked4_01 = (widget.rpta_04 == 1 ? true : false);
      isChecked4_02 = (widget.rpta_04 == 2 ? true : false);
      isChecked4_03 = (widget.rpta_04 == 3 ? true : false);
      isChecked4_04 = (widget.rpta_04 == 4 ? true : false);

      //Fila Pregunta 05;
      isChecked5_01 = (widget.rpta_05 == 1 ? true : false);
      isChecked5_02 = (widget.rpta_05 == 2 ? true : false);
      isChecked5_03 = (widget.rpta_05 == 3 ? true : false);
      isChecked5_04 = (widget.rpta_05 == 4 ? true : false);

      //Fila Pregunta 06;
      isChecked6_01 = (widget.rpta_06 == 1 ? true : false);
      isChecked6_02 = (widget.rpta_06 == 2 ? true : false);
      isChecked6_03 = (widget.rpta_06 == 3 ? true : false);
      isChecked6_04 = (widget.rpta_06 == 4 ? true : false);

      //Fila Pregunta 07;
      isChecked7_01 = (widget.rpta_07 == 1 ? true : false);
      isChecked7_02 = (widget.rpta_07 == 2 ? true : false);
      isChecked7_03 = (widget.rpta_07 == 3 ? true : false);
      isChecked7_04 = (widget.rpta_07 == 4 ? true : false);

      //Fila Pregunta 08;
      isChecked8_01 = (widget.rpta_08 == 1 ? true : false);
      isChecked8_02 = (widget.rpta_08 == 2 ? true : false);
      isChecked8_03 = (widget.rpta_08 == 3 ? true : false);
      isChecked8_04 = (widget.rpta_08 == 4 ? true : false);

      //Fila Pregunta 09;
      isChecked9_01 = (widget.rpta_09 == 1 ? true : false);
      isChecked9_02 = (widget.rpta_09 == 2 ? true : false);
      isChecked9_03 = (widget.rpta_09 == 3 ? true : false);
      isChecked9_04 = (widget.rpta_09 == 4 ? true : false);

      //Fila Pregunta 10;
      isChecked10_01 = (widget.rpta_10 == 1 ? true : false);
      isChecked10_02 = (widget.rpta_10 == 2 ? true : false);
      isChecked10_03 = (widget.rpta_10 == 3 ? true : false);
      isChecked10_04 = (widget.rpta_10 == 4 ? true : false);

      //Fila Pregunta 11;
      isChecked11_01 = (widget.rpta_11 == 1 ? true : false);
      isChecked11_02 = (widget.rpta_11 == 2 ? true : false);
      isChecked11_03_1 = (widget.rpta_11 == 3 ? true : false);
      isChecked11_04 = (widget.rpta_11 == 4 ? true : false);

      RespuestaPreg_01 = widget.rpta_01;
      RespuestaPreg_02 = widget.rpta_02;
      RespuestaPreg_03 = widget.rpta_03;
      RespuestaPreg_04 = widget.rpta_04;
      RespuestaPreg_05 = widget.rpta_05;
      RespuestaPreg_06 = widget.rpta_06;
      RespuestaPreg_07 = widget.rpta_07;
      RespuestaPreg_08 = widget.rpta_08;
      RespuestaPreg_09 = widget.rpta_09;
      RespuestaPreg_10 = widget.rpta_10;
      RespuestaPreg_11 = widget.rpta_11;

    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.76,
      child:
      isSuccess
          ?Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.height * 0.025),
        child: Column(
          children: <Widget>[
            Icon(Icons.check, color: Primary.azul, size: 40),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Text("Actualización completada!.",
                style: TextStyle(
                    color: Primary.azul, fontWeight: FontWeight.bold))
          ],
        ),
      )
          :SingleChildScrollView(
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
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('I. Realiza la pauta estilo AGROVISION de manera correcta..', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('II. Explica y demuestra a la vez en orden y con claridad los pasos o etapas de la labor.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('III. Enuncia con orden y claridad los parámetros de calidad o indicadores de la labor que realizan.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('IV. Narra una situación desde la perspectiva de otra persona.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('V. Identifica el rendimiento de sus colaboradores y los ubica en las áreas adecuadas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('VI. Comenta cómo se sentiría la otra persona en una situación imaginaria.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Text('VII. Brinda ordenes con voz clara, alta y con energía.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Text('VIII. Enseña a los demás por iniciativa propia.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Text('IX. Las personas lo buscan para resolver sus dudas.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Text('X. Trata a las personas con respeto, sin levantar la voz ni molestarse', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
          Divider(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.010),
          Row(
            children: <Widget>[
              Expanded(child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Text('XI. Emite sus ideas de forma estructurada y lógica.', textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),

                  Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
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
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt1),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt2),
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
                                              style: TextStyle( fontSize: 16)),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt3),
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
                                      onTap: (){
                                        setState(() {
                                        });
                                      },
                                      child: Row(
                                        children: <Widget>[

                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColorOpt4),
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
              child: Text("Actualizar",
                  style: TextStyle(
                      color: Primary.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17)),
            ),
            onPressed: () async {
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

              await updateRespuestasInterno(_map_respuesta);
            },
          )
        ],
      ),
    ),

      ),
    );


  }
}

class SelectCapacitacion extends StatefulWidget {
  final int rpta_01,rpta_02,rpta_03,rpta_04,rpta_05,rpta_06;
  final int codigoResultado ;
  final int tamanioList ;
  final String tipo_concepto ;
  final String tipo_accion ;
  final String proceso;
  const SelectCapacitacion(this.rpta_01,this.rpta_02,this.rpta_03,this.rpta_04,this.rpta_05,
      this.rpta_06,this.codigoResultado,this.tamanioList,this.tipo_concepto,this.tipo_accion,this.proceso);


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


  String capacitacionlidSelected = 'Liderazgo Capacitación 1';


  int valor = 1;
  int codigoResultado = 0;
  int tamanioList = 0;
  final textOpt1_ = " No sabe que tiene que hacerlo.";
  final textOpt2_ = " Lo sabe, pero no lo hace.";
  final textOpt3_ = " Lo hace con esfuerzo.";
  final textOpt4_ = " Lo hace de manera natural.";

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
  Future<bool> showExitActualizar() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
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
                  Text("Actualización exitosa",textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }) ??
        false; //if showDialouge had returned null, then return false
  }
  Future<bool> showExitRegistrar() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
            Navigator.pushReplacementNamed(context, 'listLidirazgoCampo');

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

  Future<void> _updateRespuestas(int idresultado,int pregunta,int respuesta) async {
    await DBProvider.db.updateRespuesta(idresultado,pregunta,respuesta);
  }

  Future<void> _RegistrarCapaRespuestas(int resultado, int pregunta, int respuesta,String concepto, String tipo_concepto, String  fecha,
      String hora) async {
    await DBProvider.db.registrarRespuestaCapacitacion(resultado,pregunta,respuesta,concepto,tipo_concepto,fecha,hora);
  }
  Future<void> _updateResultadoCapacitacion(int resultado, String capacitacion) async {
    await DBProvider.db.updateResultadoCapacitacion(resultado,capacitacion);
  }

  Future<void> updateRespuestasInterno ( Map<String, dynamic> _map_respuesta,String tipo,String proceso,String _tipo_concepto_) async {

    final fechaActual = DateFormat("yyyy-MM-dd").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parseUTC(DateTime.now().toString())
            .toUtc());
    final HoraActual = DateFormat("HH:mm:ss").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parseUTC(DateTime.now().toString())
            .toUtc());

    for (var i = 0; i < _map_respuesta.length; i++) {
      int respuesta = _map_respuesta["rpta_"+(i+1).toString()];
      if(tipo == 'A'){
        await _updateRespuestas(codigoResultado,(i+1),respuesta);
      }else{
        String tipo_concepto_00 = _tipo_concepto_.replaceAll('Liderazgo','L');
        String tipo_concepto_01 = tipo_concepto_00.replaceAll('Inteligencia Emocional','IE');
        String tipo_concepto = tipo_concepto_01+'-NOTA INICIAL EVALUADOR';
        if(proceso != '0'){
          tipo_concepto = tipo_concepto_01+'-NOTA FINAL EVALUADOR';
        }
        await _RegistrarCapaRespuestas(codigoResultado,(i+1),respuesta,'CAPACITACION',tipo_concepto,fechaActual,HoraActual);
      }
    }
    if(tipo == "R"){
      if(proceso == '0'){
        proceso = '3';
      }else{
        proceso =  '4';
      }
      await _updateResultadoCapacitacion (codigoResultado,proceso);
    }
    Navigator.of(context).pop();

    if(tipo == "R"){
      showExitRegistrar();
    }else{
      showExitActualizar();
    }
  }

  @override
  Widget build(BuildContext context) {


    if(valor == 1){
      valor = 0;
      codigoResultado = widget.codigoResultado;
      tamanioList = widget.tamanioList;
      isChecked1_01 = (widget.rpta_01 == 1 ? true : false);
      isChecked1_02 = (widget.rpta_01 == 2 ? true : false);
      isChecked1_03 = (widget.rpta_01 == 3 ? true : false);
      isChecked1_04 = (widget.rpta_01 == 4 ? true : false);

      //Fila Pregunta 02;
      isChecked2_01 = (widget.rpta_02 == 1 ? true : false);
      isChecked2_02 = (widget.rpta_02 == 2 ? true : false);
      isChecked2_03 = (widget.rpta_02 == 3 ? true : false);
      isChecked2_04 = (widget.rpta_02 == 4 ? true : false);

      //Fila Pregunta 03;
      isChecked3_01 = (widget.rpta_03 == 1 ? true : false);
      isChecked3_02 = (widget.rpta_03 == 2 ? true : false);
      isChecked3_03 = (widget.rpta_03 == 3 ? true : false);
      isChecked3_04 = (widget.rpta_03 == 4 ? true : false);

      //Fila Pregunta 04;
      isChecked4_01 = (widget.rpta_04 == 1 ? true : false);
      isChecked4_02 = (widget.rpta_04 == 2 ? true : false);
      isChecked4_03 = (widget.rpta_04 == 3 ? true : false);
      isChecked4_04 = (widget.rpta_04 == 4 ? true : false);

      //Fila Pregunta 05;
      isChecked5_01 = (widget.rpta_05 == 1 ? true : false);
      isChecked5_02 = (widget.rpta_05 == 2 ? true : false);
      isChecked5_03 = (widget.rpta_05 == 3 ? true : false);
      isChecked5_04 = (widget.rpta_05 == 4 ? true : false);

      //Fila Pregunta 06;
      isChecked6_01 = (widget.rpta_06 == 1 ? true : false);
      isChecked6_02 = (widget.rpta_06 == 2 ? true : false);
      isChecked6_03 = (widget.rpta_06 == 3 ? true : false);
      isChecked6_04 = (widget.rpta_06 == 4 ? true : false);


      RespuestaPreg_01 = widget.rpta_01;
      RespuestaPreg_02 = widget.rpta_02;
      RespuestaPreg_03 = widget.rpta_03;
      RespuestaPreg_04 = widget.rpta_04;
      RespuestaPreg_05 = widget.rpta_05;
      RespuestaPreg_06 = widget.rpta_06;

    }
    capacitacionlidSelected = widget.tipo_concepto;
    String msn_accion = (widget.tipo_accion == 'R' ? 'Registrar' : 'Actualizar');
    String tipo_accion = widget.tipo_accion;
    String tipo_concepto_ = widget.tipo_concepto;
    String proceso = widget.proceso;

    if (capacitacionlidSelected == "Liderazgo Capacitación 1") {
      setState(() => {
        isVistaCap1 = true,
        isVistaCap2 = false,
        isVistaCap3 = false,
        isVistaCap4 = false,
        isVistaCap5 = false,
      });
    } else if (capacitacionlidSelected == "Liderazgo Capacitación 2") {
      setState(() => {
        isVistaCap1 = false,
        isVistaCap2 = true,
        isVistaCap3 = false,
        isVistaCap4 = false,
        isVistaCap5 = false,
      });
    } else if (capacitacionlidSelected == "Liderazgo Capacitación 3") {
      setState(() => {
        isVistaCap1 = false,
        isVistaCap2 = false,
        isVistaCap3 = true,
        isVistaCap4 = false,
        isVistaCap5 = false,
      });
    } else if (capacitacionlidSelected == "Inteligencia Emocional Capacitación 4") {
      setState(() => {
        isVistaCap1 = false,
        isVistaCap2 = false,
        isVistaCap3 = false,
        isVistaCap4 = true,
        isVistaCap5 = false,
      });
    } else if (capacitacionlidSelected == "Inteligencia Emocional Capacitación 5") {
      setState(() => {
        isVistaCap1 = false,
        isVistaCap2 = false,
        isVistaCap3 = false,
        isVistaCap4 = false,
        isVistaCap5 = true,
      });
    }


    return Container(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: isSuccess
                  ?Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.025),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.check, color: Primary.azul, size: 40),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    Text("Actualización completada!.",
                        style: TextStyle(
                            color: Primary.azul, fontWeight: FontWeight.bold))
                  ],
                ),
              )
                  :isVistaCap1
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.70,
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
                        child: Text(msn_accion,
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
                          await updateRespuestasInterno(_map_respuesta,tipo_accion,proceso,tipo_concepto_);
                        }
                      },
                    )
                  ],
                ),
              )
                  : isVistaCap2
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.70,
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
                        child: Text(msn_accion,
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
                          await updateRespuestasInterno(_map_respuesta,tipo_accion,proceso,tipo_concepto_);
                        }
                      },
                    )
                  ],
                ),
              )
                  : isVistaCap3
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.70,
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
                        child: Text(msn_accion,
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
                          await updateRespuestasInterno(_map_respuesta,tipo_accion,proceso,tipo_concepto_);
                        }
                      },
                    )
                  ],
                ),
              )
                  : isVistaCap4
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.70,
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
                        child: Text(msn_accion,
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
                          await updateRespuestasInterno(_map_respuesta,tipo_accion,proceso,tipo_concepto_);
                        }
                      },
                    )
                  ],
                ),
              )
                  : Container(
                height: MediaQuery.of(context).size.height * 0.70,
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
                        child: Text(msn_accion,
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
                          await updateRespuestasInterno(_map_respuesta,tipo_accion,proceso,tipo_concepto_);
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


//Contenido de Evaluación de Satisfacción
class SelectCapacitacionSatisfaccion extends StatefulWidget {
  final int codigoResultado ;
  final int tamanioList ;
  final String tipo_concepto ;
  final String tipo_accion ;
  final String proceso;
  const SelectCapacitacionSatisfaccion(this.codigoResultado,this.tamanioList,this.tipo_concepto,this.tipo_accion,this.proceso);


  @override
  _SelectCapacitacionSatisfaccionState createState() => _SelectCapacitacionSatisfaccionState();
}

class _SelectCapacitacionSatisfaccionState extends State<SelectCapacitacionSatisfaccion> {
  String error = "";
  bool isLoading = false;
  bool isError = false;
  bool isSuccess = false;

  bool isVistaCap1 = true;

   int valor = 1;
  int vr_codigoResultado = 0;
  int tamanioList = 0;
  final TextEditingController txtEvaluacionIngresada =new TextEditingController();
  final TextEditingController txtEvaluacion =new TextEditingController();
  final TextEditingController txtObservacion =new TextEditingController();


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

  Future<bool> showExitPopupEvaSatisf(mensaje_evaluacion_observacion) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) => AlertDialog(
        title: Text("Completar Campo",
            textAlign: TextAlign.center,
            style: TextStyle(
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              // letterSpacing: 6.0,
            )),
        content: Text(mensaje_evaluacion_observacion),
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
  Future<bool> showExitActualizar() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
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
                  Text("Actualización exitosa",textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }) ??
        false; //if showDialouge had returned null, then return false
  }
  Future<bool> showExitRegistrar() async {
    return await
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
            Navigator.pushReplacementNamed(context, 'listLidirazgoCampo');

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

  Future<void> _updateRespuestas(int idresultado,int pregunta,int respuesta) async {
    await DBProvider.db.updateRespuesta(idresultado,pregunta,respuesta);
  }

  Future<void> _RegistrarCapaRespuestasSatisfaccion(int resultado, int pregunta, int respuesta,String concepto, String tipo_concepto, String  fecha,
      String hora, String satisfaccion,String observacion) async {
    await DBProvider.db.registrarRespuestaCapacitacionSatisfaccion(resultado,pregunta,respuesta,concepto,tipo_concepto,fecha,hora,satisfaccion,observacion);
  }
  Future<void> _updateResultadoCapacitacion(int resultado, String capacitacion) async {
    await DBProvider.db.updateResultadoCapacitacion(resultado,capacitacion);
  }

  Future<void> addRegistroRespuestasInternoSatisfaccion (int selec_codigoResultado, String evaluacionSatisfaccion,String tipo,String proceso,String _tipo_concepto_,String observacion) async {

    print(observacion);
    final fechaActual = DateFormat("yyyy-MM-dd").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parseUTC(DateTime.now().toString())
            .toUtc());
    final HoraActual = DateFormat("HH:mm:ss").format(
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parseUTC(DateTime.now().toString())
            .toUtc());


    String tipo_concepto_00 = _tipo_concepto_.replaceAll('Liderazgo','L');
    String tipo_concepto_01 = tipo_concepto_00.replaceAll('Inteligencia Emocional','IE');
    String tipo_concepto = tipo_concepto_01+'-EVALUACION SATISFACCION';


    await _RegistrarCapaRespuestasSatisfaccion(selec_codigoResultado,1,1,'CAPACITACION',tipo_concepto,fechaActual,HoraActual,evaluacionSatisfaccion,observacion);

    String valor_proceso =  '5';

    await _updateResultadoCapacitacion (selec_codigoResultado,valor_proceso);
    Navigator.of(context).pop();
    showExitRegistrar();

  }

  @override
  Widget build(BuildContext context) {


    String msn_accion = (widget.tipo_accion == 'R' ? 'Registrar' : 'Actualizar');
    String tipo_accion = widget.tipo_accion;
    String tipo_concepto_ = widget.tipo_concepto;
    String proceso = widget.proceso;
    int codigoResultado = widget.codigoResultado;



    return Container(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Center(
              child: isSuccess
                  ?Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.025),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.check, color: Primary.azul, size: 40),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    Text("Actualización completada!.",
                        style: TextStyle(
                            color: Primary.azul, fontWeight: FontWeight.bold))
                  ],
                ),
              )
                  :isVistaCap1
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.70,
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

                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  'Evaluación:',
                                                  textAlign:TextAlign.justify,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
                                                  alignment:Alignment.centerLeft,
                                              ),
                                              TextFormField(
                                                controller:txtEvaluacion,
                                                decoration:const InputDecoration(
                                                  hintText:'Ingrese evaluación',
                                                ),
                                                textAlign:TextAlign.left,
                                                style: TextStyle(fontSize:15),
                                                onChanged: (text) {
                                                  //print('First text field: $text');
                                                  //var long2 = double.parse('$text');
                                                  this.txtEvaluacionIngresada.text = '$text'+"%";
                                                },
                                                keyboardType:TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                                                  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: < Widget>[
                                              Container(
                                                child: Text(
                                                    'Eva. Ingresada:',
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(fontWeight: FontWeight .bold,fontSize:15)),
                                                alignment:Alignment.centerLeft,
                                              ),
                                              TextFormField(
                                                controller:txtEvaluacionIngresada,
                                                decoration:const InputDecoration(
                                                  hintText: '',
                                                ),
                                                readOnly:true,
                                                enabled: false,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontSize: 15),
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
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.010),
                    Divider(),

                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.010),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                    'Observación:',
                                                    textAlign:TextAlign.justify,
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize:15)),
                                                alignment:Alignment.centerLeft,
                                              ),
                                              TextFormField(
                                                controller:txtObservacion,
                                                decoration:const InputDecoration(
                                                  hintText:'Ingrese Observación',
                                                ),
                                                maxLines: 4, // <-- SEE HERE
                                                minLines: 4,
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
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.010),


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
                        child: Text(msn_accion,
                            style: TextStyle(
                                color: Primary.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ),
                      onPressed: () async {
                        bool validate = true;

                        if(txtEvaluacion.text == null || txtEvaluacion.text == ""){
                          validate = false;
                          showExitPopupEvaSatisf("Ingrese la evaluación de satisfacción");
                        }else if(txtObservacion.text == null || txtObservacion.text == ""){
                          validate = false;
                          //showExitPopupEvaSatisf("Ingrese la evaluación de satisfacción");
                          showExitPopupEvaSatisf("Ingrese Observación");
                        }


                        if (validate == true) {
                          await addRegistroRespuestasInternoSatisfaccion(codigoResultado,txtEvaluacionIngresada.text,tipo_accion,proceso,tipo_concepto_,txtObservacion.text);
                        }
                      },
                    )
                  ],
                ),
              )
                  : null
            )
          ],
        ));
  }
}



