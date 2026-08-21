import os
import re
import base64

svg_dir = '/Users/jamil/Office_Projects/daily_meal_and_grocery_app/assets/icons'

converted = []
for filename in os.listdir(svg_dir):
    if filename.endswith('.svg'):
        path = os.path.join(svg_dir, filename)
        with open(path, 'r') as f:
            content = f.read()
        
        match = re.search(r'data:image/png;base64,([^"]+)', content)
        if match:
            b64_data = match.group(1)
            png_data = base64.b64decode(b64_data)
            png_filename = filename.replace('.svg', '.png')
            png_path = os.path.join(svg_dir, png_filename)
            with open(png_path, 'wb') as out_f:
                out_f.write(png_data)
            converted.append(png_filename)

print("CONVERTED: " + ",".join(converted))
