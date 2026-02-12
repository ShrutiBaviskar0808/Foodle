-- Create database
CREATE DATABASE IF NOT EXISTS u196786599_foodle;
USE u196786599_foodle;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Verify OTP table
CREATE TABLE IF NOT EXISTS verify_otp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    otp VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Members table
CREATE TABLE IF NOT EXISTS members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_user_id INT NOT NULL,
    linked_user_id INT,
    display_name VARCHAR(255) NOT NULL,
    relation VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Foods table
CREATE TABLE IF NOT EXISTS foods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    food_name VARCHAR(255) NOT NULL,
    preference_type VARCHAR(50) DEFAULT 'like',
    mood_tag VARCHAR(100),
    photo_path VARCHAR(500),
    notes TEXT,
    visibility VARCHAR(50) DEFAULT 'private',
    created_by_user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Allergies table
CREATE TABLE IF NOT EXISTS allergies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    allergy_name VARCHAR(255) NOT NULL,
    severity VARCHAR(50) DEFAULT 'mild',
    notes TEXT,
    visibility VARCHAR(50) DEFAULT 'private',
    created_by_user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Member settings table
CREATE TABLE IF NOT EXISTS member_settings (
    member_id INT PRIMARY KEY,
    allow_shared_view TINYINT(1) DEFAULT 0,
    show_allergy_warning TINYINT(1) DEFAULT 1
);
