#!/bin/bash

# set the color of the prompt
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# create a config file for mpm
if [ ! -f /etc/mpm.conf ]; then
    mpm_config="/etc/mpm.conf"
    echo "Creating ${mpm_config}"
    touch ${mpm_config}
    chmod 644 ${mpm_config}
fi
#!/bin/sh

# Bash Color
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
txtrst=$(tput sgr0) # Reset

echo""
echo "${grn}  
The MatuusOS Package Manager
By: The MatuusOS team
${txtrst}"

# create a config file for mpm inside /MatuusOS
if [ ! -f /MatuusOS/mpm.conf ]; then
    mpm_config="/MatuusOS/mpm.conf"
    echo "Creating ${mpm_config}"
    touch ${mpm_config}
    chmod 644 ${mpm_config}
fi

# check if the user is running this command with sudo
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit
fi

wget=/usr/bin/wget
tar=/bin/tar

# if user inputs the -br parameter, ask and then install the package from Homebrew
if [ "$1" = "-br" ]; then
  echo "Do you want to install the package from Homebrew? (y/n)"
  read homebrew
  if [ "$homebrew" = "y" ]; then
    brew install $2
  fi
fi

# get the latest database wit
# if user inputs the -h parameter, show the help
if [ "$1" = "-h" ]; then
  echo "Usage: mpm.sh [options] [howto]"
  echo "Options:"
  echo " -br [package] Install the package from Homebrew"
  echo " -a       Add new repo"
  echo " -h       Show this help"
  echo " -i       Install the howto"
  echo " -l       List the howtos"
  echo " -s       Search the howtos"
  echo " -u       Update the howto"
  echo " -v       Show the version"
  echo " -x       Remove the built package"
  echo " -c       Clear the howtos"
  echo " -lo [path to mpkg]   Install local mpkg"
fi
# make the mpm.pkgs file with touch and if not exist, create it
if [ ! -f /etc/mpm.pkgs ]; then
    mpm_pkgs="/etc/mpm.pkgs"
    echo "Creating ${mpm_pkgs}"
    touch ${mpm_pkgs}
    chmod 644 ${mpm_pkgs}
fi
# write the name of howto that was successfully installed to the system to mpm.pkgs
if [ "$1" = "-i" ]; then
  echo "$2" >> /etc/mpm.pkgs
fi
# if user inputs -a parameter, then add second source to the mpm.conf file
if [ "$1" = "-a" ]; then
  echo "Adding $2 to the mpm.conf file"
  echo "$2" >> /etc/mpm.conf
fi
# if user inputs -c parameter, then clear the .mpkg files
if [ "$1" = "-c" ]; then
  echo "Clearing the .mpkg files"
  rm -rf /MatuusOS/mpkgs/*
fi

# if user inputs the -i parameter, and then repo in format username/repo, then find .mpkg file and install it
if [ "$1" = "-i" ]; then
  # check if the repo is valid
  if [ "$2" ]; then
    echo "This repo is not valid"
    exit
  fi
  # check if the repo is valid
  if [ "$2"/"$3" ]; then
  wget -q https://raw.githubusercontent.com/$2/$3/master/$3.mpkg -O /tmp/mpkg
 # if there is not a .mpkg file, then find install.sh on repo
  if [ ! -f /tmp/mpkg ]; then
    wget -q https://raw.githubusercontent.com/$2/$3/master/install.sh -O /tmp/mpkg
  fi
  # if there is not a .mpkg file, then find install.sh on repo
  if [ ! -f /tmp/mpkg ]; then
    echo "This repo is not valid"
    exit
  fi
  # if there is a .mpkg file, then install it
  if [ -f /tmp/mpkg ]; then
    echo "Installing $2/$3"
    # extract the .mpkg file and then remove it
    tar -xvf /tmp/mpkg -C /MatuusOS/mpkgs/
    rm /tmp/mpkg
    # if there is install.sh file, then run it
    if [ -f /MatuusOS/mpkgs/$2/$3/install.sh ]; then
      echo "Running the install.sh file"
      chmod +x /MatuusOS/mpkgs/$2/$3/install.sh
      /MatuusOS/mpkgs/$2/$3/install.sh
      echo "Done installing $2/$3"
    fi
  fi
  fi
 # find name, version and source
  name=$(cat /tmp/mpkg | grep name | cut -d '=' -f2)
  version=$(cat /tmp/mpkg | grep version | cut -d '=' -f2)
  source=$(cat /tmp/mpkg | grep source | cut -d '=' -f2)
  # check if the package is already installed
  if [ -f /MatuusOS/$name-$version.mpkg ]; then
    echo "The package is already installed"
    exit
  else
    # follow the instructions{} function in the mpkg file to install the package
    instructions=$(cat /tmp/mpkg | grep instructions | cut -d '{' -f2 | cut -d '}' -f1)
    eval $instructions
    # write the name of howto that was successfully installed to the system to mpm.pkgs
    echo "$name-$version" >> /etc/mpm.pkgs
  fi
  fi
