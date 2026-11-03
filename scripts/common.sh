# Shared settings for run.sh and check_all.sh. Source, don't execute.

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

FC="${FC:-gfortran}"
FFLAGS="${FFLAGS:--std=f2023 -Wall -Wextra -pedantic -fcheck=all -g -fbacktrace}"
BUILD_DIR="${BUILD_DIR:-$root/build}"

# directive KEY FILE: print the value of the first "! @KEY value" line, if any.
directive() {
  sed -n "s/^[[:space:]]*![[:space:]]*@$1[[:space:]]*//p" "$2" | head -n 1
}

# build_one FILE: compile FILE into its own build directory, print the executable path.
# Each example gets a separate directory so .mod files never clash.
build_one() {
  local src rel out
  src="$(realpath "$1")"
  rel="${src#"$root"/}"
  out="$BUILD_DIR/${rel%.*}"
  mkdir -p "$out"
  # shellcheck disable=SC2086
  "$FC" $FFLAGS $(directive flags "$src") -J "$out" "$src" -o "$out/a.out" >&2 || return
  echo "$out/a.out"
}
