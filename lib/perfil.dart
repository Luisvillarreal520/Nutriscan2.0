import 'package:flutter/material.dart';
import 'package:flutter_application_1/base_de_datos/maindata.dart';
import 'package:flutter_application_1/base_de_datos/usuario.dart';
import 'package:flutter_application_1/base_de_datos/restricciones.dart';

class perfil extends StatefulWidget{
  const perfil ({super.key});

  @override
State<perfil> createState()=> perfilState();
}



class perfilState extends State<perfil>{

  final MainData bd= MainData();

  late Future<List<Restricciones>> _futuroRestricciones;

@override
void initState(){
  super.initState();
  _futuroRestricciones=bd.consultarRestricciones();
}

  Widget mostrarPerfil(){
    return FutureBuilder<Usuario?>(
      future: bd.consultarUsuario(),

      builder: (context, snapshot){

        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!snapshot.hasData || snapshot.data == null){
          return const Text('No se encontró informacion del usuario');
        }
        Usuario usuario= snapshot.data!;

        return Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.cyan.shade100,
              child: const Icon(
                Icons.person,
                size: 65,
                color: Colors.cyan,
                ),
            ),
            const SizedBox(height: 15),

            Text(
              usuario.nombreUsuario,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Desarrollador',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              ),
              const SizedBox(height: 10),

              const Text('Configura tus restricciones alimentarias y descubre productos adecuados para ti',
              textAlign: TextAlign.center,
              ),
          ],
        );
      },
    );
  }
  // Metodo para mostrar las restricciones

Widget mostrarRestricciones() {
  return FutureBuilder<List<Restricciones>>(
    future: _futuroRestricciones,

    builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text('No hay restricciones disponibles');
      }

      List<Restricciones> restricciones = snapshot.data!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        //checkbox para las condiciones de salud

         const Text(
         'Condiciones de salud',
         style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
         ),
         ),

         const SizedBox(height: 10),

         ...restricciones
         .where((r) => r.tipoCondicion =='condicion')
         .map((r){
          return CheckboxListTile(
            title: Text(r.valorNombre),
            value: r.seleccionar==1,
            onChanged: (valor) async {
              setState(() {
                r.seleccionar = valor! ? 1 : 0;
              });

              await bd.actualizarRestriccion(r);
            },
          );
          

         }         
         ),

          const SizedBox(height: 20),

          // checkbox para las alergias

const Text(
  'Alergias e intolerancias',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

...restricciones
    .where((r) => r.tipoCondicion == 'alergia')
    .map((r) {
      return CheckboxListTile(
        title: Text(r.valorNombre),

        value: r.seleccionar == 1,

        onChanged: (valor) async {

          setState(() {
            r.seleccionar = valor! ? 1 : 0;
          });

          await bd.actualizarRestriccion(r);
        },
      );
    }),

        ],
      );
    },
  );
}
  

  @override
  Widget build (BuildContext context){
    return Scaffold(
       body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              mostrarPerfil(),             
              const SizedBox(height: 30),

              mostrarRestricciones(),

              

            ],
          ),
        ),
       )
    );
  }
}