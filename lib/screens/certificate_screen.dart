import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: Center(
        child: appState.certificateUrl.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Certificate Ready!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(appState.certificateUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: const Text('View / Download PDF'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
