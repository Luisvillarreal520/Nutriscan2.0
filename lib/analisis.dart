import 'package:flutter_application_1/base_de_datos/articulos.dart';

// Representacion del resultado a obtener

class ResultadoAnalisis {
  final String resultado; // veredicto
  final String porque; //explicacion principal del resultado
  final List<String> advertencias;
  final bool evaluacionCompleta;

  //definimos las variables para el analisis de hipertension

  final double? sodioPorcentaje;
  final double? grasasSaturadasPorcentaje;
  final double? grasasTransPorcentaje;

  final double? sodioPor100g;
  final double? sodioPorPorcion;

  final double? grasasSaturadasPor100g;
  final double? grasasSaturadasPorPorcion;

  final double? grasasTransPor100g;
  final double? grasasTransPorPorcion;

  //definimos las variables para el analisis por diabetes

  final double? carbohidratosPor100g;
  final double? carbohidratosPorPorcion;

  final double? azucaresTotalesPor100g;
  final double? azucaresTotalesPorPorcion;

  ResultadoAnalisis({
    required this.resultado,
    required this.porque,
    this.advertencias = const [],
    this.evaluacionCompleta = true,

    this.sodioPorcentaje,
    this.grasasSaturadasPorcentaje,
    this.grasasTransPorcentaje,
    this.sodioPor100g,
    this.sodioPorPorcion,
    this.grasasSaturadasPor100g,
    this.grasasSaturadasPorPorcion,
    this.grasasTransPor100g,
    this.grasasTransPorPorcion,

    this.carbohidratosPor100g,
    this.carbohidratosPorPorcion,
    this.azucaresTotalesPor100g,
    this.azucaresTotalesPorPorcion,
    

  });
}

