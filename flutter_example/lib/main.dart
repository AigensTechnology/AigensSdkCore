import 'package:flutter/material.dart';
import 'package:aigens_sdk_core/aigens_sdk_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aigens SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _resultMessage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aigens SDK Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _openUrl,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Open Aigens WebContainer'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkWeChatInstalled,
              child: const Text('Check WeChat Installed'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openExternalUrl,
              child: const Text('Open External URL'),
            ),
            if (_resultMessage != null) ...[
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Result:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_resultMessage!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl() async {
    setState(() {
      _isLoading = true;
      _resultMessage = null;
    });

    try {
      final closedData = await AigensSdkCore.openUrl(
        url: 'https://fairwood-uat-v4.order.place/order/store/600002/mode/catering',
        member: MemberData(
          memberCode: 'testMember123',
          source: 'testMerchant',
          sessionId: 'testSession123',
          pushId: 'testPushToken123',
          deviceId: 'testDevice123',
          universalLink: 'https://yourdomain.com/toapp',
          appScheme: 'yourappscheme',
          appleMerchantId: 'merchant.your.merchant.id', // iOS only
          language: 'en',
          isGuest: false,
        ),
        deeplink: DeeplinkData(
          addItemId: 'item123',
          addDiscountCode: 'DISCOUNT10',
          addOfferId: 'offer123',
        ),
        debug: true, // Set to true for UAT/testing
        clearCache: false,
        environmentProduction: true,
      );

      setState(() {
        _isLoading = false;
        if (closedData != null) {
          _resultMessage = 'Closed with:\n'
              'Redirect URL: ${closedData.redirectUrl ?? "N/A"}\n'
              'Action: ${closedData.action ?? "N/A"}';
        } else {
          _resultMessage = 'WebContainer closed (no data)';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _resultMessage = 'Error: $e';
      });
    }
  }

  Future<void> _checkWeChatInstalled() async {
    try {
      final isInstalled = await AigensSdkCore.isInstalledApp('weixin://');
      setState(() {
        _resultMessage = 'WeChat installed: $isInstalled';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Error checking app: $e';
      });
    }
  }

  Future<void> _openExternalUrl() async {
    try {
      await AigensSdkCore.openExternalUrl('https://www.aigens.com');
      setState(() {
        _resultMessage = 'External URL opened successfully';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Error opening URL: $e';
      });
    }
  }
}

