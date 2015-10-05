#!/bin/bash

############################################################################
#
# Script used to prepare everything required for the OSX dev env setup with
# Ansible and home brew.
#
# Author: Simon Dietschi
#
############################################################################

# Script config
# -------------

ANSIBLE_BINARY="/usr/local/bin/ansible"
ANSIBLE_MINIMUM_VERSION="1.9.0.1"
HOME_BREW_REPO="https://raw.githubusercontent.com/Homebrew/install/master/install"

# Script functions
# ----------------

# Returns 1 if Ansible should be installed.
#
# $1 - the Ansible path to the binary
# $2 - the minimum version of Ansible
function shouldInstallAnsible() {

	ansible_binary=$1
	minimum_version=$2

	if [ ! -f "${ansible_binary}" ]; then
	  # Ansible binary not there, should be installed
	  return 1
	fi

	ansible_correct_version_installed=`${ansible_binary} --version 2>&1 | cut -c 9- | grep "${minimum_version}"`

	if [ "${ansible_correct_version_installed}" ]; then
	  # Ansible there with expected minimal version, no install required
	  return 0
	fi

	return 1
}

# Script
# ------

echo "====================================================="
echo "Installation script to prepare everything required"
echo "for the Ansible based provisioning of the OSX dev env."
echo ""
echo "Run this script locally on your Mac!"
echo "====================================================="
echo ""
read -p "Continue ? [Enter]"
echo ""
echo ""

echo "XCode Tools Installation"
echo "------------------------"
echo ""
if [ ! -f "/Library/Developer/CommandLineTools/usr/bin/clang" ]; then
    echo "This will open up a modal window ... Get back here when ready !"
    sudo /usr/bin/xcode-select --install
    read -p "Continue ? [Enter]"
    echo ""
else
	echo "XCode Tools found, everything ok"
	echo ""
fi

echo "Home Brew Installation"
echo "----------------------"
echo ""

which -s brew
if [[ $? != 0 ]] ; then
  echo "Installing homebrew, as it was not found"
  # Install Homebrew
  /usr/bin/ruby -e "$(curl -fsSL $HOME_BREW_REPO)"
else
  echo "Brew found, nothing to do"
	echo ""
fi

echo "Make sure /usr/local is writable by the current user"
sudo chown $(whoami):admin /usr/local && sudo chown -R $(whoami):admin /usr/local

echo "Ansible installation"
echo "--------------------"
echo ""
shouldInstallAnsible $ANSIBLE_BINARY $ANSIBLE_MINIMUM_VERSION
if [[ $? != 0 ]]; then
  echo "Trying to install required Ansible version $ANSIBLE_MINIMUM_VERSION, as it was not found"
  brew reinstall ansible
  echo ""
else
  echo "Ansible found, nothing to do"
  echo ""
fi

echo "====================================================="
echo "Done"