ResultadoAnalisis evaluarHipertension(Articulos articulo) {

  // 1. recopilar los datos nutricionales por 100 g y por porción

  final sodio100 = articulo.sodioPor100g;
  final sodioPorcion = articulo.sodioPorPorcion;
  final saturadas100 = articulo.grasaSaturadaPor100g;
  final saturadasPorcion = articulo.grasaSaturadaPorPorcion;
  final trans100 = articulo.grasaTransPor100g;
  final transPorcion = articulo.grasaTransPorPorcion;

  // 2. Calcular los porcentajes respecto a la referencia diaria

  final double? sodioPorcentaje =
      sodioPorcion == null ? null : (sodioPorcion / 2000) * 100;

  final double? saturadasPorcentaje =
      saturadasPorcion == null ? null : (saturadasPorcion / 22.2) * 100;

  final double? transPorcentaje =
      transPorcion == null ? null : (transPorcion / 2.2) * 100;


  // 3. Comprobar que tenemos toda la información necesaria para dar el veredicto

  final datosDisponibles = [
    sodio100,
    sodioPorcion,
    saturadas100,
    saturadasPorcion,
    trans100,
    transPorcion,
  ];

  final faltanDatos = datosDisponibles.any((dato) => dato == null);

  final datosInvalidos = datosDisponibles.any(
    (dato) => dato != null && dato < 0,
  );

  if (faltanDatos || datosInvalidos) {
    return ResultadoAnalisis(
      resultado: 'Evaluación incompleta',
      porque: datosInvalidos
          ? 'Se encontraron valores nutricionales inválidos. '
              'No es posible completar el análisis.'
          : 'Faltan datos nutricionales para evaluar correctamente '
              'el sodio y las grasas saturadas y trans.',
      evaluacionCompleta: false,

      sodioPorcentaje: sodioPorcentaje,
      grasasSaturadasPorcentaje: saturadasPorcentaje,
      grasasTransPorcentaje: transPorcentaje,

      sodioPor100g: sodio100,
      sodioPorPorcion: sodioPorcion,

      grasasSaturadasPor100g: saturadas100,
      grasasSaturadasPorPorcion: saturadasPorcion,

      grasasTransPor100g: trans100,
      grasasTransPorPorcion: transPorcion,
    );
  }


  // 4. Identificamos el nutriente con mayor porcentaje

  double mayorPorcentaje = sodioPorcentaje!;
  String nutrientePrincipal = 'sodio';

  if (saturadasPorcentaje! > mayorPorcentaje) {
    mayorPorcentaje = saturadasPorcentaje;
    nutrientePrincipal = 'grasas saturadas';
  }

  if (transPorcentaje! > mayorPorcentaje) {
    mayorPorcentaje = transPorcentaje;
    nutrientePrincipal = 'grasas trans';
  }


  // 5. Crear las advertencias individuales

  final List<String> advertencias = [];

  if (sodioPorcentaje > 30) {
    advertencias.add(
      'El sodio aporta ${sodioPorcentaje.toStringAsFixed(1)}% '
      'de la referencia diaria.'
    );
  }

  if (saturadasPorcentaje > 30) {
    advertencias.add(
      'Las grasas saturadas aportan '
      '${saturadasPorcentaje.toStringAsFixed(1)}% '
      'de la referencia diaria.'
    );
  }

  if (transPorcentaje > 30) {
    advertencias.add(
      'Las grasas trans aportan '
      '${transPorcentaje.toStringAsFixed(1)}% '
      'de la referencia diaria.'
    );
  }


  // 6. Determinar si algún nutriente supera el 100%

  if (mayorPorcentaje > 100) {

    return ResultadoAnalisis(
      resultado: 'No recomendado',
      porque: 'Una porción supera la referencia diaria de '
          '$nutrientePrincipal, aportando '
          '${mayorPorcentaje.toStringAsFixed(1)}% de dicha referencia.',
      advertencias: advertencias,

      sodioPorcentaje: sodioPorcentaje,
      grasasSaturadasPorcentaje: saturadasPorcentaje,
      grasasTransPorcentaje: transPorcentaje,

      sodioPor100g: sodio100,
      sodioPorPorcion: sodioPorcion,

      grasasSaturadasPor100g: saturadas100,
      grasasSaturadasPorPorcion: saturadasPorcion,

      grasasTransPor100g: trans100,
      grasasTransPorPorcion: transPorcion,
    );
  }


  // 7. Determinar si algún nutriente supera el 30%

  if (mayorPorcentaje > 30) {

    return ResultadoAnalisis(
      resultado: 'Consumir con moderación',
      porque: 'La porción aporta una proporción considerable '
          'de $nutrientePrincipal, representando '
          '${mayorPorcentaje.toStringAsFixed(1)}% de su referencia diaria.',
      advertencias: advertencias,

      sodioPorcentaje: sodioPorcentaje,
      grasasSaturadasPorcentaje: saturadasPorcentaje,
      grasasTransPorcentaje: transPorcentaje,

      sodioPor100g: sodio100,
      sodioPorPorcion: sodioPorcion,

      grasasSaturadasPor100g: saturadas100,
      grasasSaturadasPorPorcion: saturadasPorcion,

      grasasTransPor100g: trans100,
      grasasTransPorPorcion: transPorcion,
    );
  }


  // 8. Si ningún nutriente supera el 30%, el producto es recomendado

  return ResultadoAnalisis(
    resultado: 'Recomendado',
    porque: 'Ninguno de los nutrientes evaluados supera '
        'el 30% de su referencia diaria.',

    sodioPorcentaje: sodioPorcentaje,
    grasasSaturadasPorcentaje: saturadasPorcentaje,
    grasasTransPorcentaje: transPorcentaje,

    sodioPor100g: sodio100,
    sodioPorPorcion: sodioPorcion,

    grasasSaturadasPor100g: saturadas100,
    grasasSaturadasPorPorcion: saturadasPorcion,

    grasasTransPor100g: trans100,
    grasasTransPorPorcion: transPorcion,
  );
}





