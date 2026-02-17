# Custom Food Feature - Database Update Instructions

## Step 1: Run this SQL in phpMyAdmin

Go to: http://localhost/phpmyadmin/index.php?route=/sql&pos=0&db=u196786599_foodle&table=allergies

Copy and paste the following SQL commands:

```sql
-- Add custom food fields to allergies table
USE u196786599_foodle;

ALTER TABLE allergies 
ADD COLUMN food_name VARCHAR(255) DEFAULT NULL,
ADD COLUMN restaurant VARCHAR(255) DEFAULT NULL,
ADD COLUMN calories VARCHAR(50) DEFAULT NULL,
ADD COLUMN image_path TEXT DEFAULT NULL,
ADD COLUMN is_custom_food TINYINT(1) DEFAULT 0;

-- Add index for better performance
ALTER TABLE allergies ADD INDEX idx_member_custom (member_id, is_custom_food);
```

## Step 2: Copy PHP Files to htdocs

The following files have been created and need to be copied to your htdocs folder:

1. `htdocs/save_custom_food.php` - Saves custom food to database
2. `htdocs/get_custom_foods.php` - Retrieves custom foods from database

## What's Changed

### Database Structure
- **allergies table** now has additional columns:
  - `food_name` - Name of the custom food
  - `restaurant` - Restaurant/source name
  - `calories` - Calorie count
  - `image_path` - Base64 encoded image or file path
  - `is_custom_food` - Flag to identify custom foods (1 = custom, 0 = regular allergy)

### Flutter App Changes
1. **select_foods_screen.dart**:
   - Added "Calories" input field
   - Separated "Notes" field from calories
   - Saves custom food to database when member_id is available
   - Falls back to local storage if database save fails

2. **all_favorite_foods_screen.dart**:
   - Displays custom food images from local storage
   - Shows both network images and local file images

3. **user_dashboard_screen.dart**:
   - Filters out null allergy names to prevent errors

4. **config.dart**:
   - Added `saveCustomFoodEndpoint`
   - Added `getCustomFoodsEndpoint`

## How It Works

1. When user adds custom food in "Custom Food" tab:
   - User enters: name, restaurant, calories (optional), image (optional), notes
   - Data is saved to `allergies` table with `is_custom_food = 1`
   - Image is stored as base64 in `image_path` column
   - Only custom food data is saved, regular food selections don't trigger database save

2. When displaying foods:
   - Custom foods show uploaded images from local storage
   - Regular foods show network images
   - Both display properly in dashboard and food list

## Testing

1. Run the SQL update in phpMyAdmin
2. Add a custom food with all fields filled
3. Check the `allergies` table - you should see a new row with `is_custom_food = 1`
4. Verify the custom food appears in the dashboard with the uploaded image

## Notes

- Regular food selections (from the "Favorite Food" tab) are NOT saved to database
- Only custom foods (from "Custom Food" tab) are saved to database
- The `allergy_name` field will be NULL for custom foods
- Custom foods are identified by `is_custom_food = 1`
