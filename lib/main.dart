import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Pastikan ini ada
import 'core/theme/app_theme.dart';
import 'core/providers/app_provider.dart'; // Import provider kamu
import 'features/auth/presentation/pages/splash_page.dart';

void main() {
  runApp(
    // Membungkus seluruh aplikasi dengan Provider
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca status tema dari AppProvider
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'E-Ticketing Helpdesk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appProvider.themeMode, // Mengikuti settingan di Provider
      home: const SplashPage(),
    );
  }
}