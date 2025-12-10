import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/circle_social_button.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _authService = AuthService();

  bool _remember = false;
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  OutlineInputBorder _border({Color color = AppColors.green}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1.2),
      );

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> _handleLogin() async {
    setState(() => _errorMessage = null);

    if (_emailC.text.isEmpty || _passC.text.isEmpty) {
      setState(() => _errorMessage = 'Email dan password tidak boleh kosong');
      return;
    }

    if (!_isValidEmail(_emailC.text)) {
      setState(() => _errorMessage = 'Format email tidak valid');
      return;
    }

    if (!_isValidPassword(_passC.text)) {
      setState(() => _errorMessage = 'Password minimal 6 karakter');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.signIn(
        email: _emailC.text.trim(),
        password: _passC.text,
      );

      if (mounted) {
        if (response.user != null) {
          // FIXED: Redirect to Home instead of Marketplace
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _parseAuthError(e.toString());
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _parseAuthError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Email atau password salah';
    } else if (error.contains('User not found')) {
      return 'Pengguna tidak ditemukan';
    } else if (error.contains('Email not confirmed')) {
      return 'Email belum diverifikasi';
    } else {
      return 'Login gagal. Coba lagi.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  "Masukkan  Username/Email  dan  Kata  Sandi\nakun anda untuk masuk",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.35,
                    color: Colors.black.withOpacity(0.65),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (_errorMessage != null) const SizedBox(height: 16),
              TextField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  disabledBorder: _border(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passC,
                obscureText: _obscure,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: "Kata sandi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  disabledBorder: _border(color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: !_isLoading ? () => setState(() => _obscure = !_obscure) : null,
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  InkWell(
                    onTap: !_isLoading ? () => setState(() => _remember = !_remember) : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          _SquareCheck(
                            checked: _remember,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Ingatkan saya",
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: !_isLoading
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Fitur reset password akan segera hadir'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    child: Text(
                      "Lupa Password?",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.65),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 46),
              Center(
                child: SizedBox(
                  width: 190,
                  height: 46,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Login"),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: !_isLoading
                    ? () {
                        Navigator.pushReplacementNamed(context, AppRoutes.signup);
                      }
                    : null,
                child: const Text(
                  "Belum punya akun?",
                  style: TextStyle(
                    fontSize: 13.8,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 44),
              Text(
                "Atau lanjut dengan",
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleSocialButton(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/icons/google.svg",
                      width: 22,
                      height: 22,
                    ),
                  ),
                  const SizedBox(width: 18),
                  CircleSocialButton(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/icons/apple.svg",
                      width: 22,
                      height: 22,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SquareCheck extends StatelessWidget {
  const _SquareCheck({required this.checked, required this.color});

  final bool checked;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: color, width: 1.8),
        color: checked ? color.withOpacity(0.12) : Colors.transparent,
      ),
      child: checked
          ? Icon(Icons.check, size: 14, color: color)
          : null,
    );
  }
}