#!/bin/sh
# This script installs Home Brew and then a list of predefined tools
# that suit me specially well.

# Learnt in https://apple.stackexchange.com/questions/98080/can-a-macs-model-year-be-determined-with-a-terminal-command
hwmodel=`curl -s https://support-sp.apple.com/sp/product?cc=$(
  system_profiler SPHardwareDataType \
    | awk '/Serial/ {print $4}' \
    | cut -c 9-
) | sed 's|.*<configCode>\(.*\)</configCode>.*|\1|'`
echo "* Checking hardware model: $hwmodel"
echo " "
echo "* Checking for Xcode command line developer tools ..."
xcode-select --install
if [ $? -eq 0 ]; then
  echo "* You are being requested to install the command line developer tools now in a separate dialog. Please proceed."
fi
echo "* We're checking / installing Brew."
chmod u+x $0
echo "* Please provide credentials when required."
echo " "
brew --version || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "* Updating package database ..."
brew update
echo "* Installing some editors ..."
brew cask install visual-studio-code
echo "* Installing a benchmarking tool ..."
brew cask install geekbench
echo "* Installing web browsers"
brew cask install firefox google-chrome
echo "* Installing chat, email and collaboration tools ..."
brew cask install skype zoomus thunderbird
echo "* Installing THE office suite ..."
brew cask install libreoffice libreoffice-language-pack
echo "* Installing Hashicorp tools ..."
brew cask install vagrant vagrant-manager
echo "* Installing automation tools ..."
if [ `stat -f %Su /usr/local/lib/pkgconfig` != `whoami` ]; then
  echo " The following directories are not writable by your user: /usr/local/lib/pkgconfig"
  echo "* Changing permissions ..."
  # We change permissions of that folder
  sudo chown -R $(whoami) /usr/local/lib/pkgconfig
fi
brew install ansible ansible-lint
echo "* Installing virtualization tools"
brew cask install virtualbox virtualbox-extension-pack
echo "* Installing cloud tools"
brew cask install google-cloud-sdk
echo "* Installing communication and terminal tools ..."
brew cask install coccinellida cyberduck cord zterm
echo "* Installing some amusements ..."
brew cask install spotify spotifree vlc disk-inventory-x
echo "* Installing API tools ..."
brew cask install postman
echo "* Installing GitHub tools ..."
brew cask install github
echo "* Installing compression tools ..."
brew cask install rar
echo "* Installing database frontends ..."
brew cask install mysqlworkbench
echo "* Installing X frontend for Mac, required by other tools ..."
brew cask install xquartz
echo "* Installing design and photo tools ..."
brew cask install gimp inkscape
echo "* Installing Java ..."
brew cask install java
if echo $hwmodel|grep -i book > /dev/null ; then
  echo "* Installing battery monitor ..."
  brew install coconutbattery
fi
# Docker
if [ `sysctl kern.hv_support|awk '{print $2}'` -ne 1 ]; then
  echo "* Installing docker-toolbox ..."
  #brew cask install docker-toolbox
else
  echo "* Installing docker, as it's supported with this hardware ..."
  brew cask install docker
fi
echo "* Installing mas utility to allow command line management of App Store installed items ..."
# Read on https://www.podfeet.com/blog/2018/01/reinstall-mac-app-store-apps-from-the-command-line/
brew install mas
echo "* Installing Slack from App Store ..."
mas install 803453959 # Slack 3.3.8
mas upgrade # Install later versions
brew cleanup
