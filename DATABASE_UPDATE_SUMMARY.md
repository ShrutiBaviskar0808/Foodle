# Database and Code Updates Summary

## Database Changes

### SQL Script Created: `add_members_columns.sql`
Run this SQL in phpMyAdmin for database `u196786599_foodle`:

```sql
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
```

## Code Changes

### 1. Flutter App - add_member_screen.dart
Updated `_saveMember()` method to send new fields:
- `nickname` - from _nicknameController
- `photo_path` - from _imagePath (selected image path)
- `dob` - from _dobController (date of birth in DD/MM/YYYY format)
- `age` - from _age (calculated age)

### 2. Backend PHP - add_member.php
Updated to accept and insert new fields:
- Added variables: `$nickname`, `$photo_path`, `$dob`, `$age`
- Updated INSERT query to include all new columns

### 3. Backend PHP - update_member.php
Updated to accept and update new fields:
- Added variables: `$nickname`, `$photo_path`, `$dob`, `$age`
- Added update logic for each new field

### 4. Frontend Display - home.dart
Updated to display photos:
- Changed `member['image_path']` to `member['photo_path']` for family members
- Changed `friend['image_path']` to `friend['photo_path']` for friends
- Photos will now display in CircleAvatar on home screen

## Testing Steps

1. Run the SQL script in phpMyAdmin
2. Restart your Flutter app
3. Add a new member with:
   - Photo (from camera or gallery)
   - Nickname
   - Date of birth (age will auto-calculate)
   - Allergies
4. Check database to verify all fields are saved
5. Check home screen to verify photo displays correctly

## Notes

- Date format: DD/MM/YYYY (e.g., 13/02/2026)
- Age is automatically calculated from date of birth
- Photos are stored as local file paths
- Allergies are stored in separate `allergies` table with foreign key to members
