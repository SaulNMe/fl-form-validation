import 'dart:convert';
import 'dart:io';

import 'package:form_validation/src/shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';


class ProductosProvider {

  final String _url = 'https://flutter-varios-7d3d2.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final response = await http.post(url, body: productoModelToJson(producto));

    json.decode(response.body);
    //print(decodedData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productoModelToJson(producto));

    json.decode(response.body);
    //print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final response = await http.get(url);
    final Map<String, dynamic>decodedData = json.decode(response.body); 
    final List<ProductoModel> productos = new List();

    if(decodedData == null) return [];
    if(decodedData['error'] != null) return [];

    decodedData.forEach((id, value) {
      final pTemp = ProductoModel.fromJson(value);
      pTemp.id = id;
      productos.add(pTemp);

    });

    print("datos ");

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    await http.delete(url);

    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/db5wqss0m/image/upload?upload_preset=k2cqagcg');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath('file', imagen.path, contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();

    final res = await http.Response.fromStream(streamResponse);

    if(res.statusCode != 200 && res.statusCode != 201) {
      print('Ha ocurrido un error');
      print(res.body);
      return null;
    }

    final respData = json.decode(res.body);
    print(respData);

    return respData['secure_url'];

  }

}