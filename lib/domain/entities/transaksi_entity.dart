class TransaksiEntity {
  final int? id;
  final int barangId;
  final int UserId;
  final int jumlah;
  final double totalHarga;
  final String tipeTransaksi;
  final double hargaSatuan;
  final DateTime tanggal;

  TransaksiEntity({
    this.id,
    required this.barangId,
    required this.jumlah,
    required this.totalHarga,
    required this.tipeTransaksi,
    required this.hargaSatuan,
    required this.tanggal,
    required this.UserId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barang_id': barangId,
      'jumlah': jumlah,
      'total_harga': totalHarga,
      'tipe_transaksi': tipeTransaksi,
      'harga_satuan': hargaSatuan,
      'tanggal': tanggal.toIso8601String(),
      'user_id': UserId,
    };
  }

  factory TransaksiEntity.fromJson(Map<String, dynamic> json) {
    return TransaksiEntity(
      id: json['id'],
      barangId: json['barang_id'],
      UserId: json['user_id'],
      jumlah: json['jumlah'],
      totalHarga: double.parse(json['total_harga'].toString()),
      tipeTransaksi: json['tipe_transaksi'],
      hargaSatuan: double.parse(json['harga_satuan'].toString()),
      tanggal: DateTime.parse(json['tanggal']),
    );
  }
}
