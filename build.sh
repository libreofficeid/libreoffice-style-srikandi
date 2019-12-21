#!/bin/bash
# Kumbakarna - Icon theme generator for LibreOffice by Sofyan Sugiyanto & Rania Amina

# Check directory and/or Dependencies
# check optipng or not
if ! command -v optipng >/dev/null
then
    echo "Please install optipng"
    exit 1
fi
# check rsvg installed or not
if ! command -v rsvg-convert > /dev/null
then
    echo "Please install librsvg2"
    exit 1
fi
SVG_FOLDER=""
# check SVG directory
[ ! -d *_svg ] && echo "No SVG Directories found" || SVG_FOLDER=$(ls -d *_svg)
[ -z "$SVG_FOLDER" ] && exit 1
# check PNG directory
PNG_FOLDER=$(echo $SVG_FOLDER | sed "s/_svg//")
[ -d "$PNG_FOLDER" ] && rm -rfv "$PNG_FOLDER"

# Export SVG to PNG 
# prepairing for export
cp -r "$SVG_FOLDER" "$PNG_FOLDER"
NUMFILE=$(find "$PNG_FOLDER" -name "*.svg" -o -name "*.SVG" | wc -l)
echo "Processing $NUMFILE files ..."
counter=1
find "$PNG_FOLDER" -name "*.svg" -o -name "*.SVG" | while read i;
do 
    rsvg-convert "$i" -o "${i%.*}.png"
# Optimize (optional)
    optipng -quiet -o7 "${i%.*}.png"
    current=$((counter%100))
    if [[ "$current" == "0" ]];then
        echo "[$counter/$NUMFILE] ..."
    fi
    let counter++
done

# clear svg files
echo "Deleting Unused SVG files ..."
find "$PNG_FOLDER" -name "*.svg" -o -name "*.SVG" | while read i;
do
    rm "$i"
done
sed -i "s/.svg/.png/g" "$PNG_FOLDER/links.txt" 
# 4 - Create ZIP image for SVG and PNG
echo "Creating ZIP Images"
pushd "$SVG_FOLDER"
zip -q -r -D ../build/"$SVG_FOLDER".zip *
popd
pushd "$PNG_FOLDER"
zip -q -r -D ../build/"$PNG_FOLDER".zip *
popd
# 5 - Copying ZIP to OXT env directory
THEMENAME=$(echo $PNG_FOLDER | sed "s/images_//")
cp build/"$PNG_FOLDER".zip build/"$THEMENAME"-IconSet/iconsets/
cp build/"$SVG_FOLDER".zip build/"$THEMENAME"-SVG-IconSet/iconsets/
# 6 - Create OXT files
echo "Creating Extension Files"
pushd build/"$THEMENAME"-IconSet/
zip -q -r -D ../"$THEMENAME"-IconSet.oxt *
popd
pushd build/"$THEMENAME"-SVG-IconSet/
zip -q -r -D ../"$THEMENAME"-SVG-IconSet.oxt *
popd
echo "Path of Generated oxt files:"
echo "=> 1. $PWD/build/$THEMENAME-IconSet.oxt"
echo "=> 2. $PWD/build/$THEMENAME-SVG-IconSet.oxt"
