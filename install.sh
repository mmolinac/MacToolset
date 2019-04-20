#!/bin/sh
# This script installs Home Brew and then a list of predefined tools
# that suit me specially well.

# Functions

# Learnt in https://apple.stackexchange.com/questions/98080/can-a-macs-model-year-be-determined-with-a-terminal-command

hardwareModel() {
    local var=`curl -s https://support-sp.apple.com/sp/product?cc=$(
      system_profiler SPHardwareDataType \
      | awk '/Serial/ {print $4}' \
      | cut -c 9-
      ) | sed 's|.*<configCode>\(.*\)</configCode>.*|\1|'`
    echo "$var"
}

brewBundle() {
    echo "* Installing $2 ..."
    brew bundle install --file=./${1}.Brewfile|grep -v "^Using homebrew"|grep -v ^"Homebrew Bundle complete"
    echo " "
}

# Main block

hwmodel=$(hardwareModel)
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

# We'll provide a line per section to install:
#   brewBundle filename "simple description"
# where 'filename' references a file in the repo called 'filename.Brewfile'
# with the description inside

brewBundle editors "some editors"
brewBundle benchmark "benchmarking tools"
brewBundle browsers "web browsers"
brewBundle chatcollab "chat, email and collaboration tools"
brewBundle office "THE office suite"
brewBundle hashicorp "Hashicorp tools"

# Permissions needed in order to install Ansible
if [ `stat -f %Su /usr/local/lib/pkgconfig` != `whoami` ]; then
  echo " The following directories are not writable by your user: /usr/local/lib/pkgconfig"
  echo "* Changing permissions ..."
  # We change permissions of that folder
  sudo chown -R $(whoami) /usr/local/lib/pkgconfig
  echo " "
fi
brewBundle automation "automation tools"
# Ansible needs this authentication module for Google Cloud Platform:
/usr/local/Cellar/ansible/*/libexec/bin/pip3 install google-auth && echo " "

brewBundle virt "virtualization tools"
brewBundle cloud "cloud tools"
# PIP module needed for SoftLayer, not available in Brew
pip3 install -U SoftLayer && echo " "

brewBundle comm "communications, remote terminal and VPN tools"
brewBundle amuse "some amusements"
brewBundle api "API tools"
brewBundle git "git tools"
brewBundle compress "compression tools"
brewBundle database "database tools"
brewBundle design "image design and photo tools"
brewBundle java "Java SDK"
brewBundle mediamgmt "CD/DVD recording and hard drive management software"

if echo $hwmodel|grep -i book > /dev/null ; then
  brewBundle battery "battery monitor"
fi

# Docker
if [ `sysctl kern.hv_support|awk '{print $2}'` -ne 1 ]; then
  brewBundle dockertool "docker-toolbox"
else
  brewBundle docker "docker, as it's supported with this hardware"
fi

echo "* Upgrading App Store applications ..."
# Read on https://www.podfeet.com/blog/2018/01/reinstall-mac-app-store-apps-from-the-command-line/
mas upgrade # Install later versions
brew cleanup
