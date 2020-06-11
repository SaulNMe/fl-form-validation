import 'dart:convert';

import 'package:form_validation/src/shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebaseKey = 'AIzaSyBDzo1xYJ1Q52vk4YgqPi7cTPZ_TiiVHLI';
  final _prefs = PreferenciasUsuario();

  Future<Map<String,dynamic>> login(String email, String password) async {
    final authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };

    final res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(res.body);
    print(decodedResp);
    if(decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];

      return {
        "ok": true,
        "token": decodedResp['idToken']
      };
    } else {
      return {
        "ok": false,
        "mensaje": decodedResp['error']['message']
      };

    }
  }

  Future<Map<String,dynamic>> nuevoUsuario(String email, String password) async {
    final authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };

    final res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(res.body);
    if(decodedResp.containsKey('idToken')) {
      return {
        "ok": true,
        "token": decodedResp['idToken']
      };
    } else {
      return {
        "ok": false,
        "mensaje": decodedResp['error']['message']
      };

    }
  }

}