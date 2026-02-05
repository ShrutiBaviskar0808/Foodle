-- Insert sample OTP data into verify_otp table
USE foodle;

-- Insert sample OTP records
INSERT INTO verify_otp (user_id, email, otp) VALUES
(1, 'user1@example.com', '1234'),
(2, 'user2@example.com', '5678'),
(3, 'test@example.com', '9999');