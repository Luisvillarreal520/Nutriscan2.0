
import 'package:flutter_application_1/base_de_datos/articulos.dart';

final List<Articulos> productosIniciales = [

  // PRODUCTO 1: PASABOCAS PATTY

  Articulos(
    codigoBarras: '7709990349740',
    nombre: 'Pasabocas Patty',
    marca: 'Pasabocas Patty S.A.S',
    imagen: 'assets/patty.jpg',

    contenidoNeto: 50.0,
    unidadContenido: 'g',
    porcionesEnvase: 2.0,
    tamanoPorcion: 25.0,
    unidadPorcion: 'g',

    // Valores por cada 100 gramos

    caloriasPor100g: 490.0,
    grasaTotalPor100g: 25.0,
    grasaSaturadaPor100g: 10.0,
    grasaTransPor100g: 0.0,
    carbohidratosPor100g: 64.0,
    fibraDietariaPor100g: 10.0,
    azucaresTotalesPor100g: 3.4,
    proteinaPor100g: 2.1,
    sodioPor100g: 152.0,
    vitaminaAPor100g: 0.0,
    vitaminaDPor100g: 0.0,
    hierroPor100g: 1.0,
    calcioPor100g: 40.0,
    zincPor100g: 0.0,

    // Valores por porción

    caloriasPorPorcion: 123.0,
    grasaTotalPorPorcion: 6.3,
    grasaSaturadaPorPorcion: 2.5,
    grasaTransPorPorcion: 0.0,
    carbohidratosPorPorcion: 16.0,
    fibraDietariaPorPorcion: 2.5,
    azucaresTotalesPorPorcion: 0.9,
    proteinaPorPorcion: 0.5,
    sodioPorPorcion: 38.0,
    vitaminaAPorPorcion: 0.0,
    vitaminaDPorPorcion: 0.0,
    hierroPorPorcion: 0.25,
    calcioPorPorcion: 10.0,
    zincPorPorcion: 0.0,

    // Información adicional

    ingredientes: 'Plátano verde, aceite vegetal (oleína de palma), '
        'sabor artificial a limón [sal, maltodextrina, '
        'acidulantes (ácido cítrico, ácido ascórbico), azúcar, '
        'acentuadores de sabor (glutamato monosódico, '
        'guanilato disódico, inosinato disódico) y '
        'saborizante natural (limón)]',

    alergenos: 'No hay alergenos declarados en el empaque',
    sellosAdvertencia: '["exceso_de_grasas_saturadas"]',
  ),

  // PRODUCTO 2: GALLETAS DUX ORIGINAL

  Articulos(
    codigoBarras: '7702025101290',
    nombre: 'Galletas Dux Original',
    marca: 'Galletas Noel S.A.S',
    imagen: 'assets/Dux.jpg',

    contenidoNeto: 27.8,
    unidadContenido: 'g',
    porcionesEnvase: 1.0,
    tamanoPorcion: 27.8,
    unidadPorcion: 'g',

    // Valores por cada 100 gramos

    caloriasPor100g: 481.0,
    grasaTotalPor100g: 19.0,
    grasaSaturadaPor100g: 7.8,
    grasaTransPor100g: 0.0,
    carbohidratosPor100g: 71.0,
    fibraDietariaPor100g: 2.9,
    azucaresTotalesPor100g: 5.5,
    proteinaPor100g: 8.0,
    sodioPor100g: 720.0,
    vitaminaAPor100g: 0.0,
    vitaminaDPor100g: 0.0,
    hierroPor100g: 5.5,
    calcioPor100g: 174.0,
    zincPor100g: 0.0,

    // Valores por porción

    caloriasPorPorcion: 135.0,
    grasaTotalPorPorcion: 5.3,
    grasaSaturadaPorPorcion: 2.2,
    grasaTransPorPorcion: 0.0,
    carbohidratosPorPorcion: 20.0,
    fibraDietariaPorPorcion: 0.8,
    azucaresTotalesPorPorcion: 1.5,
    proteinaPorPorcion: 2.2,
    sodioPorPorcion: 200.0,
    vitaminaAPorPorcion: 0.0,
    vitaminaDPorPorcion: 0.0,
    hierroPorPorcion: 1.5,
    calcioPorPorcion: 48.0,
    zincPorPorcion: 0.0,

    // Información adicional

    ingredientes: 'Harina fortificada (Harina de trigo, Niacina, '
        'Hierro, Tiamina, Riboflavina, Ácido Fólico), '
        'Grasa vegetal de Palma, Aceite Vegetal de palma, '
        'Almidón de Yuca, Azúcar Invertido, Leudantes '
        '(Bicarbonato de Sodio, Fosfato MonoCalcico, '
        'Bicarbonato de Amonio), Agua, Sal, Azúcar, '
        'emulsificante (Lecitina de Soja), Saborizante artificial, '
        'Leche en Polvo.',

    alergenos: 'Contiene: trigo (gluten), soja y leche. '
        'Puede contener trazas de huevo, cebada, sésamo, '
        'avena, nueces de árbol y centeno.',

    sellosAdvertencia: '["exceso_de_sodio", "exceso_de_grasas_saturadas"]',
  ),

  // PRODUCTO 3: SALSA DE PIÑA

  Articulos(
    codigoBarras: '7700304649631',
    nombre: 'Salsa de piña',
    marca: 'ZEV',
    imagen: 'assets/piña.png',

    contenidoNeto: 200.0,
    unidadContenido: 'g',
    porcionesEnvase: 7.0,
    tamanoPorcion: 30.0,
    unidadPorcion: 'g',

    // Valores por cada 100 gramos

    caloriasPor100g: 247.0,
    grasaTotalPor100g: 0.3,
    grasaSaturadaPor100g: 0.2,
    grasaTransPor100g: 0.0,
    carbohidratosPor100g: 61.0,
    fibraDietariaPor100g: 0.0,
    azucaresTotalesPor100g: 61.0,
    proteinaPor100g: 0.0,
    sodioPor100g: 24.0,
    vitaminaAPor100g: 0.0,
    vitaminaDPor100g: 0.0,
    hierroPor100g: 0.0,
    calcioPor100g: 23.0,
    zincPor100g: 0.0,

    // Valores por porción

    caloriasPorPorcion: 73.0,
    grasaTotalPorPorcion: 0.1,
    grasaSaturadaPorPorcion: 0.1,
    grasaTransPorPorcion: 0.0,
    carbohidratosPorPorcion: 18.0,
    fibraDietariaPorPorcion: 0.0,
    azucaresTotalesPorPorcion: 18.0,
    proteinaPorPorcion: 0.0,
    sodioPorPorcion: 7.1,
    vitaminaAPorPorcion: 0.0,
    vitaminaDPorPorcion: 0.0,
    hierroPorPorcion: 0.0,
    calcioPorPorcion: 6.9,
    zincPorPorcion: 0.0,

    // Información adicional

    ingredientes: 'Pulpa de piña, azúcar, agua, acidulante '
        '(ácido cítrico), conservantes (sorbato de potasio, '
        'benzoato de sodio), aroma artificial (piña).',

    alergenos: 'No contiene alérgenos declarados.',
    sellosAdvertencia: '["exceso_de_azucares"]',
  ),

];
