# Safe sourcing helper
# Sources a file if it exists and is readable
# Silently no-ops if not present
safe_source() {
  # shellcheck disable=SC1090,SC1091
  [ -n "$1" ] && [ -r "$1" ] && source "$1"
}

# Detect interactive shell
is_interactive() {
  case $- in
    *i*) return 0 ;;
    *)   return 1 ;;
  esac
}