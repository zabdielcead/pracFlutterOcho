import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
class HomePage extends StatelessWidget {
  
 // para obtener imagenes del celular se utilizara el image_picker 
 // https://pub.dev/packages/image_picker#-installing-tab-
    final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home')        
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
              future: productosProvider.cargarProductos(),
              builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
                if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) => _crearItem(context, snapshot.data[i]),
                    );
                }else {
                  return Center(child: CircularProgressIndicator());
                }

               
              }

           );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto){
    return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direccion) {
            productosProvider.borrarProducto(producto.id);
          },
          child: ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
          ),
    );
  }
}