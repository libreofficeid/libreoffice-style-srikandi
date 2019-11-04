#!/bin/sh

set -e

gh_repo="libreoffice-style-libreladies"
gh_desc="LibreLadies LibreOffice icon themes"

cat <<- EOF

  $gh_desc
  https://github.com/libreofficeid/$gh_repo
  
  
EOF

temp_dir="$(mktemp -d)"

cd "images_libreladies"
zip -r -D images_libreladies.zip *
mv "images_libreladies.zip" \
  "./../build/"
cd "./.."
echo "=> Deleting old $gh_desc extension file ..."
rm -f "build/libreladies-IconSet.oxt"
echo "=> Create new $gh_desc extension one ..."
cp "build/images_libreladies.zip" \
   "build/libreladies-IconSet/iconsets"
cd "build/libreladies-IconSet"
zip -r -D libreladies-IconSet.oxt *
mv "libreladies-IconSet.oxt" \
   "./.."
cd "./../.."
echo "=> Deleting old $gh_desc ..."
sudo rm -f "/usr/share/libreoffice/share/config/images_libreladies.zip"
echo "=> Installing ..."
sudo mkdir -p "/usr/share/libreoffice/share/config"
sudo mv \
  "build/images_libreladies.zip" \
  "/usr/share/libreoffice/share/config"
for dir in \
  /usr/lib64/libreoffice/share/config \
  /usr/lib/libreoffice/share/config \
  /usr/local/lib/libreoffice/share/config \
  /opt/libreoffice*/share/config; do
  [ -d "$dir" ] || continue
  sudo ln -sf "/usr/share/libreoffice/share/config/images_libreladies.zip" "$dir"
done
echo "=> Done!"
