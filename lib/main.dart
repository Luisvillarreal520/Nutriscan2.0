import 'package:flutter/material.dart';
import 'package:flutter_application_1/base_de_datos/maindata.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/scanner.dart';
import 'package:flutter_application_1/productos.dart';
import 'package:flutter_application_1/perfil.dart';
import 'package:flutter_application_1/setrestricciones.dart';


void main(List<String> args) async{
 
 WidgetsFlutterBinding.ensureInitialized();
 MainData bd=MainData();

 await bd.crearUsuarioInicial();
 await bd.crearRestriccionIniciales();
 await bd.crearProductosIniciales();



  runApp(Nutriscan());
}

class Nutriscan extends StatefulWidget{
  const Nutriscan({super.key});

  @override 
  State<Nutriscan>createState()=>NutriscanState();
}

class NutriscanState extends State<Nutriscan> {

int _indiceActual=0;
bool _sesionIniciada=false;
bool _configuracionCompletada=false;

 late final List<Widget>_vistas=  [
  const scanner(),
  productos(),
  const perfil(),
 
];


void _cambiarVista(int indice){
  setState(() {
    _indiceActual=indice;
  });
}

void iniciarSesion(){
  setState(() {
    _sesionIniciada=true;
    _configuracionCompletada=false;
  });
}

void finalizarConfiguracion(){
  setState(() {
    _configuracionCompletada = true;
    _indiceActual = 0;
  });
}

  @override
  Widget build (BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NutriScan Express',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),

      home: !_sesionIniciada

      ?Login(alIniciarSesion: iniciarSesion)
      : !_configuracionCompletada
        ? Setrestricciones(
          alFinalizar: finalizarConfiguracion,
        )
          :Scaffold(
        appBar: AppBar(
          title: const Text('Nutriscan Express'),
          centerTitle: true,
          elevation: 2,
        ),

        body: _vistas[_indiceActual],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceActual,
          onTap: _cambiarVista,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,

          items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner),
              label: 'Escanear', ),

              BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_rounded),
              label: 'Productos', ),

              BottomNavigationBarItem(
              icon: Icon(Icons.person_3),
              label: 'Perfil', ),


          ],
        ),
      )
     
    );
  }

  




}

