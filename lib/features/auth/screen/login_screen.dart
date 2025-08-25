import 'package:flutter/material.dart';
import 'package:whats_app_task/core/services/auth_services.dart';
import 'package:whats_app_task/features/home/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();

  // Controllers for phone login
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String _verificationId = '';
  bool _codeSent = false;
  bool _isLoading = false;

  // Controllers for email login
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // ==================== PHONE LOGIN (Mock) ====================
  Future<void> _verifyPhoneNumber() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // mock delay
    setState(() {
      _codeSent = true;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mock: Code sent (use 123456)")),
    );
  }

  Future<void> _verifyCode() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));
    if (_codeController.text.trim() == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid code. Try 123456")));
    }

    setState(() => _isLoading = false);
  }

  // ==================== EMAIL LOGIN ====================
  Future<void> _loginWithEmail() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _registerWithEmail() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${e.toString()}")),
      );
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WhatsApp Clone')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Phone Login"),
              Tab(text: "Email Login"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildPhoneLogin(), _buildEmailLogin()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLogin() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/whats.png', height: 80, width: 80),
          const SizedBox(height: 32),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
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
    );
  }

  Widget _buildEmailLogin() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _loginWithEmail,
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerWithEmail,
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _codeController = TextEditingController();
//   String _verificationId = '';
//   bool _codeSent = false;
//   bool _isLoading = false;

//   Future<void> _verifyPhoneNumber() async {
//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(const Duration(seconds: 1)); // simulation delay
//     setState(() {
//       _codeSent = true;
//       _isLoading = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Mock: Code sent (use 123456)")),
//     );
//   }

//   Future<void> _verifyCode() async {
//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(const Duration(seconds: 1)); 
//     if (_codeController.text.trim() == "123456") {
        
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) {
//             return const HomeScreen();
//           },
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Invalid code. Try 123456")));
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('WhatsApp Clone')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/whats.png', height: 80, width: 80),
//             const SizedBox(height: 32),
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',

//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 16),
//             if (_codeSent) ...[
//               TextField(
//                 controller: _codeController,
//                 decoration: const InputDecoration(
//                   labelText: 'Verification Code',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//             ],
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading
//                     ? null
//                     : _codeSent
//                     ? _verifyCode
//                     : _verifyPhoneNumber,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : Text(_codeSent ? 'Verify Code' : 'Send Code'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


///// *****************     True verify phone number    *****************
  // Future<void> _verifyPhoneNumber() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     String rawPhone = _phoneController.text.trim();

  //     String formattedPhone;
  //     if (rawPhone.startsWith("0")) {
  //       formattedPhone = "+20${rawPhone.substring(1)}";
  //     } else {
  //       formattedPhone = "+20$rawPhone";
  //     }

  //     await _authService.signInWithPhoneNumber(
  //       formattedPhone,
  //       onCodeSent: (verificationId) {
  //         setState(() {
  //           _verificationId = verificationId;
  //           _codeSent = true;
  //         });
  //       },
  //     );

  //     setState(() => _codeSent = true);
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }
  ///// *****************     True verify code     *****************

  // Future<void> _verifyCode() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     await _authService.verifySMSCode(_verificationId, _codeController.text);
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }