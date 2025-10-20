class BarangEntity {
  final int? id;
  final String nama;
  final int katagoriId;
  final int stok;
  final double harga;

  BarangEntity({
    this.id,
    required this.nama,
    required this.katagoriId,
    required this.stok,
    required this.harga,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'katagori_id': katagoriId,
      'stok': stok,
      'harga': harga,
    };
  }

  factory BarangEntity.fromJson(Map<String, dynamic> json) {
    return BarangEntity(
      id: json['id'],
      nama: json['nama'],
      katagoriId: json['katagori_id'],
      stok: json['stok'],
      harga: double.parse(json['harga'].toString()),
    );
  }
}