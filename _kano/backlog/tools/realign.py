import os
import json
import re
import argparse
import shutil
from pathlib import Path

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def update_frontmatter_type(content, new_type, original_type=None):
    # Regex to find 'type: ...' in yaml frontmatter
    pattern = r'^type:\s*.*$'
    replacement = f'type: {new_type}'
    content = re.sub(pattern, replacement, content, flags=re.MULTILINE)
    
    # Add original_type if it's different from new_type and not already present
    if original_type and original_type != new_type:
        # Check if original_type already exists
        if not re.search(r'^original_type:\s*', content, re.MULTILINE):
            # Find the end of frontmatter to insert original_type
            lines = content.split('\n')
            insert_index = -1
            for i, line in enumerate(lines):
                if line.strip() == '---' and i > 0:  # Find closing ---
                    insert_index = i
                    break
            
            if insert_index > 0:
                lines.insert(insert_index, f'original_type: {original_type}')
                content = '\n'.join(lines)
    
    return content

def extract_original_type(content):
    """Extract original_type from frontmatter if it exists"""
    match = re.search(r'^original_type:\s*(.*)$', content, re.MULTILINE)
    return match.group(1).strip() if match else None

def get_best_type_mapping(source_type, target_profile_types, source_profile_name, target_profile_name):
    """Get the best type mapping between profiles with fallback logic"""
    
    # Direct mapping if exists
    if source_type in target_profile_types:
        return source_type, False
    
    # Define cross-profile mapping rules
    azure_to_jira = {
        "Feature": "Epic",
        "UserStory": "Story"
    }
    
    jira_to_azure = {
        "Story": "UserStory",
        "SubTask": "Task"  # Map SubTask to Task as closest match
    }
    
    # Apply profile-specific mappings
    if "azure" in source_profile_name.lower() and "jira" in target_profile_name.lower():
        if source_type in azure_to_jira and azure_to_jira[source_type] in target_profile_types:
            return azure_to_jira[source_type], True
    elif "jira" in source_profile_name.lower() and "azure" in target_profile_name.lower():
        if source_type in jira_to_azure and jira_to_azure[source_type] in target_profile_types:
            return jira_to_azure[source_type], True
    
    # Fallback to closest match based on hierarchy
    hierarchy_order = ["Epic", "Feature", "UserStory", "Story", "Task", "Bug", "SubTask"]
    
    # Find the closest type in the target profile
    source_index = hierarchy_order.index(source_type) if source_type in hierarchy_order else -1
    
    best_match = None
    min_distance = float('inf')
    
    for target_type in target_profile_types:
        if target_type in hierarchy_order:
            target_index = hierarchy_order.index(target_type)
            distance = abs(source_index - target_index)
            if distance < min_distance:
                min_distance = distance
                best_match = target_type
    
    # If no good match found, default to Task or first available type
    if not best_match:
        if "Task" in target_profile_types:
            best_match = "Task"
        else:
            best_match = list(target_profile_types)[0]
    
    return best_match, True

