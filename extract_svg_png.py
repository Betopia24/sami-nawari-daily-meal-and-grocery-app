import re
import base64
import os

svg_files = [
    'assets/icons/availablebalance_icon.svg',
    'assets/icons/totalearning_icon.svg',
    'assets/icons/withdraw_icon.svg'
]

for svg_file in svg_files:
    if not os.path.exists(svg_file):
        continue
    with open(svg_file, 'r') as f:
        content = f.read()
    
    match = re.search(r'data:image/png;base64,([^"]+)', content)
    if match:
        png_base64 = match.group(1)
        png_data = base64.b64decode(png_base64)
        png_file = svg_file.replace('.svg', '.png')
        with open(png_file, 'wb') as f:
            f.write(png_data)
        print(f"Extracted {png_file}")
    else:
        print(f"No base64 png found in {svg_file}")
