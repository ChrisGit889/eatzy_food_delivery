import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan file ini ada

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller untuk PageView
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Data untuk setiap halaman onboarding
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'color': Colors.blue.shade100,
      'imagePath':
          'assets/images/onboarding1.png', // Ganti dengan path gambar Anda
      'title': 'Find your place',
      'description':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
    },
    {
      'color': Colors.pink.shade100,
      'imagePath':
          'assets/images/onboarding2.png', // Ganti dengan path gambar Anda
      'title': 'Contact us anytime',
      'description':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
    },
    {
      'color': Colors.purple.shade100,
      'imagePath':
          'assets/images/onboarding3.png', // Ganti dengan path gambar Anda
      'title': 'Pick your food',
      'description':
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _onboardingData.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          return _buildOnboardingPage(
            color: _onboardingData[index]['color'],
            imagePath: _onboardingData[index]['imagePath'],
            title: _onboardingData[index]['title'],
            description: _onboardingData[index]['description'],
            isLastPage: index == _onboardingData.length - 1,
          );
        },
      ),
    );
  }

  Widget _buildOnboardingPage({
    required Color color,
    required String imagePath,
    required String title,
    required String description,
    required bool isLastPage,
  }) {
    return Container(
      color: color,
      child: Column(
        children: [
          // Bagian atas untuk gambar
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(imagePath),
            ),
          ),
          // Bagian bawah untuk kartu putih
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const Spacer(), // Mendorong tombol ke bawah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (isLastPage) {
                            _navigateToLogin();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.orange.shade700,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
