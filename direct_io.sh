#!/usr/bin/env sh

# In cases where you are doing streaming processing of large
# amounts of data, it can be useful to bypass the page cache
# in order to avoid thrashing. This script is designed to behave
# similar to `cat`, but bypass the OS page cache using `dd`'s
# `direct` flags. May not work in all environments, YMMV.

direct_read() {
  if [ "${#@}" -eq 0 ]; then
    direct_read -
  fi
  for file in "${@}"; do
    if [ "$file" = "-" ]; then
      cat
    else
      dd bs=1M if="$file" iflag=direct,fullblock
    fi
  done
}

direct_write() {
  case "${#@}" in
    0)
      cat
      ;;
    1)
      if [ "$1" = "-" ]; then
        direct_write
      else
        dd bs=1M of="$1" conv=fdatasync oflag=direct iflag=fullblock
      fi
      ;;
    *)
      die "too many arguments"
      ;;
  esac
}

die() {
  if [ -n "$1" ]; then
    echo "$1" >&2
  fi
  cat <<EOF >&2
Usage: $0 [-w|-r] [file]...

  Read/write files, bypassing page cache

  -w [out_file]
    Write stdin to specified file (or stdout)
    When out_file is - or unspecified, write to stdout
  -r [in_file]...
    Read specified files (and/or stdin) to stdout
    When in_file is - or unspecified, read from stdin
EOF
  exit
}

case "$1" in
  -r)
    direct_read "${@:2}"
    ;;
  -w)
    direct_write "${@:2}"
    ;;
  *)
    die
    ;;
esac
