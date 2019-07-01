#!/bin/sh
#
# Opens the github page for a repo/branch in your browser.
#
# gh [remote] [branch]

if ! git rev-parse 2>/dev/null
then
    echo "Not a git repository."
    exit 1
fi

remote="origin"
if [ -n "$1" ]
then
    remote="$1"
fi

remote_url="remote.${remote}.url"

giturl=$(git config --get "$remote_url")
if [ -z "$giturl" ]
then
    echo "$remote_url not set."
    exit 1
fi

giturl=$(echo "${giturl}" | sed 's#git@github.com:#https://github.com/#')
giturl=${giturl%\.git}

if [ -z "$2" ]
then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
else
    branch="$2"
fi

if [ -n "$branch" ]
then
    giturl="${giturl}/tree/${branch}"
fi

if command -v xdg-open >/dev/null
then
    xdg-open "$giturl"
else
    open "$giturl"
fi
