#!/bin/sh

# Usage
# =====
# Create a new directory named ``osgeorel`` beside your repository
# clone::
#
#   mdkir ../osgeorel
#
# Then run this script in separate terminal (will block the terminal)
# in the repository directory::
#
# ./watch-and-build-pages.sh
#
# Every time you change something in HTML or CSS file the new version of
# pages will be generated into ``../osgeorel`` directory. You just need
# to open the generated web page (e.g., ``../osgeorel/index.html``) in
# the web browser or just reload the page you work on.
#
# End this script using Ctrl+C (on Linux).
#
# Dependencies
# ============
# You need to install watchdog Python package which provides
# watchmedo command.
#
# See watchdog pypi web page for details and installation instructions:
# https://pypi.python.org/pypi/watchdog
#
# On Ubuntu you can use::
#
#   sudo apt-get install python-pip libyaml-dev
#   sudo pip install watchdog
#
# If you don't have argcomplete installed, watchmedo will complain
# that it is missing but we don't need it, so there is nothing to worry
# about.


watchmedo shell-command --patterns="*.html;*.css;*.js;*.json" --recursive --wait --command='./build-pages.sh' .

