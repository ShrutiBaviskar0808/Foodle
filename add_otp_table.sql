-- Add verify_otp table to existing foodle database
USE foodle;

CREATE TABLE verify_otp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    otp VARCHAR(4) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Add email_verify column to users table if it doesn't exist
ALTER TABLE users ADD COLUMN email_verify TINYINT(1) DEFAULT 0;