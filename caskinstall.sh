#!/bin/sh
#
# caskinstall.sh
#
# (for MAC OSX) 
# Install Homebrew and Homebrew Cask
# lifehacker.com/how-to-make-your-own-bulk-app-installer-for-os-x-1586252163

echo "installing cask..."

ruby -e "$(curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew install caskroom/cask/brew-cask

echo "downloading programs with cask..."
./caskconfig.sh

echo "done"

