#!/bin/sh -l

git_setup() {
  cat <<- EOF > $HOME/.netrc
		machine github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
		machine api.github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
EOF
  chmod 600 $HOME/.netrc

  git config --global user.email "$GITHUB_ACTOR@users.noreply.github.com"
  git config --global user.name "$GITHUB_ACTOR"
}

head -n 6 web/sites/sbf/settings.php
git_setup
git remote update
echo "after remote update:"
head -n 6 web/sites/sbf/settings.php
git fetch --all
echo "after fetch:"
head -n 6 web/sites/sbf/settings.php
git branch -r
# git stash

# Will create branch if it does not exist
if [[ $( git branch -r | grep "$INPUT_BRANCH" ) ]]; then
   git checkout "${INPUT_BRANCH}"
else
   git checkout -b "${INPUT_BRANCH}"
fi

# git stash pop
rm .gitignore
cat web/sites/sbf/settings.php
git status
git add .
git commit -m "${INPUT_COMMIT_MESSAGE}"
git push --set-upstream origin "${INPUT_BRANCH}"
