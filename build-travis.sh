#!/bin/bash

if ! command -v optipng >/dev/null
then
    echo "Please install optipng"
    exit 1
fi
# BUILDING PNG
cp -Rf "images_libreladies_svg" \
   "images_libreladies"
rm "images_libreladies_svg/links.txt"
pushd "images_libreladies"

echo "=> Export SVG to PNG ..."
NUMFILE=$(find -name "*.svg" -o -name "*.SVG" | wc -l)
echo "=> Processing $NUMFILE files ..."
counter=1
find -name "*.svg" -o -name "*.SVG" | while read i;
do 
    rsvg-convert "$i" -o "${i%.*}.png"
    current=$((counter%100))
    if [[ "$current" == "0" ]];then
        echo "[$counter/$NUMFILE] ..."
    fi
    let counter++
done

echo "=> Delete SVG files ..."
find -name "*.svg" -o -name "*.SVG" | while read i;
do
    fname=$( basename "$i")
    fdir=$( dirname "$i")
    rm "$i"
done
popd

# BUILD TO EXTENSION
gh_repo="libreoffice-style-srikandi"
gh_desc="Srikandi LibreOffice icon themes"

cat <<- EOF

  $gh_desc
  https://github.com/libreofficeid/$gh_repo
  
  
EOF

temp_dir="$(mktemp -d)"
echo "=> Building $gh_desc [PNG] ..."
cd "images_libreladies"
zip -q -r -D images_srikandi.zip *
mv "images_srikandi.zip" \
  "./../build/"
cd "./.."
echo "=> Deleting old $gh_desc [PNG] extension file ..."
rm -f "build/Srikandi-IconSet.oxt"
echo "=> Create new $gh_desc [PNG] extension one ..."
cp "build/images_srikandi.zip" \
   "build/LibreLadies-IconSet/iconsets/"
cd "build/LibreLadies-IconSet"
zip -q -r -D Srikandi-IconSet.oxt *
mv "Srikandi-IconSet.oxt" \
   "./.."
cd "./../.."
echo "=> Done!"
# SVG Version
echo "=> Building $gh_desc [SVG Version] ..."
cd "images_libreladies_svg"
zip -q -r -D images_srikandi_svg.zip *
mv "images_srikandi_svg.zip" \
  "./../build/"
cd "./.."
echo "=> Deleting old $gh_desc [SVG] extension file ..."
rm -f "build/Srikandi-SVG-IconSet.oxt"
echo "=> Create new $gh_desc [SVG] extension one ..."
cp "build/images_srikandi_svg.zip" \
   "build/LibreLadies-SVG-IconSet/iconsets/"
cd "build/LibreLadies-SVG-IconSet"
zip -q -r -D Srikandi-SVG-IconSet.oxt *
mv "Srikandi-SVG-IconSet.oxt" \
   "./.."
cd "./../.."
echo "=> Done!"
echo "Path of Generated oxt files:"
echo "=> 1. $PWD/build/Srikandi-IconSet.oxt"
echo "=> 2. $PWD/build/Srikandi-SVG-IconSet.oxt"
