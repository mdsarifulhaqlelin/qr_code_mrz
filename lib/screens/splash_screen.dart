import 'dart:async';
import 'package:flutter/material.dart';
import 'verification_screen.dart'; // Make sure this file exists

// 1. ANIMATED THREE-DOT LOADING WIDGET
// This StatefulWidget creates the sequential loading effect with three dots.

class ThreeDotLoading extends StatefulWidget {
  const ThreeDotLoading({super.key});

  @override
  State<ThreeDotLoading> createState() => _ThreeDotLoadingState();
}

class _ThreeDotLoadingState extends State<ThreeDotLoading> {
  // Keeps track of which dot is currently "active" (0, 1, or 2)
  int _activeDotIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the animation timer to update the dots every 300ms
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (mounted) {
        setState(() {
          // Cycle through the dots: 0 -> 1 -> 2 -> 0 -> ...
          _activeDotIndex = (_activeDotIndex + 1) % 3;
        });
      }
    });
  }

  @override
  void dispose() {
    // IMPORTANT: Cancel the timer to prevent memory leaks when the screen closes
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildDot(int dotIndex) {
    // Colors matching the orange/brown from your logo
    const Color activeColor = Color(0xFFE67823); 
    const Color inactiveColor = Color(0xFFF2A36B); // Lighter shade

    // Check if the current dot is the active one in the cycle
    final bool isActive = dotIndex == _activeDotIndex;

    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 8), 
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0), // Dot 1
        _buildDot(1), // Dot 2
        _buildDot(2), // Dot 3
      ],
    );
  }
}

// 2. UPDATED SPLASH SCREEN WIDGET
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to VerificationScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerificationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Using a light off-white color similar to the screenshot background
          color: Color(0xFFFCFCF9),
        ),
        child: Column(
          // Use spaceBetween to push the logo/loading to the middle and
          // the 'Design & Develop' text to the bottom.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Placeholder to help center the logo vertically
            const SizedBox.shrink(),

            // --- Middle Content (Logo and Animated Loading Dots) ---
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/mrz_logo.png', height: 120),
                
                // You can remove the old Text and CircularProgressIndicator:
                // const SizedBox(height: 20),
                // Text('MRZ AIVS Verification', style: ...),
                // const SizedBox(height: 10),
                // CircularProgressIndicator(color: Colors.white),

                const SizedBox(height: 50), 
                // *** Using the new Animated Loading Dots ***
                const ThreeDotLoading(),
              ],
            ),
            
            // --- Bottom Content (Design & Develop Text) ---
            Padding(
              padding: const EdgeInsets.only(bottom: 55.0), 
              child: Text.rich(
                TextSpan(
                  text: 'Design & Develop by ',
                  style: const TextStyle(
                    color: Colors.black54, // Default text color
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Codivoo Technologies',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // Orange/Brown color for emphasis
                        color: Color(0xFFE67823), 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}