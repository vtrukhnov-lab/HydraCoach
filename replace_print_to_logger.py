#!/usr/bin/env python3
"""
Script to replace print statements with logger in all Dart files.
"""

import os
import re
from pathlib import Path

# Define the root directory
ROOT_DIR = Path(__file__).parent / 'lib'

# Track statistics
stats = {
    'files_processed': 0,
    'files_modified': 0,
    'prints_replaced': 0,
    'files_list': []
}

def needs_logger_import(content):
    """Check if file needs logger import."""
    return 'import' in content and "import '../utils/app_logger.dart';" not in content and "import 'utils/app_logger.dart';" not in content

def get_relative_import_path(file_path):
    """Get the correct relative import path for app_logger.dart."""
    parts = file_path.relative_to(ROOT_DIR).parts
    depth = len(parts) - 1
    if depth == 0:
        return "import 'utils/app_logger.dart';"
    else:
        prefix = '../' * depth
        return f"import '{prefix}utils/app_logger.dart';"

def replace_prints(content, file_path):
    """Replace print statements with appropriate logger calls."""
    if 'print(' not in content:
        return content, 0

    count = 0
    lines = content.split('\n')
    new_lines = []

    for line in lines:
        original = line

        # Skip if already using logger
        if 'logger.' in line:
            new_lines.append(line)
            continue

        # Match print statements and determine log level
        if 'print(' in line:
            # Error patterns
            if any(pattern in line.lower() for pattern in ['error', 'exception', 'failed', 'failure', 'could not']):
                line = line.replace('print(', 'logger.e(')
                count += 1
            # Warning patterns
            elif any(pattern in line.lower() for pattern in ['warning', 'warn']):
                line = line.replace('print(', 'logger.w(')
                count += 1
            # Info patterns (for configuration, credentials, startup info)
            elif any(pattern in line.lower() for pattern in ['credentials', 'config', 'initialized', 'starting', 'platform']):
                line = line.replace('print(', 'logger.i(')
                count += 1
            # Default to debug
            else:
                line = line.replace('print(', 'logger.d(')
                count += 1

        new_lines.append(line)

    return '\n'.join(new_lines), count

def add_logger_import(content, file_path):
    """Add logger import after the last import statement."""
    import_path = get_relative_import_path(file_path)

    # Find the last import line
    lines = content.split('\n')
    last_import_idx = -1

    for i, line in enumerate(lines):
        if line.strip().startswith('import '):
            last_import_idx = i

    if last_import_idx >= 0:
        # Insert after last import
        lines.insert(last_import_idx + 1, import_path)
        return '\n'.join(lines)

    # If no imports found, add at the beginning
    return import_path + '\n\n' + content

def process_file(file_path):
    """Process a single Dart file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Replace print statements
        new_content, count = replace_prints(content, file_path)

        if count > 0:
            # Add import if needed
            if needs_logger_import(new_content):
                new_content = add_logger_import(new_content, file_path)

            # Write back
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)

            stats['files_modified'] += 1
            stats['prints_replaced'] += count
            stats['files_list'].append((str(file_path), count))
            print(f"✓ {file_path.relative_to(ROOT_DIR)}: {count} replacements")

        stats['files_processed'] += 1

    except Exception as e:
        print(f"✗ Error processing {file_path}: {e}")

def main():
    """Main function."""
    print("Starting print→logger replacement...")
    print(f"Scanning directory: {ROOT_DIR}")
    print("-" * 60)

    # Find all Dart files
    dart_files = list(ROOT_DIR.rglob('*.dart'))

    for dart_file in sorted(dart_files):
        process_file(dart_file)

    # Print summary
    print("-" * 60)
    print("\n📊 SUMMARY:")
    print(f"Files processed: {stats['files_processed']}")
    print(f"Files modified: {stats['files_modified']}")
    print(f"Total print statements replaced: {stats['prints_replaced']}")

    if stats['files_list']:
        print("\n📝 Modified files:")
        for file_path, count in sorted(stats['files_list'], key=lambda x: -x[1]):
            print(f"  - {file_path}: {count} replacements")

if __name__ == '__main__':
    main()
