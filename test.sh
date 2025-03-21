#!/bin/bash

gacp() {
    if [ "$#" -lt 3 ]; then
        echo "Usage: gacp <files...> <commit_message> <branch>"
        echo "Example: gacp file1.txt file2.js 'update files' main"
        return 1
    fi
    
    args=("$@")
    num_args=${#args[@]}
    
    branch="${args[$num_args-1]}"
    commit_msg="${args[$num_args-2]}"
    files=("${args[@]:0:$num_args-2}")
    
    for file in "${files[@]}"; do
        if [ ! -e "$file" ]; then
            echo "Warning: File '$file' does not exist"
            continue
        fi
        git add "$file"
    done
    
    git commit -m "$commit_msg"
    git push origin "$branch"
}

echo "$(gacp .github/workflows .github/try.yaml testing check-rel)"


