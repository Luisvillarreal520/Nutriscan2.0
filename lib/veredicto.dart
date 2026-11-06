import 'package:flutter/material.dart';

import 'package:flutter_application_1/base_de_datos/articulos.dart';
import 'package:flutter_application_1/base_de_datos/maindata.dart';
import 'package:flutter_application_1/base_de_datos/restricciones.dart';
import 'package:flutter_application_1/analisis.dart';


class Veredicto extends StatefulWidget {

  final Articulos articulo;

  const Veredicto({
    super.key,
    required this.articulo,
  });

  @override
  State<Veredicto> createState() => VeredictoState();
}

//conectamos el archivo con la base de datos
class VeredictoState extends State<Veredicto> {

  final MainData bd = MainData();

  late Future<ResultadoEvaluacion> _futuroEvaluacion;


  @override
  void initState() {
    super.initState();

    _futuroEvaluacion = realizarEvaluacion();
  }


//Nos aseguramos que podamos leer cualquier tipo texto sin importar mayusculas o tildes

  String normalizar(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .trim();
  }


  //Buscamos y ejecutamos las restricciones que tenga el cliente activas

  Future<ResultadoEvaluacion> realizarEvaluacion() async {

    final restricciones = await bd.consultarRestricciones();

    final activas = restricciones
        .where((r) => r.seleccionar == 1)
        .toList();


    final List<ResultadoIndividual> resultados = [];


    // Identificamos las condiciones de salud activas.

    final condicionesActivas = activas
        .where((r) => r.tipoCondicion == 'condicion')
        .toList();


    for (Restricciones restriccion in condicionesActivas) {

      final condicion = normalizar(restriccion.valorNombre);


      if (condicion == 'hipertension') {

        final resultado = evaluarHipertension(widget.articulo);

        resultados.add(
          ResultadoIndividual(
            nombre: 'Hipertensión',
            analisis: resultado,
          ),
        );

      } else if (condicion == 'diabetes') {

        final resultado = analizarDiabetes(widget.articulo);

        resultados.add(
          ResultadoIndividual(
            nombre: 'Diabetes',
            analisis: resultado,
          ),
        );

      } else if (condicion == 'celiaquia') {

        final resultado = analizarCeliaquia(widget.articulo);

        resultados.add(
          ResultadoIndividual(
            nombre: 'Celiaquía',
            analisis: resultado,
          ),
        );

      }
    }


    // Recuperamos únicamente las alergias activas.

    final List<String> alergiasActivas = activas
        .where((r) => r.tipoCondicion == 'alergia')
        .map((r) => r.valorNombre)
        .toList();


    // Ejecutamos el análisis de alergias en caso de que el usuario tenga alguna alergia activa
   

    if (alergiasActivas.isNotEmpty) {

      final resultado = analizarAlergias(
        widget.articulo,
        alergiasActivas,
      );

      resultados.add(
        ResultadoIndividual(
          nombre: 'Alergias',
          analisis: resultado,
        ),
      );
    }


    // Determinamos el veredicto general.

    final veredictoGeneral = determinarVeredicto(resultados);

      if(widget.articulo.id != null){
        await bd.guardarRegistro(
          widget.articulo.id!,
          veredictoGeneral,
        );
      }
    
    
    return ResultadoEvaluacion(
      resultados: resultados,
      veredictoGeneral: veredictoGeneral,
    );
  }


  // Establecemos la prioridad de los resultados.

