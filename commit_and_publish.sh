#!/bin/sh
set -e

###
###
###

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

###
### add content in master branch
###

git add --all && git commit -m "quickcommits" || git status -s

sleep 1
echo -n "[master] Pulling latest ... "
git pull -q --rebase

git status

echo -n "[master] Pushing to github ... "
git push -q origin master && echo "$(tput setaf 2)Everything up-to-date$(tput sgr0)" || echo echo "$(tput setaf 1) Failed!$(tput sgr0)"

###
### push to gh-pages showcase
###

#git clone git@github.com:kroescontrol/showcase.kroescontrol.nl.git --branch gh-pages --single-branch public
#hugo --baseURL http://showcase.kroescontrol.nl
#cd public
#echo "showcase.kroescontrol.nl" > CNAME
#echo "User-agent: *" > robots.txt
#echo "Disallow: /" >> robots.txt
#git add --all
#git commit -m "[showcase] Publishing to gh-pages" || true
#git push -q origin gh-pages && echo "$(tput setaf 2)Everything up-to-date$(tput sgr0)" || echo echo "$(tput setaf 1) Failed!$(tput sgr0)"
#cd ..
#rm -Rf public
#echo "[showcase] Finished publishing to gh-pages"

###
### push gh-pages
###

echo "[www] Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "[www] Generating site"
hugo

echo "[www] Updating gh-pages branch"
cd public 
git add --all
git commit -m "[www] Publishing to gh-pages" || true

echo -n "[www] Pushing to github gh-pages ... "
git push -q origin gh-pages && echo "$(tput setaf 2)Everything up-to-date$(tput sgr0)" || echo echo "$(tput setaf 1) Failed!$(tput sgr0)"