def realign_product(repo_root, product_name):
    product_path = Path(repo_root) / "_kano/backlog/products" / product_name
    config_path = product_path / "_config/config.json"
    
    if not config_path.exists():
        print(f"Error: Config not found for {product_name}")
        return

    config = load_json(config_path)
    process_info = config.get("process", {})
    profile_path_rel = process_info.get("path")
    
    if not profile_path_rel:
        # Check profile ID if path is null
        profile_id = process_info.get("profile")
        if profile_id == "builtin/azure-boards-agile":
            profile_path_rel = "skills/kano-agent-backlog-skill/references/processes/azure-boards-agile.json"
        elif profile_id == "builtin/jira-default":
            profile_path_rel = "skills/kano-agent-backlog-skill/references/processes/jira-default.json"
        else:
            print(f"Error: No process profile path or known ID for {product_name}")
            return

    profile_path = Path(repo_root) / profile_path_rel
    if not profile_path.exists():
        print(f"Error: Profile file not found at {profile_path}")
        return

    profile = load_json(profile_path)
    types_config = profile.get("work_item_types", [])
    
    type_to_slug = {item['type']: item['slug'] for item in types_config}
    slug_to_type = {item['slug']: item['type'] for item in types_config}
    target_profile_types = set(type_to_slug.keys())
    
    print(f"Realigning {product_name} using profile: {profile['name']}")
    print(f"Available types: {', '.join(sorted(target_profile_types))}")
    
    items_root = product_path / "items"
    if not items_root.exists():
        print(f"No items found in {items_root}")
        return

    # To handle moving files, we first collect all files
    all_files = list(items_root.glob("**/*.md"))
    
    for file_path in all_files:
        if file_path.name.endswith(".index.md"):
            continue # Skip index files, they might be regenerated or handled separately
            
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Basic check if it's a backlog item
        if not content.startswith("---"):
            continue
            
        # Extract current type and check for original_type
        type_match = re.search(r'^type:\s*(.*)$', content, re.MULTILINE)
        if not type_match:
            continue
            
        current_type = type_match.group(1).strip()
        original_type = extract_original_type(content)
        
        # Determine target type using improved mapping logic
        target_type, needs_original_preservation = get_best_type_mapping(
            current_type, target_profile_types, "current", profile['name']
        )
        
        # If we have an original_type, try to restore it if possible
        if original_type and original_type in target_profile_types:
            target_type = original_type
            needs_original_preservation = False
            print(f"Restoring original type {original_type} for {file_path.name}")
        
        if target_type not in type_to_slug:
            print(f"Warning: Cannot map type '{current_type}' in {file_path.name}, skipping.")
            continue
            
        target_slug = type_to_slug[target_type]
        
        # Use singular form for folder names
        target_folder_name = target_slug
        
        # Determine target path (keeping the same shard/folder if possible, but move to correct type)
        # items/<old_slug>/<shard>/<file> -> items/<new_slug>/<shard>/<file>
        
        relative_to_items = file_path.relative_to(items_root)
        parts = list(relative_to_items.parts)
        
        current_folder = parts[0]
        
        if current_folder != target_folder_name or current_type != target_type:
            print(f"Moving {file_path.name}: {current_type} ({current_folder}) -> {target_type} ({target_folder_name})")
            if needs_original_preservation:
                print(f"  Preserving original type: {current_type}")
            
            # Update type in content if changed
            if current_type != target_type:
                preserve_original = needs_original_preservation and not original_type
                new_content = update_frontmatter_type(
                    content, target_type, 
                    current_type if preserve_original else None
                )
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
            
            # Calculate new path
            parts[0] = target_folder_name
            new_file_path = items_root.joinpath(*parts)
            
            # Ensure target directory exists
            new_file_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Move file
            if file_path != new_file_path:
                try:
                    shutil.move(str(file_path), str(new_file_path))
                    print(f"  Moved: {file_path.name} -> {new_file_path.relative_to(items_root)}")
                except Exception as e:
                    print(f"  Error moving {file_path.name}: {e}")

    # Cleanup empty directories
    try:
        for root, dirs, files in os.walk(items_root, topdown=False):
            for name in dirs:
                dir_path = Path(root) / name
                try:
                    if dir_path.exists() and not any(dir_path.iterdir()):
                        print(f"Removing empty directory: {dir_path.relative_to(items_root)}")
                        dir_path.rmdir()
                except OSError:
                    # Directory not empty or other OS error, skip
                    pass
    except Exception as e:
        print(f"Warning: Error during directory cleanup: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Realign backlog folders based on process profile slugs.")
    parser.add_argument("--product", help="Target product name (optional, defaults to all)")
    args = parser.parse_args()
    
    repo_root = os.getcwd() # Assumes running from root
    
    if args.product:
        realign_product(repo_root, args.product)
    else:
        # Auto-detect products
        products_dir = Path(repo_root) / "_kano/backlog/products"
        for p in products_dir.iterdir():
            if p.is_dir():
                realign_product(repo_root, p.name)
