import 'package:flutter/material.dart';
import 'package:gstok/presentation/screens/responsive_layout.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Header Section
                      _buildHeaderSection(context),
                      // Form Section
                      _buildFormSection(context, authProvider),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveLayout.isMobile(context) ? 16 : 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogo(context),
          SizedBox(height: ResponsiveLayout.isMobile(context) ? 12 : 16),
          _buildTitle(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      width: ResponsiveLayout.isMobile(context) ? 150 : 200,
      height: ResponsiveLayout.isMobile(context) ? 120 : 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(115, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset('assets/images/Gstok Logo.png', fit: BoxFit.contain),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          'Buat Akun Baru',
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: ResponsiveLayout.isMobile(context) ? 2 : 4),
        Text(
          'Isi data diri Anda untuk mendaftar',
          style: TextStyle(
            fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
            color: AppColors.grey100,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Form Section
  Widget _buildFormSection(BuildContext context, AuthProvider authProvider) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              _buildTextFormField(
                controller: _nameController,
                label: 'Nama Lengkap',
                prefixIcon: Icons.person_outlined,
                validator: _validateName,
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 12 : 16),

              // Email Field
              _buildTextFormField(
                controller: _emailController,
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 12 : 16),

              // Password Field
              _buildPasswordField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                obscureText: _obscurePassword,
                onToggleObscure: _togglePasswordVisibility,
                validator: _validatePassword,
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 12 : 16),

              // Confirm Password Field
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Konfirmasi Password',
                isPassword: false,
                obscureText: _obscureConfirmPassword,
                onToggleObscure: _toggleConfirmPasswordVisibility,
                validator: _validateConfirmPassword,
              ),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 20 : 24),

              // Register Button
              _buildRegisterButton(context, authProvider),
              SizedBox(height: ResponsiveLayout.isMobile(context) ? 16 : 20),

              // Login Link
              _buildLoginLink(context),
            ],
          ),
        ),
      ),
    );
  }

  // Text Form Field Builder
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.grey600),
          prefixIcon: Icon(prefixIcon, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  // Password Field Builder
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
    required bool obscureText,
    required VoidCallback onToggleObscure,
    required String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.grey600),
          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.primary,
            ),
            onPressed: onToggleObscure,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }

  // Register Button
  Widget _buildRegisterButton(BuildContext context, AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      height: ResponsiveLayout.isMobile(context) ? 44 : 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: authProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : ElevatedButton(
              onPressed: () => _registerUser(context, authProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Daftar',
                style: TextStyle(
                  fontSize: ResponsiveLayout.isMobile(context) ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  // Login Link
  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: TextStyle(
            color: AppColors.grey600,
            fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            'Login',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveLayout.isMobile(context) ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  // Validation Methods
  String? _validateName(String? value) {
    if (value?.isEmpty ?? true) return 'Nama harus diisi';
    if (value!.length < 3) return 'Nama minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Email harus diisi';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'Email tidak valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password harus diisi';
    if (value!.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value?.isEmpty ?? true) return 'Konfirmasi password harus diisi';
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Toggle Methods
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  // Registration Handler - DIPERBARUI dengan parameter context
  Future<void> _registerUser(
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Focus unfocus untuk menutup keyboard
    FocusScope.of(context).unfocus();

    try {
      final success = await authProvider.register(
        _nameController.text.trim(),
        _emailController.text.trim().toLowerCase(),
        _passwordController.text,
        context, // 🔹 TAMBAHKAN PARAMETER CONTEXT
      );

      if (success && mounted) {
        _showSuccessSnackBar(context, 'Registrasi berhasil! Silakan login.');
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/login');
      } else if (mounted) {
        _showErrorSnackBar(context, authProvider.error ?? 'Registrasi gagal');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(context, 'Terjadi kesalahan: $e');
      }
    }
  }

  // SnackBar Methods
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi gagal: $error'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
