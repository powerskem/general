#!/bin/sh
#
# caskinstall.sh
#
# (for MAC OSX) 
# Install Homebrew and Homebrew Cask
# lifehacker.com/how-to-make-your-own-bulk-app-installer-for-os-x-1586252163

echo "installing homebrew..."
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "installing cask..."
brew tap caskroom/cask
#brew install caskroom/cask/brew-cask
brew install cask

echo "downloading programs with cask..."
./caskconfig.sh

echo "installing maven"
brew install maven

echo "done"