ResultadoAnalisis analizarDiabetes(Articulos articulo) {

  // Obtenemos los valores nutricionales del producto

  final carbohidratos100g = articulo.carbohidratosPor100g;
  final carbohidratosPorcion = articulo.carbohidratosPorPorcion;

  final azucares100g = articulo.azucaresTotalesPor100g;
  final azucaresPorcion = articulo.azucaresTotalesPorPorcion;


  // Verificamos que tengamos todos los datos necesarios

  if (carbohidratos100g == null ||
      carbohidratosPorcion == null ||
      azucares100g == null ||
      azucaresPorcion == null) {

    return ResultadoAnalisis(
      resultado: 'Evaluación incompleta',
      porque: 'No se dispone de toda la información nutricional necesaria para realizar el análisis.',
      evaluacionCompleta: false,

      carbohidratosPor100g: carbohidratos100g,
      carbohidratosPorPorcion: carbohidratosPorcion,
      azucaresTotalesPor100g: azucares100g,
      azucaresTotalesPorPorcion: azucaresPorcion,
    );
  }


  // Comprobamos que los valores no sean negativos

  if (carbohidratos100g < 0 ||
      carbohidratosPorcion < 0 ||
      azucares100g < 0 ||
      azucaresPorcion < 0) {

    return ResultadoAnalisis(
      resultado: 'Evaluación incompleta',
      porque: 'Se encontraron valores nutricionales inválidos.',
      evaluacionCompleta: false,

      carbohidratosPor100g: carbohidratos100g,
      carbohidratosPorPorcion: carbohidratosPorcion,
      azucaresTotalesPor100g: azucares100g,
      azucaresTotalesPorPorcion: azucaresPorcion,
    );
  }


  // Clasificamos los carbohidratos por porcion

  String nivelCarbohidratos;

  if (carbohidratosPorcion < 15) {
    nivelCarbohidratos = 'Bajo';
  } else if (carbohidratosPorcion <= 30) {
    nivelCarbohidratos = 'Moderado';
  } else {
    nivelCarbohidratos = 'Elevado';
  }


  // Clasificamos los azucares por porcion

  String nivelAzucares;

  if (azucaresPorcion < 5) {
    nivelAzucares = 'Bajo';
  } else if (azucaresPorcion <= 10) {
    nivelAzucares = 'Moderado';
  } else {
    nivelAzucares = 'Elevado';
  }


  // Generamos las advertencias correspondientes

  List<String> advertencias = [];

  if (nivelCarbohidratos == 'Moderado') {
    advertencias.add(
      'La porción contiene una cantidad moderada de carbohidratos totales.',
    );
  } else if (nivelCarbohidratos == 'Elevado') {
    advertencias.add(
      'La porción contiene una cantidad elevada de carbohidratos totales.',
    );
  }

  if (nivelAzucares == 'Moderado') {
    advertencias.add(
      'La porción contiene una cantidad moderada de azúcares totales.',
    );
  } else if (nivelAzucares == 'Elevado') {
    advertencias.add(
      'La porción contiene una cantidad elevada de azúcares totales.',
    );
  }


  // Determinamos el resultado general

  String resultado;
  String porque;

  if (nivelCarbohidratos == 'Elevado' ||
      nivelAzucares == 'Elevado') {

    resultado = 'Elevado';

    porque = 'El producto presenta una cantidad elevada de '
        '${nivelCarbohidratos == 'Elevado' ? 'carbohidratos totales' : 'azúcares totales'} '
        'por porción.';

  } else if (nivelCarbohidratos == 'Moderado' ||
             nivelAzucares == 'Moderado') {

    resultado = 'Moderado';

    porque = 'El producto presenta una cantidad moderada de '
        '${nivelCarbohidratos == 'Moderado' ? 'carbohidratos totales' : 'azúcares totales'} '
        'por porción.';

  } else {

    resultado = 'Bajo';

    porque = 'El producto presenta cantidades bajas de carbohidratos '
        'y azúcares totales por porción, según los criterios de NutriScan.';
  }


  // Devolvemos el resultado del analisis

  return ResultadoAnalisis(
    resultado: resultado,
    porque: porque,
    advertencias: advertencias,

    carbohidratosPor100g: carbohidratos100g,
    carbohidratosPorPorcion: carbohidratosPorcion,

    azucaresTotalesPor100g: azucares100g,
    azucaresTotalesPorPorcion: azucaresPorcion,
  );
}

// Analisis de productos para personas con celiaquia

