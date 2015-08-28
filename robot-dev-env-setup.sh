#!/usr/bin/env bash

#############################################################
#
# Sets up the robot framework dev env for web testing
# on OS X.
#
# Author: Simon Dietschi
#
#############################################################

echo "====================================================="
echo "Installation script to prepare a robot framework"
echo "dev environment on OSX."
echo ""
echo "PLEASE NOTE: If nothing has been installed before,"
echo "this script will install the latest package versions."
echo ""
echo "Run this script locally on your Mac!"
echo "====================================================="
echo ""
read -p "Continue ? [Enter]"
echo ""
echo ""

# Install latest Python via brew which install pip as well
brew install python

# Intstall robot framework
pip install robotframework

# Install selenium2lib for web testing
pip install robotframework-selenium2library

# Install additional libraries
pip install robotframework-sshlibrary
pip install robotframework-requests

# Install chrome and web driver
brew cask install google-chrome
brew install chromedriver
