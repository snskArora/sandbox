#!/bin/bash

increment_version() {
  local version=${1#v}
  local part=${2:-rc}

  # Parse version with or without RC
  if [[ $version =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-rc\.([0-9]+))?$ ]]; then
    local major="${BASH_REMATCH[1]}"
    local minor="${BASH_REMATCH[2]}"
    local patch="${BASH_REMATCH[3]}"
    local has_rc="${BASH_REMATCH[4]}"
    local rc_num="${BASH_REMATCH[5]:-0}"
    
    case "$part" in
      major)
        echo "$((major+1)).0.0"
        ;;
      minor)
        echo "$major.$((minor+1)).0"
        ;;
      patch)
        echo "$major.$minor.$((patch+1))"
        ;;
      rc)
        # If already has RC, increment RC number
        if [[ -n "$has_rc" ]]; then
          echo "$major.$minor.$patch-rc.$((rc_num+1))"
        else
          # Add RC.1 to current version
          echo "$major.$minor.$patch-rc.1"
        fi
        ;;
      *)
        echo "Error: bump must be 'major', 'minor', 'patch', 'rc'" >&2
        return 1
        ;;
    esac
  else
    echo "Error: Version must be in format vX.Y.Z or vX.Y.Z-rc.N" >&2
    echo $1
    return 1
  fi
}

# recent_tag=$(curl -s "https://api.github.com/repos/argoproj/argo-cd/tags" | grep '"name":' | sed -E 's/.*"name": "([^"]+)".*/\1/' | sort -Vr | head -n1)

echo "$(increment_version $1 $2)"

