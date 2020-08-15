class Empresa {
  int id;
  String codigo;
  String nombre;
  String tipoIdentificacion;
  String identificacion;
  String telefono;

  Empresa(
      {this.id,
        this.codigo,
        this.nombre,
        this.tipoIdentificacion,
        this.identificacion,
        this.telefono});

  Empresa.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    codigo = json['Codigo'];
    nombre = json['Nombre'];
    tipoIdentificacion = json['TipoIdentificacion'];
    identificacion = json['Identificacion'];
    telefono = json['Telefono'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['Codigo'] = this.codigo;
    data['Nombre'] = this.nombre;
    data['TipoIdentificacion'] = this.tipoIdentificacion;
    data['Identificacion'] = this.identificacion;
    data['Telefono'] = this.telefono;
    return data;
  }
}