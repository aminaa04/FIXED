import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_page/Screeen/auth_screen/Login.dart';
import 'package:screen_page/Screeen/auth_screen/SignUpScreen.dart';
import 'package:screen_page/Screeen/auth_screen/SignUpScreen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _pages = [
    {
      'image': 'assets/Images/Electrician-rafiki.jpg',
      'imageType': 'jpg',
      'text':
          'Get ready for the perfect app experience.\nWe\'ll customize everything\nto your preferences and location.',
      'buttonText': 'Next',
    },
    {
      'image': 'assets/Images/Location.jpg',
      'imageType': 'jpg',
      'text':
          'Enjoy the ease of booking and\ntracking your service\nend-to-end.',
      'buttonText': 'Next',
    },
    {
      'image': 'assets/Svg/Settings-rafiki.svg',
      'imageType': 'svg',
      'text': 'Warranty-backed\nservice through service\nexperts.',
      'buttonText': 'Get started',
    },
    {
      'image': 'assets/Images/auth.jpg',
      'imageType': 'jpg',
      'text': 'Welcome! Let’s take \nthe first step together.',
      'buttonText': 'Log In',
      'nbr_of_button': 2,
      'buttonText2': 'Sing Up',
    },
  ];

  void _nextPage(String buttonText) {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      buttonText == 'Log In'
          ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          )
          : Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPageContent(page);
                },
              ),
            ),
            _buildPageIndicator(),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(Map<String, dynamic> page) {
    return Column(
      children: [
        const Spacer(flex: 2),
        _buildImage(page),
        const SizedBox(height: 20),
        _buildText(page['text']),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _buildImage(Map<String, dynamic> page) {
    return Container(
      width: 205,
      height: 305,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
            page['imageType'] == 'svg'
                ? SvgPicture.asset(page['image'], fit: BoxFit.cover)
                : Image.asset(page['image'], fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color:
                _currentPage == index
                    ? Colors.amber
                    : Colors.grey.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildActionButton() {
    return _pages[_currentPage]['nbr_of_button'] == 2
        ? Padding(
          padding: const EdgeInsets.only(bottom: 40, top: 40),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _nextPage('${_pages[_currentPage]['buttonText']}');
                  },
                  child: Text(
                    _pages[_currentPage]['buttonText'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _nextPage('${_pages[_currentPage]['buttonText2']}');
                  },
                  child: Text(
                    _pages[_currentPage]['buttonText2'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : Padding(
          padding: const EdgeInsets.only(bottom: 40, top: 40),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                _nextPage('${_pages[_currentPage]['buttonText']}');
              },
              child: Text(
                _pages[_currentPage]['buttonText'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Main App Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
