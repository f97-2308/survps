#!/bin/bash

git config --global user.email "huynhduckhoan@gmail.com"
git config --global user.name "f97"
rm -rf survps
git clone https://github.com/f97/survps.git 
cd survps
npx github-readme-to-html
mv dist/index.html .
mkdir survps
cp -rf ../survps/*/ survps
cp -rf ../survps/centos7 survps
zip -r sur.zip survps/
rm -rf survps/ .github/ config/ services/ src/ CHANGELOG.md README.md install .editorconfig centos7 dist
git checkout gh-pages
git add .
git commit -m ':zap: action running'
git push
