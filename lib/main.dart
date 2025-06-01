import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/new_message_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://yufhlukoapktapagwjcn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl1ZmhsdWtvYXBrdGFwYWd3amNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxMDUyOTksImV4cCI6MjA2MzY4MTI5OX0.s91DSn6aFsYCh0s4EjOmFBGRQPQJ-Ivx0RrJZcEn7SU',
  );
  runApp(const SpamSnapApp());
}

class SpamSnapApp extends StatelessWidget {
  const SpamSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpamSnap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/new-message': (context) => const NewMessageScreen(),
      },
    );
  }
}
