import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';



class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();

}  
  
 
/*
  para subir imagenes 

  https://cloudinary.com/documentation/image_upload_api_reference
  https://cloudinary.com/documentation/upload_images#uploading_with_a_direct_call_to_the_rest_api

 */

class _ProductoPageState extends State<ProductoPage>{
  
  final formkey = GlobalKey<FormState>();
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();

 
  final picker =  ImagePicker();
  File foto ;
   


  ProductoModel producto = new ProductoModel();

  //para prevenir que aprieten dos veces el boton de guardar
  bool _guardando = false;


  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null){
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
                icon: Icon( Icons.photo_size_select_actual ), 
                onPressed: _seleccionarFoto
          ),
           IconButton(
                icon: Icon( Icons.camera_alt ), 
                onPressed: _tomarFoto
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ) ,
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
          if( value.length < 3 ){
            return 'Ingrese el nombre del producto';
          }else{
            return null;
          }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType:  TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ) ,
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value){
        if( utils.isNumeric(value)  ){
            return null;
        }else{
            return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      textColor: Colors.white,
                      color: Colors.deepPurple,
                      label: Text('Guardar'),
                      onPressed: (_guardando) ? null :  _submit, 
                      icon: Icon(Icons.save), 
                    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value)=> {
        setState((){
          producto.disponible = value;
        }),
      }
    );
  }
  void _submit() async {

    if(!formkey.currentState.validate()) return;
    formkey.currentState.save();// va a guardar todos los save del formulario

    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);
    print('Todo OK');
    setState(() {
    _guardando = true;
      
    });

    if(foto != null) {
       producto.fotoUrl =  await productoProvider.subirImagen(foto);
    }

    if(producto.id == null){
      productoProvider.crearProducto(producto);
    }else{
      productoProvider.editarProducto(producto);
    }
    //setState(() {      _guardando = false;    });
    mostrarSnackbar('Registro Guardado');

    Navigator.pop(context);
    
  }

  void mostrarSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),

    );
    scaffoldkey.currentState.showSnackBar(snackbar);
  }


  Widget _mostrarFoto(){

    
    
    if(producto.fotoUrl != null){
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar_loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {

      if(foto != null){
          return Image.file(
          foto,
          height: 300,
          fit: BoxFit.cover,
          );
      }else {
        return Image(
          image: AssetImage( 'assets/no_image.png' ), //operador ternario foto? si es diferente de null 
          height: 300.0,
          fit: BoxFit.cover,
        );
      }    
     /*
      return Center(
        child: foto == null
            ? Text('No image selected.')
            : Image.file(foto),
      );
      */
     /*  return Image(
        image: AssetImage( urlFoto ), //operador ternario foto? si es diferente de null 
        height: 300.0,
        fit: BoxFit.cover,
      ); */
      
    }
  }


  _seleccionarFoto()async{
    _procesarImagen(ImageSource.gallery);
  }
 
 _tomarFoto()async{
   _procesarImagen(ImageSource.camera);
 }
 
_procesarImagen(ImageSource origen)async{
   foto = null;
   final imagen = await picker.getImage(source: origen);
   
    if (imagen != null){
      foto=File(imagen.path);

     
      //limpieza
    }

 
    setState(() {
      
    });
 }


  
}