class Usuario {
  int? id;
  String nombreUsuario;
  String contrasenaHash;

  Usuario({
    this.id,
    required this.nombreUsuario,
    required this.contrasenaHash
  });
  // creando el mapa de datos para el usuario
Map<String, dynamic> toMap(){
  return{
    'id':id,
    'nombre_usuario': nombreUsuario,
    'contrasena_hash':contrasenaHash
  };
}
//obtener los datos del mapa para el usuario
factory Usuario.fromMap(Map<String, dynamic> mapa){
  return Usuario(
    id: mapa['id'],
    nombreUsuario: mapa['nombre_usuario'],
    contrasenaHash: mapa['contrasena_hash'],
  );
}


}