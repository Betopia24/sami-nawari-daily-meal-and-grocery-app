import os

directory = "assets/icons"
files = os.listdir(directory)

rename_map = {
    '👨‍👩‍👦.png': 'small_family_emoji.png',
    '👨‍👩‍👧‍👦.png': 'large_family_emoji.png',
    '👫.png': 'couple_emoji.png',
    '💰.png': 'money_bag_emoji.png',
    '📆.png': 'calendar_emoji.png',
    '🔥.png': 'fire_emoji.png',
    '🥗.png': 'salad_emoji.png',
    '🥡.png': 'takeout_emoji.png',
    '🧑.png': 'person_emoji.png',
    '🫒.png': 'olive_emoji.png'
}

for old_name, new_name in rename_map.items():
    old_path = os.path.join(directory, old_name)
    new_path = os.path.join(directory, new_name)
    if os.path.exists(old_path):
        os.rename(old_path, new_path)
        print(f"Renamed {old_name} to {new_name}")
    else:
        print(f"File {old_name} not found")
