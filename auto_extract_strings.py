import os
import re

strings_file_path = 'lib/core/utils/app_strings.dart'

with open(strings_file_path, 'r') as f:
    strings_content = f.read()

# Remove the closing brace of AppStrings
strings_content = strings_content.rsplit('}', 1)[0]

generated_strings = {}

def get_var_name(text):
    # Remove non-alphanumeric chars
    clean_text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
    words = clean_text.split()
    if not words:
        return None
    # Take first 4 words
    words = words[:4]
    var_name = words[0].lower() + ''.join(w.capitalize() for w in words[1:])
    # Ensure it's not a keyword and is valid
    if var_name in ['const', 'final', 'var', 'class', 'import', 'void', 'null', 'true', 'false']:
        var_name += 'Str'
    
    # ensure uniqueness
    base_name = var_name
    counter = 1
    while var_name in generated_strings.values() or f"static const String {var_name}" in strings_content:
        var_name = f"{base_name}{counter}"
        counter += 1
    return var_name

def process_file(filepath):
    global strings_content
    with open(filepath, 'r') as f:
        content = f.read()
    
    original = content
    
    # Find Text('something') or Text("something")
    # But only if it doesn't contain $ (string interpolation)
    
    # We will look for: Text( '...' )
    pattern = r"Text\(\s*'([^'\$]+)'"
    
    def replacer(match):
        global strings_content
        text_val = match.group(1)
        if text_val.strip() == '':
            return match.group(0) # Skip empty strings
        
        var_name = get_var_name(text_val)
        if not var_name:
            return match.group(0)
            
        generated_strings[text_val] = var_name
        strings_content += f"  static const String {var_name} = '{text_val}';\n"
        
        return f"Text(AppStrings.{var_name}"
        
    content = re.sub(pattern, replacer, content)
    
    # We should also handle _buildParagraph('...') and _buildSectionTitle('...') and _buildFaqItem('...', '...') etc.
    custom_patterns = [
        r"_buildParagraph\(\s*'([^'\$]+)'",
        r"_buildSectionTitle\(\s*'([^'\$]+)'",
        r"_buildSubSectionTitle\(\s*'([^'\$]+)'",
    ]
    for cp in custom_patterns:
        def custom_replacer(match):
            global strings_content
            text_val = match.group(1)
            if text_val.strip() == '': return match.group(0)
            var_name = get_var_name(text_val)
            if not var_name: return match.group(0)
            generated_strings[text_val] = var_name
            strings_content += f"  static const String {var_name} = '{text_val}';\n"
            # Return original function call with AppStrings.var_name
            func_name = match.group(0).split('(')[0]
            return f"{func_name}(AppStrings.{var_name}"
        content = re.sub(cp, custom_replacer, content)

    # Bullet lists: _buildBulletList(['a', 'b'])
    # This is harder to regex safely. I will skip lists for now or handle them manually.
    
    # Handle ProfileMenuTile(title: '...',
    pattern_tile = r"title:\s*'([^'\$]+)'"
    def tile_replacer(match):
        global strings_content
        text_val = match.group(1)
        if text_val.strip() == '': return match.group(0)
        var_name = get_var_name(text_val)
        if not var_name: return match.group(0)
        generated_strings[text_val] = var_name
        strings_content += f"  static const String {var_name} = '{text_val}';\n"
        return f"title: AppStrings.{var_name}"
    content = re.sub(pattern_tile, tile_replacer, content)

    if content != original:
        # Add import if not present
        if 'AppStrings' in content and 'app_strings.dart' not in content:
            # We will just rely on Dart Analyzer or add a basic import.
            # Usually it's deep so relative import is annoying.
            # Let's use absolute import
            abs_import = "import 'package:daily_meal_and_grocery_app/core/utils/app_strings.dart';\n"
            if abs_import not in content:
                content = abs_import + content
        
        with open(filepath, 'w') as f:
            f.write(content)
        print(f"Refactored strings in {filepath}")

for root, dirs, files in os.walk('lib/app/modules'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

strings_content += "}\n"
with open(strings_file_path, 'w') as f:
    f.write(strings_content)

print("Updated app_strings.dart")
