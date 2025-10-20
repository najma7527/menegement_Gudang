class KatagoriEntity {
  final int? id;
  final String nama;
  final String? deskripsi;
  final String? warna;

  KatagoriEntity({this.id, required this.nama, this.deskripsi, this.warna});

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'deskripsi': deskripsi, 'warna': warna};
  }

  factory KatagoriEntity.fromJson(Map<String, dynamic> json) {
    return KatagoriEntity(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      warna: json['warna'],
    );
  }
}
