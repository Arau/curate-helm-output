#!/bin/bash

set -e

[ -z $1 ] && echo "Input file not defined" && exit 1
input="$1"

tmp="./output/`date "+%F-%H%M"`"
tmp_f="$tmp/$RANDOM.yaml"
mkdir -p "$tmp"

# Clean helm associated labels
patterns="chart heritage release "
replace_string=''
for p in $patterns; do
    replace_string="$replace_string -e /$p/d"
done

#set -x
sed $replace_string $input >> $tmp_f

csplit --prefix "manifest-" $tmp_f '/# Source:/' '{*}' > /dev/null
rm $tmp_f

mv manifest* $tmp
mv $tmp/manifest-00 $tmp/runtime-variables

# rename files
pushd . &> /dev/null
cd $tmp
for file in ./manifest*; do
    f_name=$(grep "# Source" $file | cut -d' ' -f3 | cut -d'/' -f3)
    if [ ! -z $f_name ]; then
        mv $file $f_name
        sed -i -e "/# Source/d"  $f_name
        if [ "$(grep -v "\-\-\-" $f_name | grep -c "[a-z]")" -eq "0" ]; then
            # The file is empty
            rm $f_name
        fi
    fi
done

echo "You can find your files in $tmp"

popd &> /dev/null

