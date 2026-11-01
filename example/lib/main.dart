import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/container/universal_container_showcase_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const Material4ContainerApp());
}

class Material4ContainerApp extends StatelessWidget {
  const Material4ContainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material 4 — Universal Container',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E43EE),
          surface: const Color(0xFFF7F5F2),
        ),
        fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      ),
      home: const UniversalContainerShowcaseScreen(),
    );
  }
}
