import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formkey=  new GlobalKey<FormState>();
  String dni = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(dni);
    print(formkey.currentState?.validate());
    return formkey.currentState?.validate() ?? false;
  }
}

