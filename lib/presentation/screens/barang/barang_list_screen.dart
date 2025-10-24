import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/barang_provider.dart';
import '../../providers/kategori_provider.dart';
import '../../../data/models/barang_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/kategori_model.dart';

class BarangListScreen extends StatefulWidget {
  @override
  _BarangListScreenState createState() => _BarangListScreenState();
}

class _BarangListScreenState extends State<BarangListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<BarangModel> _filteredBarang = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadData() async {
    final barangProvider = Provider.of<BarangProvider>(context, listen: false);
    final kategoriProvider = Provider.of<KatagoriProvider>(
      context,
      listen: false,
    );

    await barangProvider.loadBarangByUser();
    await kategoriProvider.loadKatagori();

    setState(() {
      _filteredBarang = barangProvider.barangList;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final barangProvider = Provider.of<BarangProvider>(context, listen: false);

    if (query.isEmpty) {
      setState(() {
        _filteredBarang = barangProvider.barangList;
      });
    } else {
      setState(() {
        _filteredBarang = barangProvider.barangList.where((barang) {
          return barang.nama.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final barangProvider = Provider.of<BarangProvider>(context);
    final kategoriProvider = Provider.of<KatagoriProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Daftar Barang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: ResponsiveLayout.getFontSize(context, 20, 22, 24),
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(ResponsiveLayout.getPadding(context)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari barang...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: ResponsiveLayout.getFontSize(context, 20, 22, 24),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveLayout.getPadding(context),
                    vertical: ResponsiveLayout.getPadding(context),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: barangProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _filteredBarang.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: ResponsiveLayout.getFontSize(
                            context,
                            48,
                            56,
                            64,
                          ),
                          color: AppColors.grey400,
                        ),
                        SizedBox(height: ResponsiveLayout.getPadding(context)),
                        Text(
                          'Tidak ada barang',
                          style: TextStyle(
                            fontSize: ResponsiveLayout.getFontSize(
                              context,
                              16,
                              18,
                              20,
                            ),
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBarang.length,
                    itemBuilder: (context, index) {
                      final barang = _filteredBarang[index];
                      final kategori = kategoriProvider.katagoriList.firstWhere(
                        (kat) => kat.id == barang.katagoriId,
                        orElse: () => KatagoriModel(
                          id: -1,
                          nama: 'Tidak Diketahui',
                          warna:
                              '#${AppColors.primary.value.toRadixString(16)}',
                          UserId: null,
                        ),
                      );

                      final Color cardColor = _getKategoriColor(kategori);

                      return InkWell(
                        onTap: () {
                          _navigateToDetailBarang(context, barang, kategori);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: ResponsiveLayout.getPadding(context),
                            vertical: 4,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  cardColor.withOpacity(0.05),
                                  cardColor.withOpacity(0.02),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: ResponsiveLayout.getFontSize(
                                  context,
                                  40,
                                  45,
                                  50,
                                ),
                                height: ResponsiveLayout.getFontSize(
                                  context,
                                  40,
                                  45,
                                  50,
                                ),
                                decoration: BoxDecoration(
                                  color: cardColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.inventory_2,
                                  color: cardColor,
                                  size: ResponsiveLayout.getFontSize(
                                    context,
                                    18,
                                    20,
                                    22,
                                  ),
                                ),
                              ),
                              title: Text(
                                barang.nama,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveLayout.getFontSize(
                                    context,
                                    14,
                                    16,
                                    18,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kategori: ${kategori.nama}',
                                    style: TextStyle(
                                      fontSize: ResponsiveLayout.getFontSize(
                                        context,
                                        10,
                                        12,
                                        14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ResponsiveLayout.getPadding(
                                      context,
                                    ),
                                  ),
                                  Text(
                                    'Stok: ${barang.stok} unit',
                                    style: TextStyle(
                                      fontSize: ResponsiveLayout.getFontSize(
                                        context,
                                        10,
                                        12,
                                        14,
                                      ),
                                      color: barang.stok > 5
                                          ? AppColors.success
                                          : barang.stok > 0
                                          ? AppColors.warning
                                          : AppColors.error,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: cardColor,
                                  size: ResponsiveLayout.getFontSize(
                                    context,
                                    20,
                                    22,
                                    24,
                                  ),
                                ),
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    await Navigator.pushNamed(
                                      context,
                                      '/barang/form',
                                      arguments: barang,
                                    );
                                    // Reload data setelah edit
                                    _loadData();
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(context, barang);
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: AppColors.primary,
                                          size: ResponsiveLayout.getFontSize(
                                            context,
                                            18,
                                            20,
                                            22,
                                          ),
                                        ),
                                        SizedBox(
                                          width: ResponsiveLayout.getPadding(
                                            context,
                                          ),
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveLayout.getFontSize(
                                                  context,
                                                  12,
                                                  14,
                                                  16,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: AppColors.error,
                                          size: ResponsiveLayout.getFontSize(
                                            context,
                                            18,
                                            20,
                                            22,
                                          ),
                                        ),
                                        SizedBox(
                                          width: ResponsiveLayout.getPadding(
                                            context,
                                          ),
                                        ),
                                        Text(
                                          'Hapus',
                                          style: TextStyle(
                                            fontSize:
                                                ResponsiveLayout.getFontSize(
                                                  context,
                                                  12,
                                                  14,
                                                  16,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/barang/form');
          // Reload data setelah kembali dari form
          _loadData();
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: ResponsiveLayout.getFontSize(context, 24, 26, 28),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Color _getKategoriColor(KatagoriModel kategori) {
    if (kategori.warna == null || kategori.warna!.isEmpty) {
      return AppColors.primary;
    }

    try {
      String hexColor = kategori.warna!.toUpperCase().replaceAll("#", "");
      if (hexColor.length == 6) {
        hexColor = "FF$hexColor";
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  void _navigateToDetailBarang(
    BuildContext context,
    BarangModel barang,
    KatagoriModel kategori,
  ) {
    Navigator.pushNamed(
      context,
      '/barang/detail',
      arguments:
          {'barang': barang, 'kategori': kategori} as Map<String, dynamic>,
    );
  }

  void _showDeleteDialog(BuildContext context, BarangModel barang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Barang',
          style: TextStyle(
            fontSize: ResponsiveLayout.getFontSize(context, 16, 18, 20),
          ),
        ),
        content: Text('Yakin hapus ${barang.nama}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: AppColors.grey600,
                fontSize: ResponsiveLayout.getFontSize(context, 12, 14, 16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<BarangProvider>(
                context,
                listen: false,
              ).deleteBarang(barang.id!);
              // Reload data setelah delete
              _loadData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Barang berhasil dihapus'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              'Hapus',
              style: TextStyle(
                fontSize: ResponsiveLayout.getFontSize(context, 12, 14, 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double getPadding(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 16;
    return 24;
  }

  static double getFontSize(
    BuildContext context,
    double mobileSize,
    double tabletSize,
    double desktopSize,
  ) {
    if (isMobile(context)) return mobileSize;
    if (isTablet(context)) return tabletSize;
    return desktopSize;
  }
}