  String determinarVeredicto(
    List<ResultadoIndividual> resultados,
  ) {

    if (resultados.isEmpty) {
      return 'Sin restricciones activas';
    }


    // Primero comprobamos si existe algún resultado
    // que indique que el producto no es recomendado.

    if (resultados.any(
      (r) => r.analisis.resultado == 'No recomendado',
    )) {
      return 'No recomendado';
    }


    // Comprobamos si alguna evaluación está incompleta.

    if (resultados.any(
      (r) => !r.analisis.evaluacionCompleta,
    )) {
      return 'Evaluación incompleta';
    }


    // Comprobamos el resultado elevado de diabetes.

    if (resultados.any(
      (r) => r.analisis.resultado == 'Elevado',
    )) {
      return 'Elevado';
    }


    // Comprobamos si alguna evaluación requiere moderación.

    if (resultados.any(
      (r) =>
          r.analisis.resultado == 'Moderado' ||
          r.analisis.resultado == 'Consumir con moderación',
    )) {
      return 'Consumir con moderación';
    }


    return 'Recomendado según los criterios de NutriScan';
  }


  // Actualizamos la evaluación en caso de que el usuario modifique sus restricciones
  

  void actualizarEvaluacion() {
    setState(() {
      _futuroEvaluacion = realizarEvaluacion();
    });
  }


  // Formateamos los valores numéricos.

  String formato(double? valor) {
    if (valor == null) {
      return 'No disponible';
    }

    return valor.toStringAsFixed(1);
  }


  // Obtenemos un color según el resultado.

  Color colorResultado(String resultado) {

    if (resultado == 'No recomendado' ||
        resultado == 'Elevado') {
      return Colors.red;
    }

    if (resultado == 'Consumir con moderación' ||
        resultado == 'Moderado') {
      return Colors.orange;
    }

    if (resultado == 'Evaluación incompleta') {
      return Colors.blueGrey;
    }

    return Colors.green;
  }


  // Construimos un indicador visual para los porcentajes.

