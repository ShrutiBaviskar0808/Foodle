# Custom Food Database Fix - Quick Guide

## Problem
Custom foods were showing with:
- No image (just placeholder letters)
- "Custom" as restaurant name  
- "0 Calories"
- No database entries

## Root Cause
The `memberId` was not being passed to the `SelectFoodsScreen`, so data was only saving to local storage (SharedPreferences) instead of the database.

## Solution Applied

### 1. Updated SelectFoodsScreen to accept memberId parameter
**File:** `lib/screens/select_foods_screen.dart`
- Added `memberId` as a constructor parameter
- Removed the `_loadMemberId()` method that was trying to load from SharedPreferences
- Now uses the passed `memberId` directly

### 2. Updated all calls to SelectFoodsScreen
**Files Updated:**
- `lib/screens/user_profile_dashboard.dart` - Now passes `widget.memberData?['id']`
- `lib/screens/all_favorite_foods_screen.dart` - Now passes `widget.memberData?['id']`

## IMPORTANT: Database Setup Required

### You MUST run this SQL in phpMyAdmin first:

```sql
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
```

### Steps:
1. Open http://localhost/phpmyadmin/
2. Select database: `u196786599_foodle`
3. Click "SQL" tab
4. Paste the SQL above
5. Click "Go"

## How It Works Now

1. User opens a member's profile
2. Clicks to add custom food
3. Fills in:
   - Food name (required)
   - Restaurant name (optional)
   - Calories (optional - numeric field)
   - Image (optional - from camera/gallery)
   - Notes (optional)
4. Clicks Save
5. Data is sent to `htdocs/save_custom_food.php`
6. Saved in `allergies` table with `is_custom_food=1`
7. Image is base64 encoded and stored in `image_path` column
8. Custom food appears in dashboard with proper image, restaurant, and calories

## Testing

1. Run the SQL script
2. Restart your app
3. Go to a member's profile
4. Add a custom food with all fields filled
5. Check the dashboard - should show:
   - ✅ Food image (if uploaded)
   - ✅ Restaurant name
   - ✅ Calories count
6. Check database:
   - Go to phpMyAdmin
   - Open `allergies` table
   - Look for entries where `is_custom_food = 1`
   - Should see all your custom food data

## Files Changed
- `lib/screens/select_foods_screen.dart` - Fixed memberId handling
- `lib/screens/user_profile_dashboard.dart` - Pass memberId
- `lib/screens/all_favorite_foods_screen.dart` - Pass memberId

## Pushed to GitHub
Commit: "Fix custom food database integration - pass memberId properly"