ResultadoAnalisis analizarCeliaquia(Articulos articulo) {

  // 1. Obtenemos los ingredientes del producto

  final ingredientes = articulo.ingredientes;


  // 2. Comprobamos que tengamos la lista de ingredientes

  if (ingredientes == null || ingredientes.trim().isEmpty) {

    return ResultadoAnalisis(
      resultado: 'Evaluación incompleta',
      porque: 'No se dispone de la lista de ingredientes para comprobar '
          'la posible presencia de gluten.',
      evaluacionCompleta: false,
    );
  }


  // 3. Convertimos los ingredientes a minusculas

  final textoIngredientes = ingredientes.toLowerCase();


  // 4. Definimos las palabras que queremos identificar

  final List<String> ingredientesConGluten = [
    'trigo',
    'cebada',
    'centeno',
    'malta',
    'harina de trigo',
    'gluten',
  ];


  // 5. Buscamos coincidencias en la lista de ingredientes

  final List<String> encontrados = [];

  for (String ingrediente in ingredientesConGluten) {

    if (textoIngredientes.contains(ingrediente)) {

      encontrados.add(ingrediente);

    }
  }


  // 6. Determinamos el resultado del analisis

  if (encontrados.isNotEmpty) {

    return ResultadoAnalisis(
      resultado: 'No recomendado',

      porque: 'Se identificaron ingredientes asociados con la presencia '
          'de gluten: ${encontrados.join(', ')}.',

      advertencias: [
        'Según los criterios de NutriScan, este producto no es adecuado '
            'para personas con celiaquía.'
      ],
    );

  }


  // 7. Si no encontramos coincidencias

  return ResultadoAnalisis(
    resultado: 'Sin gluten detectado',

    porque: 'No se encontraron los ingredientes asociados con gluten '
        'que NutriScan busca en la lista proporcionada.',

    advertencias: [
      'La ausencia de coincidencias no garantiza que el producto esté '
          'libre de gluten. Se recomienda verificar su etiquetado y '
          'consultar con un profesional de salud.'
    ],
  );

}

// Analisis de productos para personas con alergias

ResultadoAnalisis analizarAlergias(
  Articulos articulo,
  List<String> alergiasActivas,
) {

  // 1. Obtenemos los ingredientes del producto

  final ingredientes = articulo.ingredientes;


  // 2. Comprobamos que tengamos la lista de ingredientes

  if (ingredientes == null || ingredientes.trim().isEmpty) {

    return ResultadoAnalisis(
      resultado: 'Evaluación incompleta',
      porque: 'No se dispone de la lista de ingredientes '
          'para realizar el análisis.',
      evaluacionCompleta: false,
    );
  }


  // 3. Comprobamos si el usuario seleccionó alguna alergia

  if (alergiasActivas.isEmpty) {

    return ResultadoAnalisis(
      resultado: 'Sin alergias seleccionadas',
      porque: 'El usuario no tiene ningún grupo de alergias '
          'activado en su perfil.',
    );
  }


  // 4. Convertimos los ingredientes a minusculas

  final textoIngredientes = ingredientes
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u');


  // 5. Definimos las palabras asociadas a cada grupo

  final Map<String, List<String>> palabrasAlergenos = {

    'mani': ['mani', 'cacahuete'],

    'leche': ['leche', 'suero de leche', 'caseina', 'lactosuero'],

    'huevo': ['huevo', 'clara de huevo', 'yema de huevo'],

    'pescado': ['pescado'],

    'mariscos': [
      'mariscos',
      'camaron',
      'langostino',
      'cangrejo',
      'langosta',
      'mejillon',
      'ostra',
      'pulpo',
      'calamar',
    ],

    'soya': ['soya', 'soja'],

    'frutos secos': [
      'frutos secos',
      'almendra',
      'nuez',
      'avellana',
      'pistacho',
      'anacardo',
      'nuez de macadamia',
      'pecana',
    ],

    'trigo': ['trigo', 'harina de trigo'],
  };


  // 6. Buscamos coincidencias entre las alergias activas
  // y los ingredientes del producto

  final List<String> encontrados = [];

  for (String alergia in alergiasActivas) {

    final alergiaNormalizada = alergia
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    final palabras = palabrasAlergenos[alergiaNormalizada];

    if (palabras == null) {
      continue;
    }

    for (String palabra in palabras) {

      if (textoIngredientes.contains(palabra)) {

        if (!encontrados.contains(alergiaNormalizada)) {
          encontrados.add(alergiaNormalizada);
        }

        break;
      }
    }
  }


  // 7. Determinamos el resultado del analisis

  if (encontrados.isNotEmpty) {

    return ResultadoAnalisis(
      resultado: 'No recomendado',

      porque: 'Se encontraron ingredientes asociados '
          'con las siguientes alergias: ${encontrados.join(', ')}.',

      
    );

  }


  // 8. Si no encontramos coincidencias

  return ResultadoAnalisis(
    resultado: 'Sin coincidencias detectadas',

    porque: 'No se encontraron ingredientes relacionados '
        'con las alergias seleccionadas por el usuario.',

  );

}



