import 'package:mysql1/mysql1.dart';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DatabaseService {
  static MySqlConnection? _connection;

  static Future<MySqlConnection> _getConnection() async {
    try {
      if (_connection == null) {
        final settings = ConnectionSettings(
          host: '127.0.0.1',
          port: 3306,
          user: 'root',
          password: '',
          db: 'foodle',
          timeout: Duration(seconds: 10),
        );
        _connection = await MySqlConnection.connect(settings);
      }
      return _connection!;
    } catch (e) {
      throw Exception('Database connection failed: $e');
    }
  }

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<Map<String, dynamic>> signup(String name, String email, String password) async {
    try {
      final conn = await _getConnection();
      
      // Check if email exists
      var results = await conn.query('SELECT id FROM users WHERE email = ?', [email]);
      if (results.isNotEmpty) {
        return {'success': false, 'message': 'Email already exists'};
      }

      // Generate OTP
      final otp = (1000 + Random().nextInt(9000)).toString();
      final hashedPassword = _hashPassword(password);

      // Insert user
      var result = await conn.query(
        'INSERT INTO users (name, email, password, email_verify) VALUES (?, ?, ?, 0)',
        [name, email, hashedPassword]
      );
      final userId = result.insertId;

      // Store OTP
      await conn.query(
        'INSERT INTO verify_otp (user_id, email, otp) VALUES (?, ?, ?)',
        [userId, email, otp]
      );

      return {'success': true, 'message': 'OTP: $otp', 'user_id': userId};
    } catch (e) {
      if (e.toString().contains('Connection refused')) {
        return {'success': false, 'message': 'Database connection failed. Please start XAMPP MySQL service.'};
      }
      return {'success': false, 'message': 'Registration failed: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(int userId, String otp) async {
    try {
      final conn = await _getConnection();
      
      // Verify OTP
      var results = await conn.query(
        'SELECT * FROM verify_otp WHERE user_id = ? AND otp = ? AND created_at > DATE_SUB(NOW(), INTERVAL 10 MINUTE)',
        [userId, otp]
      );

      if (results.isNotEmpty) {
        // Update user email_verify status
        await conn.query('UPDATE users SET email_verify = 1 WHERE id = ?', [userId]);
        
        // Delete OTP record
        await conn.query('DELETE FROM verify_otp WHERE user_id = ?', [userId]);
        
        return {'success': true, 'message': 'Email verified successfully'};
      } else {
        return {'success': false, 'message': 'Invalid or expired OTP'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Verification failed: $e'};
    }
  }

  static Future<void> close() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }
}