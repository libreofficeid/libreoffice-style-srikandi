#!/bin/sh

set -e

gh_repo="libreoffice-style-libreladies"
gh_desc="LibreLadies LibreOffice icon themes"

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
echo "=> Installing theme"
set +e
for configdir in \
    $HOME/.config/libreoffice/4/user \
    $HOME/.config/libreofficedev/4/user \
    $HOME/.var/app/org.libreoffice.LibreOffice/config/libreoffice/4/user \
    $HOME/snap/libreoffice/current/.config/libreoffice/4/user; do
    [ -d "$configdir" ] || continue
    mkdir -p "$configdir/iconsets"
    is_installed="$(grep -rnw "iconsets" $configdir/registrymodifications.xcu)"
    if [ -z "$is_installed" ]; then
        sed -i "3i <item oor:path=\"\/org.openoffice.Office.Paths\/Paths\/Iconset\/InternalPaths\"><node oor:name=\"\$\(userurl\)\/iconsets\" oor:op=\"fuse\"\/><\/item>" $configdir/registrymodifications.xcu
   fi
    # copy file to configdir/iconsets
    cp $PWD/build/images_srikandi.zip $PWD/build/images_srikandi_svg.zip $configdir/iconsets/
done
echo "=> Done!"
echo "Path of Generated oxt files:"
echo "=> 1. $PWD/build/Srikandi-IconSet.oxt"
echo "=> 2. $PWD/build/Srikandi-SVG-IconSet.oxt"
