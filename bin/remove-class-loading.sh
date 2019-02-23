#!/bin/bash
#
# 1. List all files Composer finds a class in
# 2. Remove "wp-includes/" from path
# 3. Find all references to these files
# 4. Comment out all references


Get_class_files()
{
    sed -n -e "s#.* . '/app/wordpress/\(.*\)',#\1#p" ../../vendor/composer/autoload_classmap.php | sort -u \
        | sed -e 's#^wp-includes/##' \
        | xargs -I "%" grep -r -E -x -n "\s*(require|include)(_once)?\(?\s*ABSPATH(\s*\.\s*WPINC)?\s*\.\s*'/?%'\s*\)?;.*" | cut -d ":" -f 1,2
}

set -e

test -d app/wordpress

cd app/wordpress/

test -r ../../vendor/composer/autoload_classmap.php

CLASS_FILES="$(Get_class_files)"

while read -r FILE_LINE; do
    echo "$FILE_LINE ..."
    sed -e "${FILE_LINE#*:}"'s#.*#// AUTOLOAD &#' -i "${FILE_LINE%:*}"
done <<<"$CLASS_FILES"

echo "OK."
