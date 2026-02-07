-- Members table matches your existing structure
-- When a new user registers, system will check if their name matches any member's display_name
-- and link them by setting linked_user_id

-- Add this to your existing members table if columns don't exist:
ALTER TABLE members ADD COLUMN IF NOT EXISTS linked_user_id INT NULL;
ALTER TABLE members ADD COLUMN IF NOT EXISTS display_name VARCHAR(100) NOT NULL;
ALTER TABLE members ADD COLUMN IF NOT EXISTS relation VARCHAR(50) NOT NULL;
ALTER TABLE members ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Add foreign key if not exists
ALTER TABLE members ADD CONSTRAINT fk_linked_user 
    FOREIGN KEY (linked_user_id) REFERENCES users(id) ON DELETE SET NULL;
