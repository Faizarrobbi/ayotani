import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart'; // Add this import if missing
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';

// --- CONFIGURATION ---
const String supabaseUrl = 'https://djayruwdyfndnfskgtit.supabase.co';
const String supabaseAnonKey = 'sb_publishable_lTBN1VXJKHhw19KIKlk9nA_jMSs0Kb2';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Run the App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const App(),
    ),
  );
}