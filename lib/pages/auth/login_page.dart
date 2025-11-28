import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/circle_social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userC = TextEditingController();
  final _passC = TextEditingController();

  bool _remember = false;
  bool _obscure = true;

  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  OutlineInputBorder _border({Color color = AppColors.green}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1.2),
      );

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

              // Username
              TextField(
                controller: _userC,
                decoration: InputDecoration(
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
              ),

              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passC,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: "Kata sandi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  // kalau mau persis gambar: hapus suffixIcon ini
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Remember + Forgot
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _remember = !_remember),
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
                    onTap: () {
                      // TODO: forgot password action
                    },
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

              // Login button
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
                    ),
                    onPressed: () {
                      // TODO: handle login
                    },
                    child: const Text("Login"),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Link to signup
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signup);
                },
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
                    onTap: () {
                      // TODO: Google sign-in
                    },
                    child: SvgPicture.asset(
                      "assets/icons/google.svg",
                      width: 22,
                      height: 22,
                    ),
                  ),
                  const SizedBox(width: 18),
                  CircleSocialButton(
                    onTap: () {
                      // TODO: Apple sign-in
                    },
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
        borderRadius: BorderRadius.circular(2), // kotak seperti gambar
        border: Border.all(color: color, width: 1.8),
        color: checked ? color.withOpacity(0.12) : Colors.transparent,
      ),
      child: checked
          ? Icon(Icons.check, size: 14, color: color)
          : null,
    );
  }
}
