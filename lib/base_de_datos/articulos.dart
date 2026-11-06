class Articulos {

  //informacion primordial
  int? id;
  String codigoBarras;
  String nombre;
  String? marca;
  String? imagen;

  //informacion del contenido

  double? contenidoNeto;
  String? unidadContenido;
  double? porcionesEnvase;
  double? tamanoPorcion;
  String? unidadPorcion; 

  //Información nutricional por porción

  double? caloriasPorPorcion;
  double? grasaTotalPorPorcion;
  double? grasaSaturadaPorPorcion;
  double? grasaTransPorPorcion;
  double? carbohidratosPorPorcion;
  double? fibraDietariaPorPorcion;
  double? azucaresTotalesPorPorcion;
  double? proteinaPorPorcion;
  double? sodioPorPorcion;
  double? vitaminaAPorPorcion;
  double? vitaminaDPorPorcion;
  double? hierroPorPorcion;
  double? calcioPorPorcion;
  double? zincPorPorcion;

  //Informacion nutricional por gramos

  double? caloriasPor100g;
  double? grasaTotalPor100g;
  double? grasaSaturadaPor100g;
  double? grasaTransPor100g;
  double? carbohidratosPor100g;
  double? fibraDietariaPor100g;
  double? azucaresTotalesPor100g;
  double? proteinaPor100g;
  double? sodioPor100g;
  double? vitaminaAPor100g;
  double? vitaminaDPor100g;
  double? hierroPor100g;
  double? calcioPor100g;
  double? zincPor100g;

//Informacion adicional

String? ingredientes;
String? alergenos;
String? sellosAdvertencia;

Articulos({
  
  //informacion primordial
  this.id,
  required this.codigoBarras,
  required this.nombre,
  this.marca,
  this.imagen,

  //informacion del contenido
  this.contenidoNeto,
  this.unidadContenido,
  this.porcionesEnvase,
  this.tamanoPorcion,
  this.unidadPorcion,

  //Informacion nutricional por porcion

  this.caloriasPorPorcion,
  this.grasaTotalPorPorcion,
  this.grasaSaturadaPorPorcion,
  this.grasaTransPorPorcion,
  this.carbohidratosPorPorcion,
  this.fibraDietariaPorPorcion,
  this.azucaresTotalesPorPorcion,
  this.proteinaPorPorcion,
  this.sodioPorPorcion,
  this.vitaminaAPorPorcion,
  this.vitaminaDPorPorcion,
  this.hierroPorPorcion,
  this.calcioPorPorcion,
  this.zincPorPorcion,

  //Informacion nutricional por gramos

  this.caloriasPor100g,
  this.grasaTotalPor100g,
  this.grasaSaturadaPor100g,
  this.grasaTransPor100g,
  this.carbohidratosPor100g,
  this.fibraDietariaPor100g,
  this.azucaresTotalesPor100g,
  this.proteinaPor100g,
  this.sodioPor100g,
  this.vitaminaAPor100g,
  this.vitaminaDPor100g,
  this.hierroPor100g,
  this.calcioPor100g,
  this.zincPor100g,

  //informacion adicional

  this.ingredientes,
  this.alergenos,
  this.sellosAdvertencia,
});

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'codigo_barras': codigoBarras,
    'nombre': nombre,
    'marca': marca,
    'imagen': imagen,

    // Información del contenido
    'contenido_neto': contenidoNeto,
    'unidad_contenido': unidadContenido,
    'porciones_envase': porcionesEnvase,
    'tamano_porcion': tamanoPorcion,
    'unidad_porcion': unidadPorcion,

    // Información nutricional por porción
    'calorias_por_porcion': caloriasPorPorcion,
    'grasa_total_por_porcion': grasaTotalPorPorcion,
    'grasa_saturada_por_porcion': grasaSaturadaPorPorcion,
    'grasa_trans_por_porcion': grasaTransPorPorcion,
    'carbohidratos_por_porcion': carbohidratosPorPorcion,
    'fibra_dietaria_por_porcion': fibraDietariaPorPorcion,
    'azucares_totales_por_porcion': azucaresTotalesPorPorcion,
    'proteina_por_porcion': proteinaPorPorcion,
    'sodio_por_porcion': sodioPorPorcion,
    'vitamina_a_por_porcion': vitaminaAPorPorcion,
    'vitamina_d_por_porcion': vitaminaDPorPorcion,
    'hierro_por_porcion': hierroPorPorcion,
    'calcio_por_porcion': calcioPorPorcion,
    'zinc_por_porcion': zincPorPorcion,

    // Información nutricional por 100 gramos
    'calorias_por_100g': caloriasPor100g,
    'grasa_total_por_100g': grasaTotalPor100g,
    'grasa_saturada_por_100g': grasaSaturadaPor100g,
    'grasa_trans_por_100g': grasaTransPor100g,
    'carbohidratos_por_100g': carbohidratosPor100g,
    'fibra_dietaria_por_100g': fibraDietariaPor100g,
    'azucares_totales_por_100g': azucaresTotalesPor100g,
    'proteina_por_100g': proteinaPor100g,
    'sodio_por_100g': sodioPor100g,
    'vitamina_a_por_100g': vitaminaAPor100g,
    'vitamina_d_por_100g': vitaminaDPor100g,
    'hierro_por_100g': hierroPor100g,
    'calcio_por_100g': calcioPor100g,
    'zinc_por_100g': zincPor100g,

    // Información adicional
    'ingredientes': ingredientes,
    'alergenos': alergenos,
    'sellos_advertencia': sellosAdvertencia,
  };
}

