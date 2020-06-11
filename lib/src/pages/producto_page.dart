import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/productos_bloc.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductosBloc productosBloc;
  bool _guardando = false;
  File foto;

  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.photo_size_select_actual
            ), 
            onPressed: _seleccionarFoto
          ),
          IconButton(
            icon: Icon(
              Icons.camera_alt
            ), 
            onPressed: _abrirCamara
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (String value) {
        return value.length == 0 ? 'Ingresa nombre del producto': null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (String s) {
        if(utils.isNumeric(s)){
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.redAccent,
      onChanged: (value) {
        setState(() {
          producto.disponible = value;
        });
      }
    );
  }

  Widget _crearSubmit() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed:  (_guardando) ? null :_submit,
      padding: EdgeInsets.symmetric(vertical:10.0, horizontal: 15.0),
    );
  }

  void _submit() async{
    if(!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {_guardando = true;});
    
    if(foto !=  null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if(producto.id != null) {
      productosBloc.editarProducto(producto);
    } else {
      productosBloc.agregarProducto(producto);
    }

    setState(() {_guardando = false;});

    _mostrarSnackbar("Registro guardado");

    Navigator.pop(context, (){setState(() {
      
    });});

  }

  void _mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      backgroundColor: Colors.green[400],
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if(producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl), 
        placeholder: AssetImage('assets/img/jar-loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      if (foto != null ) { 
        return Image.file(
          foto,
          height: 300.0,
          fit: BoxFit.cover,
        );
      }
      return Image.asset('assets/img/no-image.png', height: 300.0, fit: BoxFit.cover,);
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);

  }
  _abrirCamara() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource tipo) async {
    foto = await ImagePicker.pickImage(
      source: tipo,
    );

    if(foto != null) {
      producto.fotoUrl = null;
    }
    setState(() {});
    
  }

}