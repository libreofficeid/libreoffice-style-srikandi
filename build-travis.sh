#!/bin/bash

if ! command -v optipng >/dev/null
then
    echo "Please install optipng"
    exit 1
fi

cp -Rf "images_libreladies_svg" \
   "images_libreladies"
rm "images_libreladies_svg/links.txt"
cd "images_libreladies"

echo "=> Export SVG to PNG ..."
find -name "*.svg" -o -name "*.SVG" | while read i;
do 
#	echo "This $i file is compressed"
	fname=$( basename "$i")
#	echo "has the name: $fname"
	fdir=$( dirname "$i")
#	echo "and is in the directory: ${fdir##*/}"
	inkscape -f "$i" -e "${i%.*}.png" 2>/dev/null 1>/dev/null
	optipng -quiet -o7 "${i%.*}.png" 
	#convert "$i" -quality 75 "$i"
done

echo "=> Delete SVG files ..."
find -name "*.svg" -o -name "*.SVG" | while read i;
do
    fname=$( basename "$i")
    fdir=$( dirname "$i")
    rm "$i"
done

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
