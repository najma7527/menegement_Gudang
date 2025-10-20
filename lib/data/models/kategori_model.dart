import '../../domain/entities/katagori_entity.dart';

class KatagoriModel extends KatagoriEntity {
  KatagoriModel({
    int? id,
    required String nama,
    String? deskripsi,
    String? warna,
  }) : super(id: id, nama: nama, deskripsi: deskripsi, warna: warna);

  factory KatagoriModel.fromEntity(KatagoriEntity entity) {
    return KatagoriModel(
      id: entity.id,
      nama: entity.nama,
      deskripsi: entity.deskripsi,
      warna: entity.warna,
    );
  }

  factory KatagoriModel.fromJson(Map<String, dynamic> json) {
    return KatagoriModel(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      warna: json['warna'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi ?? "",
      'warna': warna ?? "",
    };
  }
}
