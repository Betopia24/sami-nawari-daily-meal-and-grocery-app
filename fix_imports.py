import os
import re

directories = ['lib/app/modules', 'lib/app/widgets']
import_statement = "import 'package:daily_meal_and_grocery_app/core/utils/app_colors.dart';\n"
import_statement_2 = "import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';\n"

for d in directories:
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r') as f:
                    content = f.read()
                
                modified = False
                
                # Check AppColors
                if 'AppColors' in content:
                    if 'app_colors.dart' not in content:
                        # Find last import
                        lines = content.split('\n')
                        last_import = 0
                        for i, line in enumerate(lines):
                            if line.startswith('import '):
                                last_import = i
                        
                        lines.insert(last_import + 1, import_statement.strip())
                        content = '\n'.join(lines)
                        modified = True
                        
                # Check AppStrings
                if 'AppStrings' in content:
                    if 'app_strings.dart' not in content:
                        lines = content.split('\n')
                        last_import = 0
                        for i, line in enumerate(lines):
                            if line.startswith('import '):
                                last_import = i
                        
                        lines.insert(last_import + 1, import_statement_2.strip())
                        content = '\n'.join(lines)
                        modified = True

                if modified:
                    with open(filepath, 'w') as f:
                        f.write(content)
                    print(f"Fixed imports in {filepath}")

# Also fix the routing errors
def fix_routes():
    routes_file = 'lib/app/routes/app_routes.dart'
    pages_file = 'lib/app/routes/app_pages.dart'
    
    with open(routes_file, 'r') as f:
        routes_content = f.read()
        
    routes_to_add = []
    if 'locationaccess' not in routes_content.lower():
        routes_to_add.append('  static const locationaccess = \'/locationaccess\';')
    if 'foodpreferences' not in routes_content.lower():
        routes_to_add.append('  static const foodpreferences = \'/foodpreferences\';')
    if 'questionprefs' not in routes_content.lower():
        routes_to_add.append('  static const questionprefs = \'/questionprefs\';')
    if 'notificationaccess' not in routes_content.lower():
        routes_to_add.append('  static const notificationaccess = \'/notificationaccess\';')
        
    if routes_to_add:
        routes_content = routes_content.replace('}', '\n' + '\n'.join(routes_to_add) + '\n}')
        with open(routes_file, 'w') as f:
            f.write(routes_content)
        print("Fixed routes")
        
    # We won't try to automatically add to app_pages to avoid syntax issues.
    # Instead, we'll see if dart analyze complains.
    
fix_routes()
