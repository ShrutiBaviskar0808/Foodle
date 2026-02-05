# Email Verification Setup Guide

## 1. Database Setup
1. Start XAMPP (Apache + MySQL)
2. Open phpMyAdmin (http://localhost/phpmyadmin)
3. Import the `database.sql` file or run the SQL commands manually

## 2. PHP Files Setup
1. Copy `signup.php` and `verify_otp.php` to your XAMPP htdocs folder
2. Make sure the files are accessible at:
   - http://localhost/signup.php
   - http://localhost/verify_otp.php

## 3. Email Configuration (Optional)
For actual email sending, configure your server's mail() function or use:
- SMTP services like Gmail, SendGrid, or Mailgun
- PHP libraries like PHPMailer or SwiftMailer

## 4. Testing
1. Start your Flutter app: `flutter run -d chrome`
2. Register with a valid email
3. Check the response for OTP (displayed in message if email fails)
4. Enter OTP to verify and navigate to home page

## Flow:
1. User fills signup form → PHP creates account + generates OTP
2. OTP sent to email (or shown in response for testing)
3. User enters OTP → PHP verifies and activates account
4. Success → Navigate to home page

## Database Schema:
```sql
users table:
- id (primary key)
- name
- email (unique)
- password (hashed)
- otp (6-digit code)
- is_verified (boolean)
- created_at, updated_at
```