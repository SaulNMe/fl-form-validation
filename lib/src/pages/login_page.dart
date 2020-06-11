import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/providers/usuario_provider.dart';
import 'package:form_validation/src/utils/utils.dart';

class LoginPage extends StatelessWidget {

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(child: Container(height: 200.0,)),
          Container(
            width: size.width*0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Ingreso'),
                SizedBox(height: 60.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0,),
                _crearPassword(bloc),
                SizedBox(height: 30.0,),
                _crearBoton(bloc),
              ],
            ),
          ),
          FlatButton(
            child: Text('Crear una nueva cuenta'),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'registro');
            },
          ),
          SizedBox(height: 100.0,),
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.redAccent),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => bloc.changeEmail(value),
          ),
        );    
      }
    );
    
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.redAccent),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => bloc.changePassword(value),
          ),
        );
      }
    );

  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0,
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
      Map info = await usuarioProvider.login(bloc.email, bloc.password);
      if(info['ok']) {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        mostrarAlerta(context, info['mensaje']);
      }
  }

  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondo = Container(
      height: size.height *0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );

    final circulo =  Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[
        fondo,
        Positioned(child: circulo, top: 90.0, left: 30.0),
        Positioned(child: circulo, top: -40.0, right: -30.0),
        Positioned(child: circulo, bottom: -50.0, right: 10.0),
        Positioned(child: circulo, bottom: 120.0, right: 20.0),
        Positioned(child: circulo, bottom: -50.0, left: -20.0),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Saul Narvaez', style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        ),

      ],
    );
  }
}