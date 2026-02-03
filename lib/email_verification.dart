import 'package:flutter/material.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final List<String> _otpDigits = ['', '', '', ''];
  late int _secondsRemaining = 540; // 9 minutes in seconds
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 540;
    _canResend = false;
    Future.delayed(const Duration(seconds: 1), () {
      if (_secondsRemaining > 0 && mounted) {
        setState(() => _secondsRemaining--);
        _startTimer();
      } else if (_secondsRemaining == 0 && mounted) {
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

  String _getOTP() {
    return _otpDigits.join();
  }

  void _verifyOTP() {
    String otp = _getOTP();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 4 digits')),
      );
      return;
    }

    // Simulate OTP verification (replace with actual API call)
    if (otp == '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified successfully!')),
      );
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
      _clearOTP();
    }
  }

  void _clearOTP() {
    for (int i = 0; i < 4; i++) {
      _otpDigits[i] = '';
    }
    setState(() {});
  }

  void _resendOTP() {
    if (_canResend) {
      // Simulate API call to resend OTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully!')),
      );
      _clearOTP();
      _startTimer();
    }
  }

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
                    onPressed: () => Navigator.pop(context),
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
                      // Title
                      const Text(
                        'Email verification',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      const Text(
                        'Enter the verification code we send you on:\nDalehic ****@gmail.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // OTP Input Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            width: 56,
                            height: 56,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                _otpDigits[index],
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                color: _canResend ? const Color(0xFFFF8C00) : Colors.grey,
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
                          const Icon(Icons.schedule, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(_secondsRemaining),
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Continue Button
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
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Numeric Keypad
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('1'),
                      _buildKeypadButton('2', 'ABC'),
                      _buildKeypadButton('3', 'DEF'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('4', 'GHI'),
                      _buildKeypadButton('5', 'JKL'),
                      _buildKeypadButton('6', 'MNO'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('7', 'PQRS'),
                      _buildKeypadButton('8', 'TUV'),
                      _buildKeypadButton('9', 'WXYZ'),
                    ],
                  ),
                  const SizedBox(height: 12),
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

  Widget _buildKeypadButton(String number, [String? letters]) {
    return GestureDetector(
      onTap: () => _onKeyPressed(number),
      child: Container(
        width: 80,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              if (letters != null)
                Text(
                  letters,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
            ],
          ),
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
        child: Center(
          child: Icon(Icons.backspace_outlined, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
