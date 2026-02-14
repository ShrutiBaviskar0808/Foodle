-- Add missing columns to existing members table
ALTER TABLE `members` 
ADD COLUMN `photo_path` VARCHAR(255) DEFAULT NULL AFTER `display_name`,
ADD COLUMN `nickname` VARCHAR(100) DEFAULT NULL AFTER `photo_path`,
ADD COLUMN `dob` DATE DEFAULT NULL AFTER `nickname`,
ADD COLUMN `age` INT(3) DEFAULT NULL AFTER `dob`;

-- Create allergies table if it doesn't exist
CREATE TABLE IF NOT EXISTS `allergies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `member_id` INT(11) NOT NULL,
  `allergy_name` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `member_id` (`member_id`),
  FOREIGN KEY (`member_id`) REFERENCES `members`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
