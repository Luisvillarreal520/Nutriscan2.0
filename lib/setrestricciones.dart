import 'package:flutter/material.dart';
import 'package:flutter_application_1/base_de_datos/maindata.dart';
import 'package:flutter_application_1/base_de_datos/restricciones.dart';

class Setrestricciones extends StatefulWidget {
  final VoidCallback alFinalizar;

  const Setrestricciones({
    super.key,
    required this.alFinalizar,
  });

  @override
  State<Setrestricciones> createState()=> SetrestriccionesState();

}

class SetrestriccionesState extends State<Setrestricciones>{
  final MainData bd= MainData();


late Future<List<Restricciones>> _futuroRestricciones;

@override

void initState(){
  super.initState();

  _futuroRestricciones =bd.consultarRestricciones();
}

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

          const Text(
            'Condiciones de salud',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...restricciones
              .where((r) => r.tipoCondicion == 'condicion')
              .map((r) {

            return CheckboxListTile(
              title: Text(r.valorNombre),
              value: r.seleccionar == 1,
              onChanged: (valor) async {

                if (valor == null) return;

                setState(() {
                  r.seleccionar = valor ? 1 : 0;
                });

                await bd.actualizarRestriccion(r);
              },
            );
          }),

          const SizedBox(height: 20),

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

                if (valor == null) return;

                setState(() {
                  r.seleccionar = valor ? 1 : 0;
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
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Configuración alimentaria'),
      centerTitle: true,
    ),

    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              '¡Personaliza tu experiencia!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Configura tus restricciones alimentarias y descubre productos adecuados para ti',
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 25),

            mostrarRestricciones(),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.alFinalizar,
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


}