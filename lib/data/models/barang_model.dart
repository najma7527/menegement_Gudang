import '../../domain/entities/barang_entity.dart';

class BarangModel extends BarangEntity {
  BarangModel({
    int? id,
    required String nama,
    required int katagoriId,
    required int stok,
    required double harga,
  }) : super(
         id: id,
         nama: nama,
         katagoriId: katagoriId,
         stok: stok,
         harga: harga,
       );

  factory BarangModel.fromEntity(BarangEntity entity) {
    return BarangModel(
      id: entity.id,
      nama: entity.nama,
      katagoriId: entity.katagoriId,
      stok: entity.stok,
      harga: entity.harga,
    );
  }

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: json['id'],
      nama: json['nama'],
      katagoriId: json['katagori_id'],
      stok: json['stok'],
      harga: double.parse(json['harga'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'katagori_id': katagoriId,
      'stok': stok,
      'harga': harga,
    };
  }

  BarangModel copyWith({
    int? id,
    String? nama,
    int? katagoriId,
    int? stok,
    double? harga,
  }) {
    return BarangModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      katagoriId: katagoriId ?? this.katagoriId,
      stok: stok ?? this.stok,
      harga: harga ?? this.harga,
    );
  }

  // ✅ Equality hanya berdasarkan ID
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BarangModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
