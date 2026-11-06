import 'package:flutter/material.dart';
import 'package:flutter_application_1/base_de_datos/articulos.dart';
import 'dart:convert';
import 'package:flutter_application_1/veredicto.dart';
import 'package:flutter_application_1/base_de_datos/maindata.dart';

class productos extends StatefulWidget {

  final Articulos? articulo;

 const productos({
  super.key,
 this.articulo,});

 @override
 State<productos> createState()=> productosState();
}
class productosState extends State<productos>{

//Instanciamos la base de datos
  final MainData bd = MainData();

Future<List<Map<String, dynamic>>> obtenerColeccion() async {
  return await bd.consultarProductosGuardados();
}

Widget construirColeccion() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: obtenerColeccion(),
    builder: (context, snapshot) {

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return const Center(
          child: Text('Ocurrió un error al cargar la colección.'),
        );
      }

      final registros = snapshot.data ?? [];

      if (registros.isEmpty) {
        return const Center(
          child: Text(
            'Todavía no tienes productos guardados.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: registros.length,
        itemBuilder: (context, index) {

          final registro = registros[index];
          final articulo = Articulos.fromMap(registro);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: articulo.imagen != null
                  ? Image.asset(
                      articulo.imagen!,
                      width: 55,
                      height: 55,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    )
                  : const Icon(Icons.fastfood, size: 40),

              title: Text(
                articulo.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                registro['recomendacion'] ?? 'Sin recomendación',
              ),

              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () async {
                  
                  if (articulo.id != null){
                  await bd.eliminarProductoGuardado(articulo.id!);

                  if (!mounted) return;

                  setState(() {});
                  }
                },
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => productos(
                      articulo: articulo,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    },
  );
}



  //convertimos los sellos almacenados en formato json para usarlos mas adelante
List<String>obtenerSellos(){
  final datos = widget.articulo?.sellosAdvertencia;

  if(datos== null || datos.isEmpty){
    return [];
  }

  try{
    return List<String>.from(jsonDecode(datos));
  } catch (e) {
    return [];
  }
}

//contruimos la una fila para la informacion nutricional

Widget filaNutricional(String nombre, String cantidad) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(nombre),
           ),
           Text(
            cantidad,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
           )
      ],
    ),
    );
}

//contruimos la tabla nutricional

Widget tablaNutricional(
  String titulo,
  List<Map<String,String>> nutrientes,

) {
  return Card(
    elevation: 2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
            )
          ),
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        ...nutrientes.asMap().entries.map((entrada)
        {
          return Column(
            children: [
              filaNutricional(
                entrada.value['nombre']!,
                entrada.value['cantidad']!,
              ),

              if(entrada.key != nutrientes.length -1)
              const Divider(height: 1),
            ],
          );
        }
        ),
      ],
    ),
  );
}