  Widget indicadorPorcentaje(
    String nombre,
    double? porcentaje,
    double? cantidad,
    String unidad,
  ) {

    final color = porcentaje == null
        ? Colors.blueGrey
        : porcentaje > 100
            ? Colors.red
            : porcentaje > 30
                ? Colors.orange
                : Colors.green;


    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Expanded(
                child: Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              Text(
                porcentaje == null
                    ? 'No disponible'
                    : '${formato(porcentaje)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: porcentaje == null
                ? 0
                : (porcentaje / 100).clamp(0.0, 1.0).toDouble(),

            minHeight: 10,

            backgroundColor: Colors.grey.shade300,

            color: color,

            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 5),

          Text(
            cantidad == null
                ? 'Cantidad por porción: No disponible'
                : 'Cantidad por porción: ${formato(cantidad)} $unidad',

            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          if (porcentaje != null && porcentaje > 100)
            const Text(
              'Supera el 100% de la referencia diaria.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }


  // Mostramos los resultados de hipertensión.

  Widget mostrarHipertension(ResultadoAnalisis analisis) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        indicadorPorcentaje(
          'Sodio',
          analisis.sodioPorcentaje,
          analisis.sodioPorPorcion,
          'mg',
        ),

        indicadorPorcentaje(
          'Grasas saturadas',
          analisis.grasasSaturadasPorcentaje,
          analisis.grasasSaturadasPorPorcion,
          'g',
        ),

        indicadorPorcentaje(
          'Grasas trans',
          analisis.grasasTransPorcentaje,
          analisis.grasasTransPorPorcion,
          'g',
        ),

      ],
    );
  }


  // Mostramos los resultados de diabetes.

  Widget mostrarDiabetes(ResultadoAnalisis analisis) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Text(
          'Carbohidratos totales',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          'Por porción: ${formato(analisis.carbohidratosPorPorcion)} g',
        ),

        Text(
          'Por 100 g: ${formato(analisis.carbohidratosPor100g)} g',
        ),

        const SizedBox(height: 15),

        const Text(
          'Azúcares totales',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 5),

        Text(
          'Por porción: ${formato(analisis.azucaresTotalesPorPorcion)} g',
        ),

        Text(
          'Por 100 g: ${formato(analisis.azucaresTotalesPor100g)} g',
        ),

      ],
    );
  }


  // Mostramos cada evaluación individual.

  Widget mostrarResultadoIndividual(
    ResultadoIndividual resultado,
  ) {

    final analisis = resultado.analisis;

    final color = colorResultado(analisis.resultado);


    return Card(
      margin: const EdgeInsets.only(bottom: 18),

      elevation: 2,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              resultado.nombre,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),

              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                analisis.resultado,

                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 18),


            // Información específica de hipertensión.

            if (resultado.nombre == 'Hipertensión')
              mostrarHipertension(analisis),


            // Información específica de diabetes.

            if (resultado.nombre == 'Diabetes')
              mostrarDiabetes(analisis),


            // Explicación del resultado.

            const SizedBox(height: 12),

            const Divider(),

            const Text(
              '¿Por qué se obtuvo este resultado?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              analisis.porque,
              style: const TextStyle(fontSize: 14),
            ),


            // Advertencias adicionales, cuando existan.

            if (analisis.advertencias.isNotEmpty) ...[

              const SizedBox(height: 12),

              for (String advertencia in analisis.advertencias)

                Padding(
                  padding: const EdgeInsets.only(bottom: 7),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          advertencia,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

          ],
        ),
      ),
    );
  }


  // Construimos ¡PORFIN! la pantalla.

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Veredicto del producto'),

        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),

          onPressed: () {
            Navigator.maybePop(context);
          },
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar evaluación',
            onPressed: actualizarEvaluacion,
          ),

        ],
      ),


      body: FutureBuilder<ResultadoEvaluacion>(

        future: _futuroEvaluacion,

        builder: (context, snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }

              //Por si acaso
          if (snapshot.hasError) {

            debugPrint('ERROR EN LA EVALUACIÓN: ${snapshot.error}');
            debugPrint('DETALLES: ${snapshot.stackTrace}');

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'No fue posible realizar la evaluación.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: actualizarEvaluacion,
                      child: const Text('Intentar nuevamente'),
                    ),
                  ],
                ),
              ),
            );

          }


          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se encontraron resultados.'),
            );
          }


          final evaluacion = snapshot.data!;

          final veredicto = evaluacion.veredictoGeneral;

          final color = colorResultado(veredicto);


          return SingleChildScrollView(

            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // VEREDICTO GENERAL

                Card(
                  elevation: 3,

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      children: [

                        const Icon(
                          Icons.health_and_safety,
                          size: 45,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Resultado general',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          veredicto,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (evaluacion.resultados.isEmpty)

                          const Text(
                            'No tienes restricciones alimentarias activas. '
                            'No se ha realizado una evaluación personalizada.',
                            textAlign: TextAlign.center,
                          )

                        else

                          const Text(
                            'Este resultado se determina a partir de '
                            'las restricciones activas de tu perfil.',
                            textAlign: TextAlign.center,
                          ),

                      ],
                    ),
                  ),
                ),


                const SizedBox(height: 25),


                if (evaluacion.resultados.isNotEmpty) ...[

                  const Text(
                    'Evaluaciones individuales',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),


                  for (ResultadoIndividual resultado
                      in evaluacion.resultados)

                    mostrarResultadoIndividual(resultado),

                ],


                const SizedBox(height: 20),

                const Text(
                  'Los resultados de NutriScan son orientativos y se basan '
                  'en la información disponible del producto y los criterios '
                  'de evaluación de la aplicación. No sustituyen la '
                  'orientación de un profesional de salud.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

              ],
            ),
          );
        },
      ),
    );
  }
}


// Representa una evaluación individual.

class ResultadoIndividual {

  final String nombre;
  final ResultadoAnalisis analisis;

  ResultadoIndividual({
    required this.nombre,
    required this.analisis,
  });
}


// Agrupa todos los resultados obtenidos.

class ResultadoEvaluacion {

  final List<ResultadoIndividual> resultados;
  final String veredictoGeneral;

  ResultadoEvaluacion({
    required this.resultados,
    required this.veredictoGeneral,
  });
}