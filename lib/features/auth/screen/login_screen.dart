import 'package:flutter/material.dart';
import 'package:whats_app_task/core/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _verificationId = '';
  bool _codeSent = false;
  bool _isLoading = false;

  Future<void> _verifyPhoneNumber() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithPhoneNumber(_phoneController.text);
      setState(() => _codeSent = true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    setState(() => _isLoading = true);
    try {
      await _authService.verifySMSCode(_verificationId, _codeController.text);
      // Navigation to home screen will be handled by auth state listener
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Clone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/whatsapp_logo.png',
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            if (_codeSent) ...[
              TextField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _codeSent
                    ? _verifyCode
                    : _verifyPhoneNumber,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(_codeSent ? 'Verify Code' : 'Send Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
