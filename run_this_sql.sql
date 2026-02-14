-- IMPORTANT: Run this in phpMyAdmin SQL tab for database u196786599_foodle

-- First, check if columns already exist, if not add them
ALTER TABLE `members` 
ADD COLUMN IF NOT EXISTS `photo_path` VARCHAR(255) DEFAULT NULL AFTER `display_name`,
ADD COLUMN IF NOT EXISTS `nickname` VARCHAR(100) DEFAULT NULL AFTER `photo_path`,
ADD COLUMN IF NOT EXISTS `dob` DATE DEFAULT NULL AFTER `nickname`,
ADD COLUMN IF NOT EXISTS `age` INT(3) DEFAULT NULL AFTER `dob`;
