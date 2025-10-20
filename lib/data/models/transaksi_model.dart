import '../../domain/entities/transaksi_entity.dart';

class TransaksiModel extends TransaksiEntity {
  TransaksiModel({
    int? id,
    required int barangId,
    required int jumlah,
    required double totalHarga,
    required String tipeTransaksi,
    required double hargaSatuan,
    required DateTime tanggal,
  }) : super(
         id: id,
         barangId: barangId,
         jumlah: jumlah,
         totalHarga: totalHarga,
         tipeTransaksi: tipeTransaksi,
         hargaSatuan: hargaSatuan,
         tanggal: tanggal,
       );

  factory TransaksiModel.fromEntity(TransaksiEntity entity) {
    return TransaksiModel(
      id: entity.id,
      barangId: entity.barangId,
      jumlah: entity.jumlah,
      totalHarga: entity.totalHarga,
      tipeTransaksi: entity.tipeTransaksi,
      hargaSatuan: entity.hargaSatuan,
      tanggal: entity.tanggal,
    );
  }

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id'],
      barangId: json['barang_id'],
      jumlah: json['jumlah'],
      totalHarga: double.parse(json['total_harga'].toString()),
      tipeTransaksi: json['tipe_transaksi'],
      hargaSatuan: double.parse(json['harga_satuan'].toString()),
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  // ADDED: toJson method untuk repository
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barang_id': barangId,
      'jumlah': jumlah,
      'total_harga': totalHarga,
      'tipe_transaksi': tipeTransaksi,
      'harga_satuan': hargaSatuan,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  // TAMBAHKAN: Implementasi equality untuk konsistensi
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransaksiModel &&
        other.id == id &&
        other.barangId == barangId &&
        other.jumlah == jumlah &&
        other.totalHarga == totalHarga &&
        other.tipeTransaksi == tipeTransaksi &&
        other.hargaSatuan == hargaSatuan &&
        other.tanggal == tanggal;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        barangId.hashCode ^
        jumlah.hashCode ^
        totalHarga.hashCode ^
        tipeTransaksi.hashCode ^
        hargaSatuan.hashCode ^
        tanggal.hashCode;
  }
}
