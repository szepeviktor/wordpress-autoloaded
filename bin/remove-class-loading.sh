#!/bin/bash
#
# 1. List all files Composer finds a class in
# 2. Remove "wp-includes/" part from path
# 3. Find all references to these files
# 4. Comment out all references

Exclude_refs()
{
    # Containing other code beside classes (+deprecated +compat)
    # wp-admin/includes/class-wp-list-table-compat.php is a class-only file
    grep -v "'wp-admin/includes/deprecated\.php'" \
        | grep -v "WPINC\s*\.\s*'/pluggable-deprecated\.php'" \
        | grep -v "WPINC\s*\.\s*'/compat\.php'" \
        | grep -v "WPINC\s*\.\s*'/random_compat/error_polyfill\.php'" \
        | grep -v "'wp-admin/includes/class-pclzip\.php'" \
        | grep -v "WPINC\s*\.\s*'/user\.php'" \
        | grep -v "WPINC\s*\.\s*'/class-simplepie\.php'" \
        | grep -v "WPINC\s*\.\s*'/rss\.php'" \
        | grep -v "WPINC\s*\.\s*'/cache\.php'"
}

Exclude_files()
{
    # These does not load core
    grep -v '^wp-includes/script-loader\.php:'
}

Get_class_files()
{
    sed -n -e "s#.* . '/app/wordpress/\(.*\)',#\1#p" ../../vendor/composer/autoload_classmap.php \
        | sort -u \
        | sed -e 's#^wp-includes/##' \
        | xargs -I "%" grep -r -E -x -n "\s*(require|include)(_once)?\(?\s*ABSPATH(\s*\.\s*WPINC)?\s*\.\s*'/?%'\s*\)?;.*" \
        | grep -v '^\.svn/' \
        | Exclude_refs \
        | Exclude_files \
        | cut -d ":" -f 1,2
}

set -e

test -d app/wordpress

cd app/wordpress/

# Already ran
if grep -q '^// AUTOLOADED require' ./wp-settings.php; then
    echo "Already autoloaded."
    exit 0
fi

test -r ../../vendor/composer/autoload_classmap.php

CLASS_FILES="$(Get_class_files)"

if [ -z "$CLASS_FILES" ]; then
    echo "Please enable authoritative class maps: composer dump-autoload --classmap-authoritative" 1>&2
    echo "Then restart this script: composer run-script post-install-cmd" 1>&2
    exit 11
fi

if [ "${TRAVIS}" == true ]; then
    echo "travis_fold:start:Autoloaded_files"
fi

while read -r FILE_LINE; do
    echo "$FILE_LINE ..."
    sed -e "${FILE_LINE#*:}"'s#.*#// AUTOLOADED &#' -i "${FILE_LINE%:*}"
done <<<"$CLASS_FILES"

if [ "${TRAVIS}" == true ]; then
    echo "travis_fold:end:Autoloaded_files"
fi

echo "OK."
