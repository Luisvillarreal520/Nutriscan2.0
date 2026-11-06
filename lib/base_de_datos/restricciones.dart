class Restricciones {
int? id;
String tipoCondicion;
String valorNombre;
int seleccionar;

Restricciones({
  this.id,
  required this.tipoCondicion,
  required this.valorNombre,
  required this.seleccionar,
});

//creando el mapa de datos para las restricciones

Map<String, dynamic> toMap(){
  return{
    'id':id,
    'tipo':tipoCondicion,
    'valor':valorNombre,
    'activo':seleccionar,
  };
}

//obteniendo los datos del mapa para las restricciones

factory Restricciones.fromMap(Map<String, dynamic> mapa){
  return Restricciones(
    id: mapa['id'],
    tipoCondicion: mapa['tipo'],
    valorNombre: mapa['valor'],
    seleccionar: mapa['activo'],
    
  );
}


}