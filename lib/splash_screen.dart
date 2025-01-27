import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_content_recommendation_application/common/colors.dart';
import 'package:smart_content_recommendation_application/common/typography.dart';
import 'package:smart_content_recommendation_application/content/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Speed of the wiggle
      vsync: this,
    )..repeat(reverse: true); // Repeat animation with reverse for wiggle effect

    // Define the wiggle animation
    _wiggleAnimation = Tween<double>(
      begin: -0.05, // Slight rotation to the left
      end: 0.05, // Slight rotation to the right
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.2),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(flex: 3), // Push animation and text to the center
            AnimatedBuilder(
              animation: _wiggleAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _wiggleAnimation.value, // Apply the wiggle effect
                  child: Lottie.asset(
                    'assets/lottie/ai_hand_waving.json',
                    height: 350, // Adjust size
                    width: 350,
                  ),
                );
              },
            ),
            const SizedBox(height: 20), // Spacing between animation and text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Effortlessly fetch videos, articles, and images tailored to your query in one click!",
                textAlign: TextAlign.center,
                style: SCRTypography.subHeading
                    .copyWith(color: white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30), // Spacing between text and button
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(flex: 2), // Push everything upwards a bit
          ],
        ),
      ),
    );
  }
}
