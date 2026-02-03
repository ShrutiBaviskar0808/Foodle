import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  List<String> _otpDigits = ['', '', '', ''];
  late String _generatedOtp;
  int _secondsRemaining = 540;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _generateOtp();
    _startTimer();
  }

  // Generate random 4-digit OTP
  void _generateOtp() {
    final random = Random();
    _generatedOtp = (1000 + random.nextInt(9000)).toString();
    debugPrint('Generated OTP (simulated email): $_generatedOtp');

    // Show OTP in dialog safely
    final currentContext = context;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      showDialog(
        context: currentContext,
        builder: (_) => AlertDialog(
          title: const Text('OTP Sent'),
          content: Text('Your OTP is $_generatedOtp'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(currentContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 540;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _onKeyPressed(String value) {
    for (int i = 0; i < 4; i++) {
      if (_otpDigits[i].isEmpty) {
        setState(() => _otpDigits[i] = value);
        break;
      }
    }
  }

  void _onBackspace() {
    for (int i = 3; i >= 0; i--) {
      if (_otpDigits[i].isNotEmpty) {
        setState(() => _otpDigits[i] = '');
        break;
      }
    }
  }

  String _getOTP() => _otpDigits.join();

  void _verifyOTP() {
    String enteredOtp = _getOTP();

    if (enteredOtp.length != 4) {
      _showSnack('Please enter all 4 digits');
      return;
    }

    if (enteredOtp == _generatedOtp) {
      _showSnack('Email verified successfully!');
      Future.delayed(const Duration(seconds: 1), () {
        _popNavigation();
      });
    } else {
      _showSnack('Invalid OTP. Please try again.');
      _clearOTP();
    }
  }

  void _clearOTP() {
    _otpDigits = ['', '', '', ''];
    setState(() {});
  }

  void _resendOTP() {
    if (!_canResend) return;
    _generateOtp();
    _clearOTP();
    _startTimer();
    _showSnack('OTP resent (simulated)!');
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _popNavigation() {
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _popNavigation,
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'OTP',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Email verification',
                        style:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Enter the verification code we send you on:\nDalehic ****@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // OTP boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 56,
                            height: 56,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade50,
                            ),
                            child: Center(
                              child: Text(
                                _otpDigits[index],
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Resend link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't receive code? ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: _canResend ? _resendOTP : null,
                            child: Text(
                              'Resend',
                              style: TextStyle(
                                color: _canResend
                                    ? const Color(0xFFFF8C00)
                                    : Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Timer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.schedule,
                              color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(_secondsRemaining),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8C00),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _verifyOTP,
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Keypad
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _keypadRow(['1', '2', '3'], ['ABC', 'DEF']),
                  _keypadRow(['4', '5', '6'], ['GHI', 'JKL', 'MNO']),
                  _keypadRow(['7', '8', '9'], ['PQRS', 'TUV', 'WXYZ']),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('0'),
                      _buildBackspaceButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _keypadRow(List<String> numbers, [List<String>? letters]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          List.generate(numbers.length, (i) => _buildKeypadButton(numbers[i], letters?[i])),
    );
  }

  Widget _buildKeypadButton(String number, [String? letters]) {
    return GestureDetector(
      onTap: () => _onKeyPressed(number),
      child: Container(
        width: 80,
        height: 50,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(number, style: const TextStyle(fontSize: 20)),
            if (letters != null)
              Text(letters,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.backspace_outlined),
      ),
    );
  }
}
