# Custom Food Database - Testing & Debug Guide

## What I Fixed

1. ✅ Copied PHP files to correct location (`c:\xampp\htdocs\foodle\`)
2. ✅ Added comprehensive debug logging to both PHP and Flutter
3. ✅ Added success/error messages to user

## Testing Steps

### 1. Restart Your App
- Close and restart the Flutter app completely
- This ensures the new code is loaded

### 2. Add a Custom Food
1. Open a member's profile
2. Click the + button to add food
3. Go to "Custom Food" tab
4. Fill in ALL fields:
   - **Food name**: "Test Burger" (required)
   - **Restaurant**: "Test Restaurant"
   - **Calories**: "500"
   - **Upload an image** (optional but recommended)
5. Click "Save"

### 3. Check Debug Output

**In your IDE/Terminal, you should see:**
```
=== CUSTOM FOOD SAVE DEBUG ===
Member ID: [number]
Food Name: Test Burger
Restaurant: Test Restaurant
Calories: 500
Has Image: true/false
Endpoint: https://foodle.thesoftwaretoolkit.com/api/save_custom_food.php
Request Body: {...}
Response Status: 200
Response Body: {...}
✅ Custom food saved successfully to database!
```

**If you see ❌ errors, note the error message!**

### 4. Check Database

1. Open phpMyAdmin: http://localhost/phpmyadmin/
2. Select database: `u196786599_foodle`
3. Click on `allergies` table
4. Look for the newest entry
5. Check these columns:
   - `food_name` - should have "Test Burger"
   - `restaurant` - should have "Test Restaurant"
   - `calories` - should have "500"
   - `image_path` - should have base64 data (if image uploaded)
   - `is_custom_food` - should be `1`

### 5. Check PHP Error Log

If database entry is still NULL, check PHP errors:
- Location: `c:\xampp\apache\logs\error.log`
- Look for lines with "Custom Food Save Request"

## Common Issues & Solutions

### Issue 1: memberId is null
**Symptom:** Debug shows `Member ID: null`
**Solution:** Make sure you're adding custom food from a member's profile, not from the main screen

### Issue 2: PHP file not found (404)
**Symptom:** Response Status: 404
**Solution:** 
```bash
copy c:\xampp\htdocs\project\htdocs\save_custom_food.php c:\xampp\htdocs\foodle\save_custom_food.php
```

### Issue 3: Database columns don't exist
**Symptom:** SQL error in response
**Solution:** Run the SQL script again in phpMyAdmin:
```sql
USE u196786599_foodle;
ALTER TABLE allergies 
ADD COLUMN IF NOT EXISTS food_name VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS restaurant VARCHAR(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS calories VARCHAR(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS image_path TEXT DEFAULT NULL,
ADD COLUMN IF NOT EXISTS is_custom_food TINYINT(1) DEFAULT 0;
```

### Issue 4: Connection timeout
**Symptom:** Exception during save: TimeoutException
**Solution:** 
1. Make sure XAMPP Apache is running
2. Check if you can access: https://foodle.thesoftwaretoolkit.com/api/save_custom_food.php
3. Update IP in `lib/config.dart` if needed

## Success Indicators

✅ You'll see a green success message in the app
✅ Debug log shows "✅ Custom food saved successfully to database!"
✅ Database shows new entry with all fields filled
✅ Custom food appears in dashboard with image, restaurant, and calories

## Next Steps After Testing

Once it works:
1. Test with different foods
2. Test with and without images
3. Test with different calorie values
4. Verify all data displays correctly in dashboard

## Need Help?

Share the debug output from your IDE/Terminal, especially:
- The "=== CUSTOM FOOD SAVE DEBUG ===" section
- Any error messages (❌)
- The Response Body
