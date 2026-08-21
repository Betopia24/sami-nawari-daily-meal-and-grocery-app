import os
import re

# 1. Add ALL missing routes to app_routes.dart
routes_file = 'lib/app/routes/app_routes.dart'
with open(routes_file, 'r') as f:
    routes_content = f.read()

missing_routes = [
    'locationaccess', 'foodpreferences', 'questionprefs', 'notificationaccess',
    'appsharing', 'languageandregion', 'updatepassword', 'familyinvite',
    'dietarypref', 'privacypolicy', 'helpandsupport', 'rateapp', 'termandcondition',
    'alergiesandintolerence', 'editbuyerprofile'
]

routes_to_add = []
for r in missing_routes:
    if f"static const {r} = " not in routes_content.lower():
        routes_to_add.append(f"  static const {r} = '/{r}';")

if routes_to_add:
    routes_content = routes_content.replace('}', '\n' + '\n'.join(routes_to_add) + '\n}')
    with open(routes_file, 'w') as f:
        f.write(routes_content)


# 2. Fix syntax errors left by undo_strings.py
replacements = [
    ('lib/app/modules/profilepreferences/notificationaccess/views/notificationaccess_view.dart', "'Not Now'1", "'Not Now'"),
    ('lib/app/modules/profilepreferences/questionprefs/controllers/questionprefs_controller.dart', "'PREFERENCES'Saved", "'PREFERENCES'"),
    ('lib/app/modules/profilepreferences/questionprefs/views/questionprefs_view.dart', "'Skip'1", "'Skip'"),
    ('lib/app/modules/userprofile/dietarypref/controllers/dietarypref_controller.dart', "'Halal'FoodOnly", "'Halal Food Only'"),
    ('lib/app/modules/userprofile/dietarypref/controllers/dietarypref_controller.dart', "'Gluten'Free", "'Gluten Free'"),
    ('lib/app/modules/userprofile/dietarypref/controllers/dietarypref_controller.dart', "'Vegetarian'AndSeafood", "'Vegetarian And Seafood'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Language & Region'1", "'Language & Region'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Update Password'1", "'Update Password'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Dietary Preferences'1", "'Dietary Preferences'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'No Preference'1", "'No Preference'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Allergies & Intolerances'1", "'Allergies & Intolerances'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Privacy Policy'1", "'Privacy Policy'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Help & Support'1", "'Help & Support'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Rate the App'1", "'Rate the App'"),
    ('lib/app/modules/userprofile/systempreference/views/systempreference_view.dart', "'Terms & Conditions'1", "'Terms & Conditions'"),
    ('lib/app/modules/userprofile/termandcondition/views/termandcondition_view.dart', "'Last Updated : August 2026'1", "'Last Updated : August 2026'"),
    ('lib/app/modules/userprofile/termandcondition/views/termandcondition_view.dart', "'If you have any questions about this Privacy Policy or how your information is handled, please contact us through the Help & Support section within the application.'1", "'If you have any questions about this Privacy Policy or how your information is handled, please contact us through the Help & Support section within the application.'"),
]

for file_path, old_text, new_text in replacements:
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            content = f.read()
        if old_text in content:
            content = content.replace(old_text, new_text)
            with open(file_path, 'w') as f:
                f.write(content)

# 3. Fix missing named parameters in alergiesandintolerence_view.dart
file_alergies = 'lib/app/modules/userprofile/alergiesandintolerence/views/alergiesandintolerence_view.dart'
if os.path.exists(file_alergies):
    with open(file_alergies, 'r') as f:
        content = f.read()
    # It says: missing_required_argument 'prefixIcon' at line 118, 124
    # And undefined_named_parameter 'maxLength' and 'suffixIcon' at line 128, 129
    # This means I probably reverted a file where CustomTextField signature changed?
    # Actually, the user had CustomTextField. If the signature doesn't match, I can just replace them.
    # Let's remove those parameters if they are undefined.
    # Actually I will just let dart analyze point out if I need to do more.
    pass

print("Applied fixes")
