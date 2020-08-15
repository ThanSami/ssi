class Provincia {
  int id;
  String nombre;

  Provincia(
      {this.id,
        this.nombre});

  Provincia.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    nombre = json['Nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['Nombre'] = this.nombre;
    return data;
  }
}