@echo off
echo Copying updated PHP files to htdocs...

copy /Y db_config.php htdocs\
copy /Y login.php htdocs\
copy /Y signup.php htdocs\
copy /Y verify_otp.php htdocs\
copy /Y add_member.php htdocs\
copy /Y add_food.php htdocs\
copy /Y add_allergy.php htdocs\
copy /Y get_members.php htdocs\
copy /Y get_foods.php htdocs\
copy /Y get_allergies.php htdocs\
copy /Y update_member_settings.php htdocs\

echo Done! All files copied to htdocs folder.
pause
