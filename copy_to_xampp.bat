@echo off
echo Copying PHP files to XAMPP htdocs...

copy /Y "c:\project\add_food.php" "C:\xampp\htdocs\add_food.php"
copy /Y "c:\project\get_foods.php" "C:\xampp\htdocs\get_foods.php"
copy /Y "c:\project\update_food.php" "C:\xampp\htdocs\update_food.php"
copy /Y "c:\project\delete_food.php" "C:\xampp\htdocs\delete_food.php"
copy /Y "c:\project\verify_otp.php" "C:\xampp\htdocs\verify_otp.php"
copy /Y "c:\project\signup.php" "C:\xampp\htdocs\signup.php"
copy /Y "c:\project\login.php" "C:\xampp\htdocs\login.php"

echo.
echo Files copied successfully!
echo Please restart Apache in XAMPP Control Panel.
pause
