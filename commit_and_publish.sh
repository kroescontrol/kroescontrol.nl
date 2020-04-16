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
echo -n "[LIVE] Pulling latest ... "
git pull -q --rebase

git status

echo -n "[LIVE] Pushing to github ... "
git push -q origin master && echo "$(tput setaf 2)Everything up-to-date$(tput sgr0)" || echo echo "$(tput setaf 1) Failed!$(tput sgr0)"

###
### push to gh-pages showcase
###

git clone git@github.com:kroescontrol/showcase.kroescontrol.nl.git --branch gh-pages --single-branch public
hugo --baseURL https://showcase.kroescontrol.nl
cd public
git add --all
git commit -m "[SHOWCASE] Publishing to gh-pages" || true
git push -q origin gh-pages && echo "$(tput setaf 2)Everything up-to-date$(tput sgr0)" || echo echo "$(tput setaf 1) Failed!$(tput sgr0)"
cd ..
rm -Rf public

echo "[SHOWCASE] Finished publishing to gh-pages"

sleep 10

###
### push gh-pages LIVE WWW
###

echo "[LIVE] Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "[LIVE] Generating site"
hugo

echo "[LIVE] Updating gh-pages branch"
cd public 
git add --all
git commit -m "[LIVE] Publishing to gh-pages" || true

echo -n "[LIVE] Pushing to github gh-pages ... "
git push -q origin gh-pages && echo "$(tput setaf 2)Everything up-to-date$(tput sgr0)" || echo echo "$(tput setaf 1) Failed!$(tput sgr0)"
