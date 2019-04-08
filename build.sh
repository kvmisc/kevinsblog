#!/bin/bash

################################################################################
#
# Requirements
#
#   # Install pandoc
#   brew install pandoc
#
################################################################################

rm deploy/posts/*
rm -rf tmp/index.html

for item in posts/*
do
  filename=`basename $item .md`

  pandoc -s \
  --template templates/post.html \
  --from markdown-auto_identifiers \
  --to html \
  -o deploy/posts/${filename}.html \
  ${item}

  pandoc -s \
  --template templates/post_compact.html \
  --from markdown-auto_identifiers \
  --to html \
  -o tmp/entry.html \
  --variable=url:posts/${filename}.html \
  ${item}

  touch tmp/index.html
  cat tmp/index.html>>tmp/entry.html
  rm -rf tmp/index.html
  mv tmp/entry.html tmp/index.html

done


rm deploy/index.html
cp templates/page.html deploy/index.html

sed -i.bak 's/{page_title}/主页/' deploy/index.html

sed -i.bak '/{page_body}/ {
  r tmp/index.html
  d
}' deploy/index.html

rm deploy/index.html.bak


rm -rf /Library/WebServer/Documents/*
cp -rf deploy/* /Library/WebServer/Documents/


if [[ $1 = "-c" || $1 = "-d" ]]; then
  echo "Push to trunk"
  git add .
  git status
  git commit -a -m "Commit at `date +'%y-%m-%d %H:%M:%S'`"
  git push
fi

if [[ $1 = "--d" ]]; then
  echo "Publish site"
ssh -p 26615 root@107.148.246.136 'cd /var/www/kevinsblog/ && git pull'
fi
