import 'package:flutter/material.dart';
import 'package:mrz_avis_verification/screens/mobile_scanner.dart';
import 'package:mrz_avis_verification/services/api_service.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'otp_screen.dart';
import '../widgets/custom_button.dart';

// Defines the primary color used throughout the screen (Orange/Brown shade)
const Color _kPrimaryColor = Color(0xFFE99742);

// Main stateful widget for the verification process.
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // State variable to track which tab is currently selected (0 for UIN, 1 for QR).
  int _selectedTab = 0;

  // --- UI BUILDING METHODS ---

  TextEditingController uinController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  // Builds the fixed header section at the top of the screen.
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          // Top status bar/safe area spacer with a light background color.
          Container(
            height: MediaQuery.of(context).padding.top + 50,
            color: const Color(0xFFF5E4D1),
            alignment: Alignment.bottomCenter,
          ),
          // Logo and horizontal padding section.
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 16.0, left: 20.0, right: 20.0),
            child: Row(
              children: [
                // Logo image display.
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Image.asset(
                    'assets/images/mrz_main_logo.png',
                    height: 45,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal divider line below the logo.
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  // Builds the two-tab bar (UIN Number and QR Code scan).
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Button for 'By UIN Number' tab.
          _buildTabButton(
            label: 'By UIN Number',
            index: 0,
            isFirst: true, // Used for left-side rounded border.
          ),
          // Button for 'By QR Code scan' tab.
          _buildTabButton(
            label: 'By QR Code scan',
            index: 1,
            isFirst: false, // Used for right-side rounded border.
          ),
        ],
      ),
    );
  }

  // Helper method to build individual tab buttons.
  Widget _buildTabButton(
      {required String label, required int index, required bool isFirst}) {
    final isSelected = _selectedTab == index;

    // Defines border radius dynamically based on position (left or right).
    final borderRadius = BorderRadius.horizontal(
      left: isFirst ? const Radius.circular(8) : Radius.zero,
      right: isFirst ? Radius.zero : const Radius.circular(8),
    );

    return Expanded(
      child: InkWell(
        // Handles tab selection update.
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            // Changes background color based on selection.
            color: isSelected ? _kPrimaryColor : Colors.white,
            borderRadius: borderRadius,
            // Changes border color based on selection.
            border: Border.all(
              color: isSelected ? _kPrimaryColor : const Color(0xFFC0C0C0),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                // Changes text color based on selection.
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the form for UIN and Mobile number entry (Tab 0 content).
  Widget _buildUINForm(BuildContext context, AppState appState) {
    final apiService = ApiService();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Form title
            const Text(
              'Certificate Verify by UIN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // UIN Number Input
            const Text('UIN Number',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: uinController,
              onChanged: appState.setUIN,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Enter UIN Number',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),

            const SizedBox(height: 20),

            // Mobile Number Input
            const Text('Mobile Number',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              // Updates Mobile state in the provider.
              onChanged: appState.setMobile,
              decoration: const InputDecoration(
                hintText: 'Enter Mobile Number',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            // Check Button or Loading Indicator
            apiService.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: _kPrimaryColor))
                : CustomButton(
                    text: 'Check',
                    color: _kPrimaryColor,
                    onPressed: () async {
                      print("=============> UIN ${uinController.text}");
                      print("=============> MOBILE ${mobileController.text}");

                      apiService.verifyUIN(uinController.text.trim(),
                          mobileController.text.trim());
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // Builds the QR Scanner tab content (Tab 1 content).
  Widget _buildQRScannerPlaceholder() {
    const double kScannerHeight = 450.0;

    return Column(
      children: [
        // Orange QR section placeholder.
        Container(
          color: const Color(0xFFFC943D),
          width: double.infinity,
          height: kScannerHeight,
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Center(
            child: Image.asset(
              'assets/images/qr_code.png', // Placeholder image for QR area
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
        ),

        // Black container that is moved upwards to overlap the orange section.
        Transform.translate(
          // Moves the entire child container up by 50 pixels.
          offset: const Offset(0, -50),
          child: SizedBox(
            width: double.infinity,
            // Uses a Column to stack the main message and the "Let's Start" button.
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Ensures Column only takes required vertical space.
              children: [
                // Top section of the black overlay with rounded corners.
                Container(
                  padding: const EdgeInsets.only(
                      top: 50, bottom: 20), // Top padding pushes text down.
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    // Only rounds the top corners.
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Go and enjoy your features for free and\nmake your life easy with us.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                // Bottom section containing the blue line and "Let's Start" button.
                Container(
                  color: Colors.black, // Continues the black background.
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      // The Blue Separator Line (Simplified).
                      Container(
                        height: 2,
                        width: 300,
                        color: Colors.orange,
                        margin: const EdgeInsets.only(bottom: 30),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const QRScanScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              // "Let's Start" text and arrow, centered.
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Let's Start",
                                    // textAlign is redundant here as Row centers the widget itself.
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Space between text and icon.
                                  Icon(
                                    Icons.arrow_right_alt, // Right arrow icon.
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- MAIN BUILD METHOD ---

  @override
  Widget build(BuildContext context) {
    // Accesses the AppState object using Provider for shared state/data.
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context), // Fixed header (logo and divider).
          _buildTabBar(), // Tab selection buttons.
          // Expanded section handles scrolling for the main content.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 5),
              // Switches content based on the selected tab state (_selectedTab).
              child: _selectedTab == 0
                  ? _buildUINForm(context, appState)
                  : _buildQRScannerPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }
}
