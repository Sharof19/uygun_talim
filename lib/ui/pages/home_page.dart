import 'package:flutter/material.dart';
import 'package:pr/ui/pages/profil.dart';
import 'package:pr/ui/pages/courses_page.dart';
import 'package:pr/ui/pages/exams_page.dart';
import 'package:pr/ui/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  static const Color _navColor = AppColors.primary;

  final List<Widget> _pages = const [CoursesPage(), ExamsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _navColor,
          border: Border(
            top: BorderSide(
              color: Colors.black.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Kurslar',
                tooltip: 'Kurslar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'Imtihonlar',
                tooltip: 'Imtihonlar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
                tooltip: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
