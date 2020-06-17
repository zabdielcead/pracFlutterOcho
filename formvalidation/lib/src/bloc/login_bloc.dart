import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  final _emailController    = BehaviorSubject<String>(); //StreamController<String>.broadcast(); estaban asi pero se cambian por Behavior
  final _passwordController = BehaviorSubject<String>();

  

  //Recuperar los datos del stream
  Stream<String> get emailStream    => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);
  Stream<bool>   get formValidStream =>  CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);


  // Insertar valores al Stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  
  // obtener el último valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

  /*
    static LoginBloc of ( BuildContext context ){
   return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
}

   */
}