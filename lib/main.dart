import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/kategori_provider.dart';
import 'presentation/providers/barang_provider.dart';
import 'presentation/providers/transaksi_provider.dart';
import 'presentation/providers/provider_manager.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/katagori/detail_katagori.dart';
import 'presentation/screens/katagori/katagori_list_screen.dart';
import 'presentation/screens/katagori/katagori_form_screen.dart';
import 'presentation/screens/barang/barang_list_screen.dart';
import 'presentation/screens/barang/barang_form_screen.dart';
import 'presentation/screens/barang/barang_detail_screen.dart';
import 'presentation/screens/transaksi/transaksi_list_screen.dart';
import 'presentation/screens/transaksi/transaksi_form.screen.dart';
import 'presentation/screens/transaksi/transaksi_detail_screen.dart';
import 'presentation/screens/reports/transaksi_report_screen.dart';
import '../core/constants/app_colors.dart';
import 'presentation/screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) => KatagoriProvider(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              BarangProvider(Provider.of<AuthProvider>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => TransaksiProvider(
            Provider.of<AuthProvider>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Inventory App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          primaryColorDark: AppColors.primaryDark,
          primaryColorLight: AppColors.primaryLight,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.primaryLight,
            background: AppColors.background,
            surface: AppColors.surface,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ),
        home: AppStartup(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/main': (context) => MainScreen(),
          '/home': (context) => DashboardScreen(),
          '/kategori': (context) => KategoriListScreen(),
          '/kategori/form': (context) => KatagoriFormScreen(),
          '/kategori/detail': (context) => KatagoriDetailScreen(),
          '/barang': (context) => BarangListScreen(),
          '/barang/form': (context) => BarangFormScreen(),
          '/barang/detail': (context) => BarangDetailScreen(),
          '/transaksi': (context) => TransaksiListScreen(),
          '/transaksi/form': (context) => TransaksiFormScreen(),
          '/transaksi/detail': (context) => TransaksiDetailScreen(),
          '/reports/transaksi': (context) => TransaksiReportScreen(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}

class AppStartup extends StatefulWidget {
  @override
  _AppStartupState createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    // Reset semua provider saat app start untuk pastikan state bersih
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProviderManager.resetAllProviders(context);
      print('🚀 App startup: Semua provider di-reset');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return auth.isAuthenticated ? MainScreen() : LoginScreen();
      },
    );
  }
}

// Widget untuk Main Screen dengan Bottom Navigation Bar
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar screen yang akan ditampilkan di bottom navigation
  final List<Widget> _screens = [
    DashboardScreen(),
    BarangListScreen(),
    KategoriListScreen(),
    TransaksiListScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Barang'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        onTap: _onItemTapped,
      ),
    );
  }
}
