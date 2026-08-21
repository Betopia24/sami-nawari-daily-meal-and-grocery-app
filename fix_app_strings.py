import os
import re

backup_path = '/tmp/backup_grocery/lib/core/utils/app_strings.dart'
dest_path = 'lib/core/utils/app_strings.dart'

with open(backup_path, 'r') as f:
    lines = f.readlines()

new_lines = []
i = 0
while i < len(lines):
    line = lines[i]
    # If this is the start of the broken strings (from my previous script), we stop adding
    # Wait, the broken strings had things like:
    # static const String today = 'Today\';
    if " = '" in line and "\\';" in line and not "\\\\';" in line:
        i += 1
        continue
    
    # Fix the syntax errors in onboarding strings
    if "static const String onboardingTitle1 = 'Plan your meals smarter';" in line:
        new_lines.append("  static const String onboardingTitle1 = 'Plan your meals smarter. Create grocery lists effortlessly and stay on top of your weekly meals — all in one place.';\n")
        i += 2 # skip next line
        continue
    
    if "static const String onboardingTitle2 = 'Discover recipes you can make now.';" in line:
        new_lines.append("  static const String onboardingTitle2 = 'Discover recipes you can make now. Find recipes based on ingredients you already have. Reduce food waste and save time every week.';\n")
        i += 2
        continue
        
    if "static const String onboardingLabel3 = 'Local Discovery';" in line:
        new_lines.append(line)
        new_lines.append("  static const String onboardingTitle3 = 'Explore local food and share with family. Find homemade food nearby, share grocery lists with your family, and get personalized recommendations.';\n")
        i += 3
        continue
        
    if "static const String welcomeTitle = 'Your complete\\nkitchen companion.';" in line:
        new_lines.append("  static const String welcomeTitle = 'Your complete\\nkitchen companion.';\n")
        new_lines.append("  static const String welcomeSubtitle = 'Plan meals, discover recipes, manage groceries, and find homemade food near you.';\n")
        i += 2
        continue
        
    if "static const String forgotPasswordTitle = 'Forgot Password?';" in line:
        new_lines.append("  static const String forgotPasswordTitle = 'Forgot Password?';\n")
        new_lines.append("  static const String forgotPasswordSubtitle = 'No worries! Enter your email and we\\'ll send you a reset link.';\n")
        i += 2
        continue

    # Only include lines up to line 125, the rest are broken auto-generated strings
    if i > 125 and "class AppStrings" not in line and "}" not in line:
        # Just grab the share strings explicitly
        pass
    else:
        new_lines.append(line)
    
    i += 1

# Make sure closing brace is there
if "}" not in "".join(new_lines[-5:]):
    new_lines.append("}\n")

with open(dest_path, 'w') as f:
    f.writelines(new_lines)

print("Fixed app_strings.dart")
