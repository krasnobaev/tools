#!/bin/sh

# https://stackoverflow.com/questions/41301627/how-to-update-git-commit-author-but-keep-original-date-when-amending
# https://stackoverflow.com/questions/750172/how-do-i-change-the-author-and-committer-name-email-for-multiple-commits

git filter-branch --env-filter '
NEW_NAME="Aleksey Krasnobaev"
NEW_EMAIL="alekseykrasnobaev@gmail.com"
export GIT_COMMITTER_NAME="$NEW_NAME"
export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
export GIT_AUTHOR_NAME="$NEW_NAME"
export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
' --tag-name-filter cat -- --branches --tags