@override
Widget build (BuildContext context){

  // validacion por si no se ha escaneado ningun producto

  if(widget.articulo==null){
    return construirColeccion();
  }

  final articulo =widget.articulo!;
  final sellos = obtenerSellos();

//cargamos la informacion nutricional por cada 100 gramos.

final nutrientes100g = [
      {'nombre': 'Calorías', 'cantidad': '${articulo.caloriasPor100g ?? '-'} kcal'},
      {'nombre': 'Grasa total', 'cantidad': '${articulo.grasaTotalPor100g ?? '-'} g'},
      {'nombre': 'Grasa saturada', 'cantidad': '${articulo.grasaSaturadaPor100g ?? '-'} g'},
      {'nombre': 'Grasa trans', 'cantidad': '${articulo.grasaTransPor100g ?? '-'} mg'},
      {'nombre': 'Carbohidratos', 'cantidad': '${articulo.carbohidratosPor100g ?? '-'} g'},
      {'nombre': 'Fibra dietaria', 'cantidad': '${articulo.fibraDietariaPor100g ?? '-'} g'},
      {'nombre': 'Azúcares totales', 'cantidad': '${articulo.azucaresTotalesPor100g ?? '-'} g'},
      {'nombre': 'Proteína', 'cantidad': '${articulo.proteinaPor100g ?? '-'} g'},
      {'nombre': 'Sodio', 'cantidad': '${articulo.sodioPor100g ?? '-'} mg'},
      {'nombre': 'Vitamina A', 'cantidad': '${articulo.vitaminaAPor100g ?? '-'} µg ER'},
      {'nombre': 'Vitamina D', 'cantidad': '${articulo.vitaminaDPor100g ?? '-'} µg ER'},
      {'nombre': 'Hierro', 'cantidad': '${articulo.hierroPor100g ?? '-'} mg'},
      {'nombre': 'Calcio', 'cantidad': '${articulo.calcioPor100g ?? '-'} mg'},
      {'nombre': 'Zinc', 'cantidad': '${articulo.zincPor100g ?? '-'} mg'},
    ];

    //cargamos la informacion nutricional por porcion

    final nutrientesPorcion = [
      {'nombre': 'Calorías', 'cantidad': '${articulo.caloriasPorPorcion ?? '-'} kcal'},
      {'nombre': 'Grasa total', 'cantidad': '${articulo.grasaTotalPorPorcion ?? '-'} g'},
      {'nombre': 'Grasa saturada', 'cantidad': '${articulo.grasaSaturadaPorPorcion ?? '-'} g'},
      {'nombre': 'Grasa trans', 'cantidad': '${articulo.grasaTransPorPorcion ?? '-'} mg'},
      {'nombre': 'Carbohidratos', 'cantidad': '${articulo.carbohidratosPorPorcion ?? '-'} g'},
      {'nombre': 'Fibra dietaria', 'cantidad': '${articulo.fibraDietariaPorPorcion ?? '-'} g'},
      {'nombre': 'Azúcares totales', 'cantidad': '${articulo.azucaresTotalesPorPorcion ?? '-'} g'},
      {'nombre': 'Proteína', 'cantidad': '${articulo.proteinaPorPorcion ?? '-'} g'},
      {'nombre': 'Sodio', 'cantidad': '${articulo.sodioPorPorcion ?? '-'} mg'},
      {'nombre': 'Vitamina A', 'cantidad': '${articulo.vitaminaAPorPorcion ?? '-'} µg ER'},
      {'nombre': 'Vitamina D', 'cantidad': '${articulo.vitaminaDPorPorcion ?? '-'} µg ER'},
      {'nombre': 'Hierro', 'cantidad': '${articulo.hierroPorPorcion ?? '-'} mg'},
      {'nombre': 'Calcio', 'cantidad': '${articulo.calcioPorPorcion ?? '-'} mg'},
      {'nombre': 'Zinc', 'cantidad': '${articulo.zincPorPorcion ?? '-'} mg'},
    ];

      return Container(
        color: Colors.white,
        child: SingleChildScrollView(
         padding: const EdgeInsets.only(
          top: 50.0,
          left: 16.0,
          right: 16.0,
         ),
          child: Column( 

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            //colocamos el nombre y marca del producto

            Center(
              child: Column(
                children: [
                  Text(articulo.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    articulo.marca ?? 'Marca no disponible',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // colocamos la imagen y los sellos de advertencia

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(flex: 5,
                child: SizedBox(
                  height: 180,
                  child: articulo.imagen !=null
                  ? Image.asset(
                    articulo.imagen!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,

                        ),
                      );
                    },
                  )

                  : const Center(
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),

                ),
                ),

                const SizedBox(width: 12,),

                //definimos la estructura de los sellos de advertencia
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sellos de advertencia',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                      ),
                      const SizedBox(height: 10),

                     

                     if (articulo.sellosAdvertencia == null)
                      const Text(
                        'Información de sellos no disponible.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else if (sellos.isEmpty)
                      const Text(
                        'No hay sellos registrados.',
                        style: TextStyle(color: Colors.grey),
                      )
                      else 
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sellos.map((identificador){
                          final ruta = imagenesSellos[identificador];

                          if(ruta== null){
                            return const SizedBox.shrink();
                          }
                          return SizedBox(
                            width: 75,
                            height: 75,
                            child: Image.asset(
                              ruta,
                              fit: BoxFit.contain,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            
            //creamos la estructura para el contenido neto y porciones por envase
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text('Contenido neto',
                          style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text('${articulo.contenidoNeto ?? '-'} ${articulo.unidadContenido??''}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),

                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              'Porciones por envase',style: TextStyle(color: Colors.grey),),
                              
                              const SizedBox(height: 5),

                              Text('${articulo.porcionesEnvase?? '-'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              ),        
                          ],
                        ),
                      ),
                    ), 
                    ),
              ],
            ),

            const SizedBox(height: 24),

            // Estructuramos la informacion nutricional

            const Text(
            'Información nutricional',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),

           const SizedBox(height: 12),

           tablaNutricional(
            'Valores por cada 100 g',
            nutrientes100g,
          ),

          const SizedBox(height: 16),

          tablaNutricional(
            'Valores por porción (${articulo.tamanoPorcion ?? '-'} ${articulo.unidadPorcion ?? ''})',
            nutrientesPorcion,
          ),

          const SizedBox(height: 24),

          //estructuramos los ingredientes

          const Text(
            'Ingredientes',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            articulo.ingredientes ?? 'Información no disponible.',
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              height: 1.5,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 20),

          //estructuramos los alergenos

          const Text(
            'Alérgenos',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            articulo.alergenos ?? 'Información no disponible.',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              height: 1.5,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 28),

          //boton para observar el veredicto

            SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Veredicto(
                      articulo: articulo,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Ver veredicto final',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
            ]
          ),
        ),
      );

}

}