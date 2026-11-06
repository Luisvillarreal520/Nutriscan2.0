import 'package:flutter_application_1/base_de_datos/restricciones.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_application_1/base_de_datos/usuario.dart';
import 'package:flutter_application_1/base_de_datos/articulos.dart';
import 'package:flutter_application_1/base_de_datos/articulosinfo.dart';
class MainData {
  Future<Database> conectar() async {
    String ruta = join(await getDatabasesPath(), 'nutriscan.db');

    

    return await openDatabase(
      ruta,
      version:1,
      
      //permitimos que las tablas puedan relacionarse entre si con la claves foráneas
       onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (Database db, int version) async { 
        
        // creando la tabla usuario
        await db.execute( '''
    CREATE TABLE usuario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre_usuario TEXT NOT NULL,
      contrasena_hash TEXT NOT NULL)
      
      
      ''');

      //creando la tabla sobre restricciones del usuario
      await db.execute('''
      CREATE TABLE Restricciones (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tipo TEXT NOT NULL,
      valor TEXT NOT NULL,
      activo INTEGER NOT NULL DEFAULT 1)
''');

      //Creando la tabla sobre los productos y toda su informacion
     await db.execute('''
     CREATE TABLE productos (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     codigo_barras TEXT NOT NULL UNIQUE,
     nombre TEXT NOT NULL,
     marca TEXT,
     imagen TEXT,


     contenido_neto REAL,
     unidad_contenido TEXT,
     porciones_envase REAL,
     tamano_porcion REAL,
     unidad_porcion TEXT,

     calorias_por_porcion REAL,
     grasa_total_por_porcion REAL,
     grasa_saturada_por_porcion REAL,
     grasa_trans_por_porcion REAL,
     carbohidratos_por_porcion REAL,
     fibra_dietaria_por_porcion REAL,
     azucares_totales_por_porcion REAL,
     proteina_por_porcion REAL,
     sodio_por_porcion REAL,
     vitamina_a_por_porcion REAL,
     vitamina_d_por_porcion REAL,
     hierro_por_porcion REAL,
     calcio_por_porcion REAL,
     zinc_por_porcion REAL,

     calorias_por_100g REAL,
     grasa_total_por_100g REAL,
     grasa_saturada_por_100g REAL,
     grasa_trans_por_100g REAL,
     carbohidratos_por_100g REAL,
     fibra_dietaria_por_100g REAL,
     azucares_totales_por_100g REAL,
     proteina_por_100g REAL,
     sodio_por_100g REAL,
     vitamina_a_por_100g REAL,
     vitamina_d_por_100g REAL,
     hierro_por_100g REAL,
     calcio_por_100g REAL,
     zinc_por_100g REAL,

     ingredientes TEXT,
     alergenos TEXT,
     sellos_advertencia TEXT
     )
    ''');
    //Creando tabla para los registros al escanear
    await db.execute('''
      CREATE TABLE registros(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      producto_id INTEGER NOT NULL,
      fecha_escaneo TEXT NOT NULL,
      recomendacion TEXT NOT NULL,

      FOREIGN KEY (producto_id) REFERENCES productos(id)

      )
''');

      }
     
    );
  }

   //Preparando los datos del usuario
  final String nombreUsuarioinicial= 'Ronald Martelo';
  final String contrasenaInicial='A113';

//metodo para insertar usuario en la tabla
  Future<void> crearUsuarioInicial() async{
    final db= await conectar();

    final usuarios = await db.query('usuario');

    if (usuarios.isEmpty){
     
        Usuario usuario = Usuario(
          nombreUsuario: nombreUsuarioinicial,
          contrasenaHash: contrasenaInicial,
        );

        await db.insert('usuario', usuario.toMap());

        print('usuario creado exitosamente');
      
    }
  }

  //consultar usuario anteriormente creado en la tabla
  Future<Usuario?> consultarUsuario() async {
    final db = await conectar();

    final usuarios= await db.query('usuario');

    if (usuarios.isNotEmpty){
      return Usuario.fromMap(usuarios.first);
    }
    return null;
  }

  //validacion del usuario al iniciar sesion

