import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_web/screens/home_screen.dart';
import 'constants/colors.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajith KP · Senior Flutter & Mobile Engineer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.violet,
          surface: AppColors.surface,
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.violet.withValues(alpha: 0.4),
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData.dark().textTheme.apply(
                bodyColor: AppColors.textSecondary,
                displayColor: AppColors.textPrimary,
              ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
