#!/bin/sh
grep -irl http /etc 2>/dev/null | xargs file | grep ", ASCII text" | cut -d: -f1 | xargs du | sort -rg | head -1 | awk '{print $2}' | xargs sed '13clinux is cool' | head -15

#second option
find /etc/ -type f -printf '%s %p\n' 2> /dev/null | sort -n | cut -d" " -f2 | xargs grep -Ili 'http' 2> /dev/null | tail -1 | xargs sed '13clinux is cool' | head -15
