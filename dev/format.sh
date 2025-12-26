#!/usr/bin/env bash
set -euo pipefail

echo "HEHEHREH"

cd "$HOME/dotfiles"

SOFT=false

if [[ -n "${1:-}" && "$1" == "--soft" ]]; then
    echo "Running in soft mode. No formatting will be applied."
    SOFT=true
fi

sh_files=(
    $(find . -type f \( -name "*.sh" \))
    $(find ./commands/bin -type f)
)

fish_files=(
    $(find . -type f \( -name "*.fish" \))
)

has_error=false

function run_format {
    echo "Running '$1'..."

    set +e
    result=$($1)
    exit_code=$?
    set -e

    if [[ $exit_code -ne 0 ]]; then
        echo "Error formatting '$1': $result"
        has_error=true
    fi
}

for file in "${sh_files[@]}"; do
    if [[ -f "$file" ]]; then
        if $SOFT; then
            run_format "shfmt -i 4 -d $file"
        else
            run_format "shfmt -i 4 -w $file"
        fi
    fi
done

for file in "${fish_files[@]}"; do
    if [[ -f "$file" ]]; then
        if $SOFT; then
            run_format "fish_indent -c $file"
        else
            run_format "fish_indent -w $file"
        fi
    fi
done

if $has_error; then
    echo "Some files failed to format."
    exit 1
fi
echo "All files formatted successfully!"
exit 0
