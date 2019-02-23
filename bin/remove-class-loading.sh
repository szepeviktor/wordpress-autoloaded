#!/bin/bash

set -e

test -d app/wordpress

cd app/wordpress/

test -r ../../vendor/composer/autoload_classmap.php

sed -n -e "s#.* . '/app/wordpress/\(.*\)',#\1#p" ../../vendor/composer/autoload_classmap.php | uniq \
    | xargs -I "%" grep -r -E -x -n "\s*(require|include)(_once)?\(?\s*ABSPATH\s*\.\s*'/?%'\s*\)?;.*" | cut -d ":" -f 1,2 \
    | while read -r FILE_LINE; do
        echo "$FILE_LINE ..."
        sed -e "${FILE_LINE#*:}"'s|.*|// AUTOLOAD &|' -i "${FILE_LINE%:*}"
    done

echo "OK."
