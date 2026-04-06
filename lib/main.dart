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
      title: 'Ajith KP | Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        textTheme: GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: AppColors.textSecondary,
                displayColor: AppColors.textPrimary,
              ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
