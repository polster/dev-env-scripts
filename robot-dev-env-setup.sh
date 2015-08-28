#!/usr/bin/env bash

#############################################################
#
# Sets up the robot framework dev env for web testing
# on OS X.
#
# Author: Simon Dietschi
#
#############################################################

# Intstall robot framework
pip install robotframework

# Install selenium2lib
pip install robotframework-selenium2library

# Install chrome and web driver
brew cask install google-chrome
brew install chromedriver
