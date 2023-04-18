
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/providers/db_liderazgo_rrhh.dart';
import 'package:rrhh/src/providers/input_decorations.dart';
import 'package:rrhh/src/providers/login_form_provider.dart';
import 'package:rrhh/src/tema/primary.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool cargando = false;
  bool logeado = false;
  bool sevaluadores = false;
  String dni = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Map<String, dynamic>> _lSesion = [];
  String usuarioLogeado = "No Leido";

  void _iniciarSesion(String dni) async {
    //final data = await SQLHelper.getItems();
    final data = await DBProvider.db.getSesion(dni);
    setState(() {
      _lSesion = data;
    });
    print(_lSesion.length);
    if(_lSesion.length>=1){
      print("Ingreso");
      await DBProvider.db.setSesion(_lSesion[0]['idevaluador'], _lSesion[0]['dni'], _lSesion[0]['nombres']);
      Navigator.pushReplacementNamed(context, 'home');
    }else{

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Usuario no registrado!',textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color:Colors.red)),
      ));

    }
  }
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final loginForm = Provider.of<LoginFormProvider>(context);
    final txtDniLogin = TextEditingController();
    txtDniLogin.text= "-";

    return Container(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.003),
          Container(
            child: Text('Iniciar Sesión', style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.bold, color: Primary.black)),
          ),
          SizedBox(height: size.height * 0.007),
          Form(
            key: loginForm.formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Row(
              children: [
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.people_alt_rounded, color: Primary.azul,),
                      SizedBox(width: size.height * 0.01),
                      Text("DNI: ", style: TextStyle(fontSize: size.height * 0.0175, fontWeight: FontWeight.bold, color: Primary.black)),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: Container(
                      child: TextFormField(
                        //controller: txtDniLogin,
                        autocorrect: false,
                        keyboardType: TextInputType.phone,
                        maxLength: 8,
                        cursorColor: Primary.azul,
                        textInputAction: TextInputAction.send,
                        textAlign: TextAlign.center,
                        decoration: InputDecorations.loginInputDecoration(hintText: "DNI", labelText: "DNI"),
                        onChanged: (value) => loginForm.dni = value,
                        style: TextStyle(color: Primary.azul, fontWeight: FontWeight.bold, fontSize: 17),
                        textAlignVertical: TextAlignVertical.bottom,
                        onFieldSubmitted: (value){
                          _iniciarSesion(loginForm.dni);
                        },
                        validator: (value) {
                          String pattern = r'^\d{8}$';
                          RegExp regExp  = new RegExp(pattern);

                          return regExp.hasMatch(value ?? '')
                              ? null
                              : 'DNI INCORRECTO.';
                        },
                      ),
                    )
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                      onPressed: loginForm.isLoading ? null : () async {

                       // print(loginForm.dni);
                        _iniciarSesion(loginForm.dni);


                      },
                      child: loginForm.isLoading
                          ? SizedBox(child: CircularProgressIndicator(color: Primary.white, strokeWidth: 2), width: 15, height: 15)
                          : Icon(Icons.login_sharp),
                      style: ElevatedButton.styleFrom(
                          primary: Primary.azul, onPrimary: Primary.white, fixedSize: Size(30, 20)
                      )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}