#!/bin/bash

git config --global user.email "huynhduckhoan@gmail.com"
git config --global user.name "f97"
mkdir ./temp 
cd ./temp
rm -rf survps gh-pages
git clone https://github.com/f97/survps.git 
git clone -b gh-pages  https://github.com/f97/survps.git gh-pages
rm -rf ./gh-pages/*
cp ./survps/README.md ./gh-pages/README.md 
cp ./survps/install ./gh-pages/install 
cd ./gh-pages
npx github-readme-to-html
mv dist/index.html .
rm -rf dist/
mkdir survps
cp -rf ../survps/*/ survps
cp -rf ../survps/centos7 survps
zip -r sur.zip survps/
rm -rf survps/ README.md 
git add .
git commit -m ':zap: action running'
git push
