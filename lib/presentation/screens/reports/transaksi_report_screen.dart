import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../providers/transaksi_provider.dart';
import '../../providers/barang_provider.dart';
import '../../../data/models/transaksi_model.dart';
import '../../screens/responsive_layout.dart';
import '../../../core/constants/app_colors.dart';

class TransaksiReportScreen extends StatefulWidget {
  @override
  _TransaksiReportScreenState createState() => _TransaksiReportScreenState();
}

class _TransaksiReportScreenState extends State<TransaksiReportScreen> {
  String _period = 'Harian'; // Harian, Mingguan, Bulanan, Custom
  DateTime _selectedDate = DateTime.now();
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transaksiProvider = Provider.of<TransaksiProvider>(
        context,
        listen: false,
      );
      final barangProvider = Provider.of<BarangProvider>(
        context,
        listen: false,
      );
      // Ensure data loaded
      transaksiProvider.loadTransaksi();
      barangProvider.loadBarangByUser();
    });
  }

  DateTimeRange _computeRange() {
    if (_period == 'Harian') {
      final start = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      final end = start
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));
      return DateTimeRange(start: start, end: end);
    } else if (_period == 'Mingguan') {
      // Week starting Monday
      final weekday = _selectedDate.weekday;
      final monday = _selectedDate.subtract(Duration(days: weekday - 1));
      final sunday = monday
          .add(const Duration(days: 6))
          .add(const Duration(hours: 23, minutes: 59, seconds: 59));
      return DateTimeRange(
        start: DateTime(monday.year, monday.month, monday.day),
        end: sunday,
      );
    } else if (_period == 'Bulanan') {
      final start = DateTime(_selectedDate.year, _selectedDate.month, 1);
      final end = DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      return DateTimeRange(start: start, end: end);
    } else {
      // Custom
      final start = _fromDate ?? DateTime.now();
      final end = _toDate ?? DateTime.now();
      return DateTimeRange(start: start, end: end);
    }
  }

  List<TransaksiModel> _filterTransactions(List<TransaksiModel> list) {
    final range = _computeRange();
    return list
        .where(
          (t) =>
              t.tanggal.isAfter(
                range.start.subtract(const Duration(seconds: 1)),
              ) &&
              t.tanggal.isBefore(range.end.add(const Duration(seconds: 1))),
        )
        .toList();
  }

  Future<void> _generateAndPrintPdf() async {
    setState(() => _loading = true);
    try {
      final transaksiProvider = Provider.of<TransaksiProvider>(
        context,
        listen: false,
      );
      final barangProvider = Provider.of<BarangProvider>(
        context,
        listen: false,
      );
      List<TransaksiModel> data = _filterTransactions(
        transaksiProvider.transaksiList,
      );

      final pdf = pw.Document();
      final NumberFormat currency = NumberFormat.simpleCurrency(
        locale: 'id_ID',
        decimalDigits: 0,
      );
      final range = _computeRange();

      final tableHeaders = [
        'No',
        'Tanggal',
        'Barang',
        'Tipe',
        'Jumlah',
        'Harga Satuan',
        'Total',
      ];

      final tableData = <List<String>>[];
      double grandTotal = 0;
      for (int i = 0; i < data.length; i++) {
        final t = data[i];
        final barang = barangProvider.getBarangById(t.barangId);
        final namaBarang = barang?.nama ?? 'Unknown';
        final hargaSatuan = t.hargaSatuan;
        final total = t.totalHarga;
        grandTotal += total;

        tableData.add([
          '${i + 1}',
          DateFormat('dd/MM/yyyy').format(t.tanggal),
          namaBarang,
          t.tipeTransaksi,
          t.jumlah.toString(),
          currency.format(hargaSatuan),
          currency.format(total),
        ]);
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context ctx) => [
            // 🔹 Header (Logo + Nama Gudang + Tanggal Cetak)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    pw.SizedBox(width: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'PT Gudang Sejahtera',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Jl. Raya Gudang No. 123, Jakarta',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Text(
                  DateFormat('dd MMM yyyy').format(DateTime.now()),
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              ],
            ),
            pw.Divider(),

            // 🔹 Judul Laporan
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'LAPORAN TRANSAKSI',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Periode: ${DateFormat('dd/MM/yyyy').format(range.start)} - ${DateFormat('dd/MM/yyyy').format(range.end)}',
                    style: pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // 🔹 Tabel Transaksi
            pw.TableHelper.fromTextArray(
              headers: tableHeaders,
              data: tableData,
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              headerDecoration: pw.BoxDecoration(color: PdfColors.blueGrey900),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
              columnWidths: {
                0: const pw.FlexColumnWidth(0.6),
                1: const pw.FlexColumnWidth(1.4),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1.3),
                4: const pw.FlexColumnWidth(1.4),
                5: const pw.FlexColumnWidth(1.6),
                6: const pw.FlexColumnWidth(1.6),
              },
            ),

            pw.SizedBox(height: 20),

            // 🔹 Grand Total
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Row(
                    children: [
                      pw.Text(
                        'Grand Total: ',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        currency.format(grandTotal),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          // 🔹 Footer otomatis di setiap halaman
          footer: (context) => pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Dicetak oleh: Admin Gudang',
                style: pw.TextStyle(fontSize: 9),
              ),
              pw.Text(
                'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                style: pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      print('❌ Error generate PDF: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuat PDF: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      // Auto-fill untuk periode Mingguan dan Bulanan
      if (_period == 'Mingguan' || _period == 'Bulanan') {
        _updateDateRangeFromPeriod(picked);
      }
    }
  }

  void _updateDateRangeFromPeriod(DateTime selectedDate) {
    if (_period == 'Mingguan') {
      // Hitung awal minggu (Senin) dan akhir minggu (Minggu)
      final weekday = selectedDate.weekday;
      final monday = selectedDate.subtract(Duration(days: weekday - 1));
      final sunday = monday.add(const Duration(days: 6));
      setState(() {
        _fromDate = DateTime(monday.year, monday.month, monday.day);
        _toDate = DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59);
      });
    } else if (_period == 'Bulanan') {
      // Hitung awal bulan dan akhir bulan
      final start = DateTime(selectedDate.year, selectedDate.month, 1);
      final end = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        1,
      ).subtract(const Duration(seconds: 1));
      setState(() {
        _fromDate = start;
        _toDate = end;
      });
    }
  }

  Future<void> _pickFromTo() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaksiProvider = Provider.of<TransaksiProvider>(context);
    final filtered = _filterTransactions(transaksiProvider.transaksiList);

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Transaksi'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () async {
            final theme = Theme.of(context);

            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: theme.colorScheme.error,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Konfirmasi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  "Apakah Anda yakin ingin keluar?",
                  style: TextStyle(fontSize: 15, height: 1.4),
                ),
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            foregroundColor: theme.colorScheme.onSurface,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                          ),
                          child: const Text("Batal"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.exit_to_app_rounded, size: 20),
                          label: const Text("Ya, Keluar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            shadowColor: theme.colorScheme.error.withOpacity(
                              0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );

            if (shouldExit == true) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _period,
                    items: ['Harian', 'Mingguan', 'Bulanan']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _period = v ?? 'Harian'),
                    decoration: InputDecoration(labelText: 'Periode'),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: Icon(Icons.date_range_rounded, color: Colors.white),
                  label: Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Tampilkan rentang tanggal untuk Mingguan/Bulanan/Custom
            if (_period != 'Harian') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rentang Tanggal:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey700,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dari:',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _fromDate != null
                                    ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_fromDate!)
                                    : '-',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Hingga:',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _toDate != null
                                    ? DateFormat('dd/MM/yyyy').format(_toDate!)
                                    : '-',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : _generateAndPrintPdf,
                  icon: _loading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.picture_as_pdf),
                  label: Text('Cetak PDF'),
                ),
                SizedBox(width: 12),
                Text(
                  'Hasil: ${filtered.length} transaksi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final t = filtered[index];
                      final barang = Provider.of<BarangProvider>(
                        context,
                      ).getBarangById(t.barangId);
                      return ListTile(
                        leading: Icon(
                          t.tipeTransaksi.toLowerCase() == 'masuk'
                              ? Icons.call_received
                              : Icons.call_made,
                          color: t.tipeTransaksi.toLowerCase() == 'masuk'
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        title: Text(barang?.nama ?? 'Barang tidak diketahui'),
                        subtitle: Text(
                          '${DateFormat('dd/MM/yyyy').format(t.tanggal)} • ${t.jumlah} unit',
                        ),
                        trailing: Text(
                          NumberFormat.simpleCurrency(
                            locale: 'id_ID',
                            decimalDigits: 0,
                          ).format(t.totalHarga),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
