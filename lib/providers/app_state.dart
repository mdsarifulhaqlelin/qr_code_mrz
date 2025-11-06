import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/certificate_screen.dart';
import 'package:another_flushbar/flushbar.dart';

class AppState extends ChangeNotifier {
  final ApiService apiService = ApiService();

  String uin = '';
  String mobileNumber = '';
  String _mobile = '';
  String otp = '';
  String certificateUrl = '';
  bool isLoading = false;
  String get mobile => _mobile;

  void setUIN(String value) {
    uin = value.trim();
    notifyListeners();
  }

  void setMobile(String value) {
    mobileNumber = value;
    notifyListeners();
    _mobile = value.trim();
  }

  void setOTP(String value) {
    otp = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<bool> verifyUIN() async {
    setLoading(true);
    final result = await apiService.verifyUIN(uin, mobileNumber);
    setLoading(false);
    return result['success'] ?? false;
  }

  Future<bool> verifyOTP(BuildContext context) async {
    setLoading(true);
    try {
      final otpResult = await apiService.verifyOTP(otp);
      if (otpResult['success'] == true) {
        final certResponse = await apiService.getCertificate(uin, mobileNumber);

        if (certResponse['status'] == 'success' &&
            certResponse['certificate_url'] != null) {
          certificateUrl = certResponse['certificate_url'];
          notifyListeners();

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (_) => const CertificateScreen()),
          );
          return true;
        } else {
          // ignore: use_build_context_synchronously
          Flushbar(
            title: 'Verification Failed',
            message: 'UIN or Mobile number mismatch.',
            icon: const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            margin: const EdgeInsets.all(12),
            flushbarPosition: FlushbarPosition.TOP,
          // ignore: use_build_context_synchronously
          ).show(context);

          return false;
        }
      } else {
        // ignore: use_build_context_synchronously
        Flushbar(
          title: 'Invalid OTP',
          message: 'Please enter a valid OTP and try again.',
          icon: const Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
          margin: const EdgeInsets.all(12),
          flushbarPosition: FlushbarPosition.TOP,
        // ignore: use_build_context_synchronously
        ).show(context);

        return false;
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }
}