  Future<bool> validarUsuario(
  String nombreUsuario,
  String contrasena
) async {
  Usuario? usuario = await consultarUsuario();

  if(usuario==null){
    return false;

  }

  if(usuario.nombreUsuario== nombreUsuario &&
     usuario.contrasenaHash== contrasena){
      return true;
     }

     return false;
}

//Preparando los datos para las restricciones del cliente

final List<String> condicionesDisponibles=[
  'Hipertensión',
  'Diabetes',
  'Celiaquía',
];

final List<String> alergenosComunes=[
'Maní',
'Leche',
'Huevo',
'Pescado',
'Mariscos',
'Soya',
'Frutos secos',
'Trigo',
];

//metodo para insertar restricciones en la tabla

Future<void> crearRestriccionIniciales() async{
  final db= await conectar();

  final existentes= await db.query('Restricciones');

  if(existentes.isNotEmpty){
    return;
  }

  for(String condicion in condicionesDisponibles){
    Restricciones restriccion= Restricciones(
      tipoCondicion: 'condicion',
      valorNombre: condicion,
      seleccionar: 0,
    );

    await db.insert('Restricciones', restriccion.toMap());
  }

  for(String alergeno in alergenosComunes){
    Restricciones restriccion = Restricciones(
      tipoCondicion: 'alergia',
      valorNombre: alergeno,
      seleccionar: 0,
    );
    await db.insert('Restricciones',restriccion.toMap());
  }

  print('Restricciones iniciales creadas exitosamente');

}

//Creamos el metodo para consultar las restricciones

Future<List<Restricciones>> consultarRestricciones() async{
  final db= await conectar();

  final registros= await db.query('Restricciones');

  return registros.map((mapa){
    return Restricciones.fromMap(mapa);
  }).toList();
}

//metodo para seleccionar o deseleccionar las restricciones

Future<void> actualizarRestriccion(Restricciones restriccion) async {
  if(restriccion.id==null){
    return;
  }
  
  final db = await conectar();

  await db.update(
    'Restricciones',{
      'activo': restriccion.seleccionar,
    },
    where: 'id = ?',
    whereArgs: [restriccion.id],
  );
}

//Metodo para insertar un articulo en la base de datos

Future<int> insertarArticulo(Articulos articulo) async{
  final db= await conectar();

  Map<String, dynamic> datos = articulo.toMap();

//eliminamos ID porque desde un inicio le pedimos a sqlite que lo genere y vaya en aumento

  datos.remove('id');

  return await db.insert(
    'productos',
    datos,
    conflictAlgorithm: ConflictAlgorithm.abort
  );
}

// Metodo para consultar el articulo de la base de datos mediante su codigo de barras

Future<Articulos?> consultarArtiPorBarra(String codigo) async{
  final db= await conectar();

  final resultado = await db.query(
    'productos',
    where: 'codigo_barras =?',
    whereArgs: [codigo],
    );
    if(resultado.isNotEmpty){
      return Articulos.fromMap(resultado.first);
    }
    return null;
}

//Metodo para ver los articulos almacenados

Future<List<Articulos>> verarticulos() async {
  final db =await conectar();

  final resultado = await db.query('productos');

  return resultado.map((mapa){
    return Articulos.fromMap(mapa);
  }).toList();
}

//Metodo para buscar los productos iniciales
Future<void> crearProductosIniciales() async {
  final db = await conectar();

  for (final articulo in productosIniciales) {
    final existentes = await db.query(
      'productos',
      columns: ['id'],
      where: 'codigo_barras = ?',
      whereArgs: [articulo.codigoBarras],
      limit: 1,
    );

    if (existentes.isEmpty) {
      await insertarArticulo(articulo);
    }
  }
}

// Guardamos un producto escaneado en la colección del usuario

Future<void> guardarRegistro(
  int productoId,
  String recomendacion,
) async {
  final db = await conectar();

  // Comprobamos si el producto ya está guardado
  final existente = await db.query(
    'registros',
    where: 'producto_id = ?',
    whereArgs: [productoId],
    limit: 1,
  );

  // Evitamos guardar el mismo producto dos veces
  if (existente.isNotEmpty) {
    return;
  }

  await db.insert('registros', {
    'producto_id': productoId,
    'fecha_escaneo': DateTime.now().toIso8601String(),
    'recomendacion': recomendacion,
  });
}

// Consultamos los productos guardados en la colección

Future<List<Map<String, dynamic>>> consultarProductosGuardados() async {
  final db = await conectar();

  final resultado = await db.rawQuery('''
    SELECT
      productos.*,
      registros.fecha_escaneo,
      registros.recomendacion
    FROM registros
    INNER JOIN productos
      ON registros.producto_id = productos.id
    ORDER BY registros.fecha_escaneo DESC
  ''');

  return resultado;
}

// Eliminamos un producto de la colección del usuario

Future<void> eliminarProductoGuardado(int productoId) async {
  final db = await conectar();

  await db.delete(
    'registros',
    where: 'producto_id = ?',
    whereArgs: [productoId],
  );
}

}





