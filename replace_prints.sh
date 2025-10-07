#!/bin/bash

# Script to replace print statements with logger in Dart files

echo "=== Print to Logger Replacement Script ==="
echo ""

PROCESSED=0
MODIFIED=0
TOTAL_REPLACEMENTS=0

# Function to process a single file
process_file() {
    local file="$1"
    local count_before
    local count_after

    # Count print statements before
    count_before=$(grep -c "print(" "$file" 2>/dev/null || echo "0")

    if [ "$count_before" -eq 0 ]; then
        return
    fi

    echo "Processing: $file ($count_before print statements)"

    # Add import if not exists
    if ! grep -q "app_logger.dart" "$file"; then
        # Count how many directories deep we are from lib/
        depth=$(echo "$file" | sed 's|lib/||' | tr -cd '/' | wc -c)

        if [ "$depth" -eq 0 ]; then
            import_path="import 'utils/app_logger.dart';"
        else
            prefix=$(printf '../%.0s' $(seq 1 $depth))
            import_path="import '${prefix}utils/app_logger.dart';"
        fi

        # Find last import line and add after it
        sed -i "/^import /a\\
$import_path" "$file" 2>/dev/null || {
            # If sed -i doesn't work, try alternative
            temp_file=$(mktemp)
            awk "/^import / { print; if (!found) { print \"$import_path\"; found=1 }; next } 1" "$file" > "$temp_file"
            mv "$temp_file" "$file"
        }
    fi

    # Replace print statements with logger
    # Error patterns
    sed -i "s/print('Error:/logger.e('Error:/g" "$file"
    sed -i 's/print("Error:/logger.e("Error:/g' "$file"
    sed -i "s/print('Failed:/logger.e('Failed:/g" "$file"
    sed -i 's/print("Failed:/logger.e("Failed:/g' "$file"
    sed -i "s/print('Exception:/logger.e('Exception:/g" "$file"
    sed -i 's/print("Exception:/logger.e("Exception:/g' "$file"

    # Warning patterns
    sed -i "s/print('Warning:/logger.w('Warning:/g" "$file"
    sed -i 's/print("Warning:/logger.w("Warning:/g' "$file"
    sed -i "s/print('Warn:/logger.w('Warn:/g" "$file"
    sed -i 's/print("Warn:/logger.w("Warn:/g' "$file"

    # Info patterns
    sed -i "s/print('Initialized:/logger.i('Initialized:/g" "$file"
    sed -i 's/print("Initialized:/logger.i("Initialized:/g' "$file"
    sed -i "s/print('Starting:/logger.i('Starting:/g" "$file"
    sed -i 's/print("Starting:/logger.i("Starting:/g' "$file"

    # Debug (catch-all for remaining print)
    sed -i "s/print(/logger.d(/g" "$file"

    # Count print statements after
    count_after=$(grep -c "print(" "$file" 2>/dev/null || echo "0")

    local replaced=$((count_before - count_after))

    if [ "$replaced" -gt 0 ]; then
        echo "  ✓ Replaced $replaced statements"
        ((MODIFIED++))
        ((TOTAL_REPLACEMENTS+=replaced))
    fi

    ((PROCESSED++))
}

# Process all Dart files in lib/
echo "Scanning lib/ directory..."
echo ""

while IFS= read -r -d '' file; do
    process_file "$file"
done < <(find lib -name "*.dart" -type f -print0)

# Summary
echo ""
echo "=== SUMMARY ==="
echo "Files processed: $PROCESSED"
echo "Files modified: $MODIFIED"
echo "Total replacements: $TOTAL_REPLACEMENTS"
echo ""
echo "✓ Done!"
