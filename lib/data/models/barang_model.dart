import '../../domain/entities/barang_entity.dart';

class BarangModel extends BarangEntity {
  BarangModel({
    int? id,
    required String nama,
    required int UserId,
    required int katagoriId,
    required int stok,
    required double harga,
  }) : super(
         id: id,
         nama: nama,
         UserId: UserId,
         katagoriId: katagoriId,
         stok: stok,
         harga: harga,
       );

  factory BarangModel.fromEntity(BarangEntity entity) {
    return BarangModel(
      id: entity.id,
      nama: entity.nama,
      UserId: entity.UserId,
      katagoriId: entity.katagoriId,
      stok: entity.stok,
      harga: entity.harga,
    );
  }

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: json['id'],
      nama: json['nama'],
      UserId: json['user_id'],
      katagoriId: json['katagori_id'],
      stok: json['stok'],
      harga: double.parse(json['harga'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'user_id': UserId,
      'katagori_id': katagoriId,
      'stok': stok,
      'harga': harga,
    };
  }

  BarangModel copyWith({
    int? id,
    String? nama,
    int? UserId,
    int? katagoriId,
    int? stok,
    double? harga,
    int? userId,
  }) {
    return BarangModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      UserId: UserId ?? this.UserId,
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

  get kategoriId => null;
}
