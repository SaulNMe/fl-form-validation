// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/blocs/provider.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    setState(() {
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearFloating(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream:  productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int i) => _crearItem(context, productosBloc, productos[i])
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context,ProductosBloc productosBloc, ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(color: Colors.red[100],),
      onDismissed: (direction) {
        productosBloc.borrarProducto(producto.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null) 
            ? Image(image: AssetImage('assets/img/no-image.png')) 
            : FadeInImage(
              image: NetworkImage(producto.fotoUrl), 
              placeholder: AssetImage('assets/img/jar-loading.gif'),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
                title: Text('${ producto.titulo } - ${ producto.valor }'),
                subtitle: Text('${ producto.id }'),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      )
    );
  }

  Widget _crearFloating(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.redAccent,
      onPressed: () {
        Navigator.pushNamed(context, 'producto');
      },
    );
  }
}