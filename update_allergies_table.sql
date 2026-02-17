-- SQL to update allergies table for custom food storage
USE u196786599_foodle;

-- Add new columns to allergies table for custom food data
ALTER TABLE allergies 
ADD COLUMN IF NOT EXISTS food_name VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS restaurant VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS calories VARCHAR(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS image_path TEXT DEFAULT NULL,
ADD COLUMN IF NOT EXISTS is_custom_food TINYINT(1) DEFAULT 0;

-- Add index for better query performance
ALTER TABLE allergies ADD INDEX idx_member_custom (member_id, is_custom_food);
