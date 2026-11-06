import 'package:flutter/material.dart';
import 'package:flutter_application_1/base_de_datos/articulosinfo.dart';
import 'package:flutter_application_1/productos.dart';
import 'package:flutter_application_1/base_de_datos/articulos.dart';
import 'package:flutter_application_1/veredicto.dart';
void main() {
  runApp(const PruebaProducto());
}

class PruebaProducto extends StatelessWidget {
  const PruebaProducto({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Prueba NutriScan'),
          centerTitle: true,
        ),
        body: productos(
          articulo: productosIniciales.first,
        ),
      ),
    );
  }
}