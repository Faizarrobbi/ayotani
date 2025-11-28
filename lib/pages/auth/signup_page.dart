import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/circle_social_button.dart';
import '../../widgets/round_check.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  bool _agree = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _confirmC.dispose();
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
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                "Daftar dulu gasih?",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Masukkan Email dan Kata Sandi untuk membuat\nakun baru",
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.35,
                  color: Colors.black.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 22),

              TextField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _passC,
                obscureText: _obscure1,
                decoration: InputDecoration(
                  hintText: "Kata sandi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure1 = !_obscure1),
                    icon: Icon(
                      _obscure1 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _confirmC,
                obscureText: _obscure2,
                decoration: InputDecoration(
                  hintText: "Verifikasi kata sandi",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  enabledBorder: _border(),
                  focusedBorder: _border(),
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure2 = !_obscure2),
                    icon: Icon(
                      _obscure2 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              InkWell(
                onTap: () => setState(() => _agree = !_agree),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      RoundCheck(checked: _agree, color: AppColors.green),
                      const SizedBox(width: 10),
                      Text(
                        "Setuju dengan Syarat dan Ketentuan",
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Center(
                child: SizedBox(
                  width: 190,
                  height: 46,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
                    ),
                    onPressed: !_agree ? null : () {},
                    child: const Text("Daftar"),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text(
                    "Sudah punya akun?",
                    style: TextStyle(
                      fontSize: 13.8,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 44),

              Center(
                child: Text(
                  "Atau lanjut dengan",
                  style: TextStyle(fontSize: 13.5, color: Colors.black.withOpacity(0.6)),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleSocialButton(
                    onTap: () {},
                    child: SvgPicture.asset("assets/icons/google.svg", width: 22, height: 22),
                  ),
                  const SizedBox(width: 18),
                  CircleSocialButton(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/icons/apple.svg",
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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
