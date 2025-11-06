import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              label: 'Enter OTP',
              onChanged: appState.setOTP,
            ),
            const SizedBox(height: 20),
            appState.isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: 'Verify OTP',
                    onPressed: () async {
                      await appState.verifyOTP(context);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
