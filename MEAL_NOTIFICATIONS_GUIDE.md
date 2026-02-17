# Meal Reminder Notifications - User Guide

## Feature Overview

When you plan a meal in the Meal Planner, you'll automatically receive a notification **2 hours before** the scheduled meal time. All times are based on **Indian Standard Time (IST)**.

## How It Works

### 1. Plan a Meal
1. Open the app and go to **Meal Planner** (second tab in bottom navigation)
2. Tap the **+ button** (orange floating button)
3. Fill in the details:
   - **Meal Name**: e.g., "Lunch with Family"
   - **Date**: Select the date
   - **Time**: Select the meal time (e.g., 2:00 PM)
4. Tap **Add**

### 2. Notification Scheduling
- The app automatically schedules a notification for **2 hours before** your meal time
- Example: If meal is at 2:00 PM, notification will appear at 12:00 PM
- You'll see a green success message: "✅ Meal planned! You'll get a reminder 2 hours before."

### 3. Receive Notification
- At the scheduled time (2 hours before meal), you'll get a notification:
  - **Title**: 🍽️ Meal Reminder
  - **Message**: "Your meal '[Meal Name]' is planned in 2 hours!"
- The notification will appear even if the app is closed

### 4. Delete a Meal
- Swipe left on any meal in the list
- The meal and its notification will be deleted

## Important Notes

### Timezone
- All notifications use **Indian Standard Time (IST / Asia/Kolkata)**
- Even if your device is set to a different timezone, notifications will trigger based on IST

### Permissions Required
- **Android**: The app will request notification permission on first launch
- **iOS**: You'll be asked to allow notifications

### Notification Behavior
- Notifications work even when the app is closed
- They appear in your phone's notification tray
- High priority notifications (will show on lock screen)

## Testing the Feature

### Quick Test (Immediate Notification)
1. Go to Meal Planner
2. Add a meal scheduled for **2 hours and 5 minutes from now**
3. Wait 5 minutes
4. You should receive the notification!

### Example Test:
- Current time: 10:00 AM
- Schedule meal for: 12:05 PM
- Notification will appear at: 10:05 AM (in 5 minutes)

## Troubleshooting

### Not Receiving Notifications?

**Check Permissions:**
1. Go to phone Settings → Apps → Foodle
2. Enable "Notifications"
3. Enable "Alarms & reminders" (Android 12+)

**Check Battery Optimization:**
1. Settings → Battery → Battery optimization
2. Find Foodle and set to "Don't optimize"

**Check Do Not Disturb:**
- Make sure Do Not Disturb is off, or Foodle is allowed

### Notification Not Scheduled?

**Check the time:**
- Notification time must be in the future
- If meal is less than 2 hours away, notification won't be scheduled
- Example: If it's 1:30 PM and you schedule meal for 2:00 PM, no notification (only 30 min away)

**Check debug output:**
- Look for these messages in your IDE/Terminal:
  - ✅ Notification service initialized with Indian timezone
  - ✅ Notification scheduled for [Meal Name] at [Time]
  - ⚠️ Reminder time is in the past, skipping notification

## Features

✅ Automatic notification 2 hours before meal
✅ Indian Standard Time (IST) timezone
✅ Works even when app is closed
✅ High priority notifications
✅ Automatic cancellation when meal is deleted
✅ Success/error messages
✅ Debug logging for troubleshooting

## Technical Details

- **Package**: flutter_local_notifications
- **Timezone**: Asia/Kolkata (IST)
- **Notification Channel**: meal_reminders
- **Priority**: High
- **Schedule Mode**: exactAllowWhileIdle (Android)

## Future Enhancements

Possible future features:
- Custom reminder time (1 hour, 30 minutes, etc.)
- Multiple reminders per meal
- Recurring meal plans
- Notification sound customization
- Snooze functionality