factory Articulos.fromMap(Map<String, dynamic> mapa) {
  return Articulos(
    id: mapa['id'],
    codigoBarras: mapa['codigo_barras'],
    nombre: mapa['nombre'],
    marca: mapa['marca'],
    imagen: mapa['imagen'],

    // Información del contenido
    contenidoNeto: mapa['contenido_neto'],
    unidadContenido: mapa['unidad_contenido'],
    porcionesEnvase: mapa['porciones_envase'],
    tamanoPorcion: mapa['tamano_porcion'],
    unidadPorcion: mapa['unidad_porcion'],

    // Información nutricional por porción
    caloriasPorPorcion: mapa['calorias_por_porcion'],
    grasaTotalPorPorcion: mapa['grasa_total_por_porcion'],
    grasaSaturadaPorPorcion: mapa['grasa_saturada_por_porcion'],
    grasaTransPorPorcion: mapa['grasa_trans_por_porcion'],
    carbohidratosPorPorcion: mapa['carbohidratos_por_porcion'],
    fibraDietariaPorPorcion: mapa['fibra_dietaria_por_porcion'],
    azucaresTotalesPorPorcion: mapa['azucares_totales_por_porcion'],
    proteinaPorPorcion: mapa['proteina_por_porcion'],
    sodioPorPorcion: mapa['sodio_por_porcion'],
    vitaminaAPorPorcion: mapa['vitamina_a_por_porcion'],
    vitaminaDPorPorcion: mapa['vitamina_d_por_porcion'],
    hierroPorPorcion: mapa['hierro_por_porcion'],
    calcioPorPorcion: mapa['calcio_por_porcion'],
    zincPorPorcion: mapa['zinc_por_porcion'],

    // Información nutricional por 100 gramos
    caloriasPor100g: mapa['calorias_por_100g'],
    grasaTotalPor100g: mapa['grasa_total_por_100g'],
    grasaSaturadaPor100g: mapa['grasa_saturada_por_100g'],
    grasaTransPor100g: mapa['grasa_trans_por_100g'],
    carbohidratosPor100g: mapa['carbohidratos_por_100g'],
    fibraDietariaPor100g: mapa['fibra_dietaria_por_100g'],
    azucaresTotalesPor100g: mapa['azucares_totales_por_100g'],
    proteinaPor100g: mapa['proteina_por_100g'],
    sodioPor100g: mapa['sodio_por_100g'],
    vitaminaAPor100g: mapa['vitamina_a_por_100g'],
    vitaminaDPor100g: mapa['vitamina_d_por_100g'],
    hierroPor100g: mapa['hierro_por_100g'],
    calcioPor100g: mapa['calcio_por_100g'],
    zincPor100g: mapa['zinc_por_100g'],

    // Información adicional
    ingredientes: mapa['ingredientes'],
    alergenos: mapa['alergenos'],
    sellosAdvertencia: mapa['sellos_advertencia'],
  );
}


}

final Map<String, String> imagenesSellos = {
  'exceso_de_sodio': 'assets/Sodio.png',
  'exceso_de_azucares': 'assets/Azucares.jpeg',
  'exceso_de_grasas_saturadas': 'assets/Saturadas.png',
  'exceso_de_grasas_trans': 'assets/trans.png',
  'contiene_edulcorantes':'assets/Edulcorantes.png'
};