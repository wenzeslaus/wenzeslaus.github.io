#!/bin/bash

# branch names
source=source
pages=master

output=$(git status --porcelain)
if [ $? -ne 0 ]; then
    echo "git status failed. Are you in a repository?" 1>&2;
    exit
elif [ -n "$output" ]; then
    echo "Cannot publish. There are some untracked files." 1>&2;
    echo "Using \"git status\" to show what is not committed or tracked."
    git status
    exit
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ $? -ne 0 ]; then
    # there is no point in asking about repository now
    echo "git rev-parse failed. Are you in a repository?" 1>&2;
    exit
elif [ "$source" != "$current_branch" ]; then
    echo "You are not on $source branch, so you should not build into $pages branch." 1>&2;
    echo "Using \"git branch\" to show current branches."
    git branch
    exit
fi


output=$(git log origin/$source..$source)
if [ $? -ne 0 ]; then
    echo "git log failed. Are you in a repository?" 1>&2;
    exit
elif [ -n "$output" ]; then
    echo "There are some commits which should be pushed before publishing pages." 1>&2;
    echo "Use \"git log origin/$source..$source\" to review them and \"git push\" to push them to remote repository." 1>&2;
    exit
fi

# the actual build
echo "Building..."
./build.sh

if [ $? -ne 0 ]; then
    echo "Build failed. Use ./build.sh script to debug the issue." 1>&2;
    exit
fi

last_commit=$(git log -n 1  --pretty=format:"%h \"%s\"")

build_dir="build"

cd $build_dir

if [ $? -ne 0 ]; then
    echo "Do you have clone of the repository for $pages branch in $build_dir?" 1>&2;
    exit
fi

current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ $? -ne 0 ]; then
    echo "git rev-parse failed. Is $(pwd) a clone of a repository?" 1>&2;
    exit
elif [ "$source" = "$current_branch" ]; then
    echo "You are not on $pages branch in $build_dir, so you cannot publish pages." 1>&2;
    echo "Using \"git branch\" to show current branches."
    git branch
    exit
fi

# the publishing process for GitHub

# fail on first error
set -e

# stage all (new, modified, deleted) files
git add -A

# check commit separately to provide informative error message
# commit fails when there is nothing to commit
set +e
echo "Build of" $last_commit | git commit -a --file=-

if [ $? -ne 0 ]; then
    echo "Probably nothing changed in the build, so no commit is needed." 1>&2;
    echo "You may want to just \"git push\" in $build_dir or do some changes first."
    exit
fi
set -e

# get changes of other people to be able to push but prefer current state
git pull --no-edit --commit --strategy=ours

git push

set +e
