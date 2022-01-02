git config --global user.email "huynhduckhoan@gmail.com"
git config --global user.name "f97"
git clone https://f97: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@github.com/f97/survps.git 
git clone -b gh-pages  https://f97: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@github.com/f97/survps.git gh-pages
cp ./survps/README.md ./gh-pages/README.md 
cd ./gh-pages
npx github-readme-to-html
mv dist/index.html .
rm -rf dist/
mkdir survps
cp -rf ../survps/*/ survps
cp -rf ../survps/centos7 survps
zip -r sur.zip survps/
rm -rf survps/
git commit -a -m ':zap: action running'
git push
rm -rf ../*/
