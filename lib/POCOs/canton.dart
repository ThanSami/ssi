class Canton {
  int id;
  String nombre;

  Canton(
      {this.id,
        this.nombre});

  Canton.fromJson(Map<String, dynamic> json) {
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