-- Create members table for family and friends
CREATE TABLE IF NOT EXISTS members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    nickname VARCHAR(100),
    dob DATE,
    age INT,
    relation VARCHAR(50) NOT NULL,
    food_name VARCHAR(200),
    allergies TEXT,
    image_path TEXT,
    email VARCHAR(255),
    phone VARCHAR(20),
    member_user_id INT NULL,
    added_by_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (member_user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (added_by_user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create member_notifications table
CREATE TABLE IF NOT EXISTS member_notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    user_id INT NOT NULL,
    added_by_user_id INT NOT NULL,
    added_by_name VARCHAR(100) NOT NULL,
    relation VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (added_by_user_id) REFERENCES users(id) ON DELETE CASCADE
);
