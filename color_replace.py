import os
import re

color_map = {
    'const Color(0xFFFBFBFB)': 'AppColors.backgroundSecondary',
    'Color(0xFFFBFBFB)': 'AppColors.backgroundSecondary',
    'const Color(0xFFF9F9F9)': 'AppColors.backgroundTertiary',
    'Color(0xFFF9F9F9)': 'AppColors.backgroundTertiary',
    'const Color(0xFFE8F5EE)': 'AppColors.backgroundLightGreen',
    'Color(0xFFE8F5EE)': 'AppColors.backgroundLightGreen',
    'const Color(0xFFF0F9F4)': 'AppColors.backgroundLightGreenAlt',
    'Color(0xFFF0F9F4)': 'AppColors.backgroundLightGreenAlt',
    'const Color(0xFFF3F4F6)': 'AppColors.backgroundGrey',
    'Color(0xFFF3F4F6)': 'AppColors.backgroundGrey',
    'const Color(0xFFF3F1ED)': 'AppColors.backgroundToggle',
    'Color(0xFFF3F1ED)': 'AppColors.backgroundToggle',
    'const Color(0xFFFEF3EA)': 'AppColors.backgroundNotification',
    'Color(0xFFFEF3EA)': 'AppColors.backgroundNotification',
    'const Color(0xFFF9F7F4)': 'AppColors.backgroundOffWhite',
    'Color(0xFFF9F7F4)': 'AppColors.backgroundOffWhite',
    'const Color(0xFFD4CFC9)': 'AppColors.backgroundUnselectedPill',
    'Color(0xFFD4CFC9)': 'AppColors.backgroundUnselectedPill',
    'const Color(0xFFF0F0F0)': 'AppColors.divider',
    'Color(0xFFF0F0F0)': 'AppColors.divider',
    'const Color(0xFFE8E4DF)': 'AppColors.borderLight',
    'Color(0xFFE8E4DF)': 'AppColors.borderLight',
    'const Color(0xFFE5E7EB)': 'AppColors.borderGrey',
    'Color(0xFFE5E7EB)': 'AppColors.borderGrey',
    'const Color(0xFF1A1A1A)': 'AppColors.textDark',
    'Color(0xFF1A1A1A)': 'AppColors.textDark',
    'const Color(0xFF388E3C)': 'AppColors.textGreen',
    'Color(0xFF388E3C)': 'AppColors.textGreen',
    'const Color(0xFF9CA3AF)': 'AppColors.iconGrey',
    'Color(0xFF9CA3AF)': 'AppColors.iconGrey',
    'const Color(0xFFE8874A)': 'AppColors.iconOrange',
    'Color(0xFFE8874A)': 'AppColors.iconOrange',
    'const Color(0xFFF4C842)': 'AppColors.glowYellow',
    'Color(0xFFF4C842)': 'AppColors.glowYellow',
    'const Color(0xFF25D366)': 'AppColors.socialWhatsApp',
    'Color(0xFF25D366)': 'AppColors.socialWhatsApp',
    'const Color(0xFF1877F2)': 'AppColors.socialFacebook',
    'Color(0xFF1877F2)': 'AppColors.socialFacebook',
    'const Color(0xFF34C759)': 'AppColors.socialiMessage',
    'Color(0xFF34C759)': 'AppColors.socialiMessage',
    'const Color(0xFFE1306C)': 'AppColors.socialInstagram',
    'Color(0xFFE1306C)': 'AppColors.socialInstagram',
    'const Color(0xFF007AFF)': 'AppColors.socialEmail',
    'Color(0xFF007AFF)': 'AppColors.socialEmail',
    'const Color(0xFF3A8F5C)': 'AppColors.primary',
    'Color(0xFF3A8F5C)': 'AppColors.primary',
    'const Color(0xFFFAF9F6)': 'AppColors.background',
    'Color(0xFFFAF9F6)': 'AppColors.background',
    'const Color(0xFF212121)': 'AppColors.textPrimary',
    'Color(0xFF212121)': 'AppColors.textPrimary',
    'const Color(0xFF7A7570)': 'AppColors.textSecondary',
    'Color(0xFF7A7570)': 'AppColors.textSecondary',
}

import_statement = "import '../../../../core/utils/app_colors.dart';" # This might be wrong path, we will add import dynamically if possible, or just fix analysis errors later. Actually, it's easier to just use `flutter pub run import_sorter` or similar, or just let analyzer fail and fix imports.

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    original = content
    for old, new in color_map.items():
        content = content.replace(old, new)
    
    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Updated {filepath}")

for root, dirs, files in os.walk('lib/app/modules'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
