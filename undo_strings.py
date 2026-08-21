import os
import re

strings_file_path = 'lib/core/utils/app_strings.dart'

with open(strings_file_path, 'r') as f:
    strings_content = f.read()

# Extract mappings
pattern = r"static const String (\w+) = '(.*?)';"
mappings = re.findall(pattern, strings_content)

mapping_dict = {var_name: text for var_name, text in mappings}

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content
    
    # We will replace AppStrings.varName with 'text'
    for var_name, text in mapping_dict.items():
        # First fix the broken ones where s') was left behind
        # Example: AppStrings.childrens s') -> 'text\'s')
        broken_pattern = f"AppStrings.{var_name}\\s+s'\\)"
        content = re.sub(broken_pattern, f"'{text}\\'s')", content)
        
        # Also there are cases where t') was left behind like don't
        broken_pattern_t = f"AppStrings.{var_name}\\s+t'\\)"
        content = re.sub(broken_pattern_t, f"'{text}\\'t')", content)
        
        # Normal replacement for functions like Text(AppStrings.varName -> Text('text'
        # We know we replaced Text('text' with Text(AppStrings.varName
        # But wait, what about the closing quote?
        # The original script replaced Text('text' which didn't include the closing quote!
        # Ah! `Text(AppStrings.varName` is what the script returned.
        # But wait, the original text had a closing quote that WAS NOT matched!
        # Because the regex was `r"Text\(\s*'([^'\$]+)'"` and it didn't match the closing quote!
        # Wait, `([^'\$]+)'` DOES match the closing quote!
        # So `Text('text')` was fully matched, and replaced with `Text(AppStrings.varName`.
        # Which means the closing `)` is left behind! So it became `Text(AppStrings.varName)`!
        
        # So replacing `AppStrings.varName` with `'text'` will perfectly restore `Text('text')`!
        content = content.replace(f"AppStrings.{var_name}", f"'{text}'")

    if content != original:
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Reverted strings in {filepath}")

for root, dirs, files in os.walk('lib/app/modules'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

# We should also clean up app_strings.dart
# Keep everything before "  // Share App Strings" or similar
lines = strings_content.split('\n')
clean_lines = []
for line in lines:
    if 'static const String' in line and not line.endswith("';"):
        pass # Skip broken lines
    else:
        clean_lines.append(line)

with open(strings_file_path, 'w') as f:
    f.write('\n'.join(clean_lines))

print("Reverted files")
