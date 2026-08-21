import os
import shutil

files_to_backup = [
    'lib/core/utils/app_assets.dart',
    'lib/core/utils/app_colors.dart',
    'lib/core/utils/app_strings.dart',
    'lib/app/modules/userprofile/appsharing/views/appsharing_view.dart',
    'lib/app/modules/userprofile/appsharing/controllers/appsharing_controller.dart',
    'lib/app/modules/dashboard/views/dashboard_view.dart',
    'lib/app/modules/foodgrid/recommendedfoodgrid/views/recommendedfood_view.dart'
]

# Backup
os.makedirs('/tmp/backup_grocery', exist_ok=True)
for f in files_to_backup:
    if os.path.exists(f):
        # Create dir structure in tmp
        dest = os.path.join('/tmp/backup_grocery', f)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copy2(f, dest)

# Git restore
os.system('git restore .')

# Restore
for f in files_to_backup:
    src = os.path.join('/tmp/backup_grocery', f)
    if os.path.exists(src):
        shutil.copy2(src, f)

print("Restored git state and kept manual changes!")
