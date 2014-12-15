#!/bin/sh

# Uploads the changes to the afs space on server.
# You will be asked for your password to server if you don't use ssh key.
# On server you need to use ssh key to access NCSU GitHub.

if [ $# -ne 1 ]; then
    echo 1>&2 "Usage: $0 username"
    exit 1
fi

# exit on any error
set -e

USERNAME=$1
WEBDIR=../www
REPDIR=homepage
BUIDDIR=build

ssh $USERNAME@ras01.cos.ncsu.edu "
cd $REPDIR
git pull
./build-pages.sh
# it does not clean the old files
cp --recursive --update --no-target-directory --verbose $BUIDDIR $WEBDIR
";

