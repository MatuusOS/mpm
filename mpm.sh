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
  echo " -br [reponame] Install the package from Homebrew"
  echo " -dl      Download the latest database from Github"
  echo " -h       Show this help"
  echo " -i       Install the howto"
  echo " -l       List the howtos"
  echo " -s       Search the howtos"
  echo " -u       Update the howto"
  echo " -v       Show the version"
  echo " -x       Remove the built package"
  echo " -c       Clear the howtos"
  echo " -lo [path to howto]   Install local howto"
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
# on the first run, ask the user to add a repo to mpm.conf
# and check if the repo is valid and if it is, add it to the mpm.conf
if [ ! -f /etc/mpm.conf ]; then
  echo "Do you want to add a repo to mpm.conf? (y/n)"
  read add_repo
    if [ "$add_repo" = "y" ]; then
    echo "Enter the repo name:"
    read repo_name
    echo "Enter the repo url:"
    read repo_url
    echo "Enter the repo branch:"
    read repo_branch
    echo "Enter the repo type:"
    read repo_type
    echo "Enter the repo priority:"
    read repo_priority
    echo "Enter the repo description:"
    read repo_description
    # add repo name, url, branch, type, priority and description to mpm.conf
    echo "repo_name = ${repo_name}" >> /etc/mpm.conf
    echo "repo_url = ${repo_url}" >> /etc/mpm.conf
    echo "repo_branch = ${repo_branch}" >> /etc/mpm.conf
    echo "repo_type = ${repo_type}" >> /etc/mpm.conf
    echo "repo_priority = ${repo_priority}" >> /etc/mpm.conf
    echo "repo_description = ${repo_description}" >> /etc/mpm.conf
    fi
fi


# if user input -i parameter, download the howto from MatuusOS Github
if [ "$1" = "-i" ]; then
  echo "Downloading the howto..."
  wget -q -O /MatuusOS/howto/$2.howto https://raw.githubusercontent.com/MatuusOS/howto/master/$2.howto
  echo "Download complete"
# when the howto is downmloaded, read the .howto file and ask user if he wants to edit it
  echo "Do you want to edit the howto? (y/n)"
  read edit_howto
    if [ "$edit_howto" = "y" ]; then
     nano /MatuusOS/howto/$2.howto
    fi
fi

# also check for name, version and heavily-depends-on in the howto

if [ "$1" = "-i" ]; then
  echo "Checking the howto..."
  howto_name=$2
  howto_path=/MatuusOS/howto/${howto_name}.howto
  howto_content=$(cat ${howto_path})
  howto_name=$(echo ${howto_content} | grep name)
  howto_name_content=$(echo ${howto_name} | cut -d'{' -f2 | cut -d'}' -f1)
  howto_version=$(echo ${howto_content} | grep version)
  howto_version_content=$(echo ${howto_version} | cut -d'{' -f2 | cut -d'}' -f1)
  howto_depends=$(echo ${howto_content} | grep heavily-depends-on)
  howto_depends_content=$(echo ${howto_depends} | cut -d'{' -f2 | cut -d'}' -f1)

# then find prepare{} in the howto and trigger it

if [ "$1" = "-i" ]; then
  echo "Preparing the howto..."
  howto_name=$2
  howto_path=/MatuusOS/howto/${howto_name}.howto
  howto_content=$(cat ${howto_path})
  howto_prepare=$(echo ${howto_content} | grep prepare)
  howto_prepare_content=$(echo ${howto_prepare} | cut -d'{' -f2 | cut -d'}' -f1)
  # if there is a prepare{} in the howto, run the prepare{}
  if [ "$howto_prepare_content" != "" ]; then
    echo "Preparing the howto..."
    howto_prepare_content=$(echo ${howto_prepare_content} | sed -e 's/ /\n/g')
    howto_prepare_content_array=(${howto_prepare_content})
    for howto_prepare_content_array_element in ${howto_prepare_content_array[*]}
    do
      echo "Running ${howto_prepare_content_array_element}..."
      ${howto_prepare_content_array_element}
    done
  fi
fi

# then trigger the build{} in the howto

if [ "$1" = "-i" ]; then
  echo "Building the howto..."
  howto_name=$2
  howto_path=/MatuusOS/howto/${howto_name}.howto
  howto_content=$(cat ${howto_path})
  howto_build=$(echo ${howto_content} | grep build)
  howto_build_content=$(echo ${howto_build} | cut -d'{' -f2 | cut -d'}' -f1)
  # if there is a build{} in the howto, run the build{}
  if [ "$howto_build_content" != "" ]; then
    echo "Building the howto..."
    howto_build_content=$(echo ${howto_build_content} | sed -e 's/ /\n/g')
    howto_build_content_array=(${howto_build_content})
    for howto_build_content_array_element in ${howto_build_content_array[*]}
    do
      echo "Running ${howto_build_content_array_element}..."
      ${howto_build_content_array_element}
    done
  fi
fi

# run the install{} in the howto

if [ "$1" = "-i" ]; then
  echo "Installing the howto..."
  howto_name=$2
  howto_path=/MatuusOS/howto/${howto_name}.howto
  howto_content=$(cat ${howto_path})
  howto_install=$(echo ${howto_content} | grep install)
  howto_install_content=$(echo ${howto_install} | cut -d'{' -f2 | cut -d'}' -f1)
  # if there is a install{} in the howto, run the install{}
  if [ "$howto_install_content" != "" ]; then
    echo "Installing the howto..."
    howto_install_content=$(echo ${howto_install_content} | sed -e 's/ /\n/g')
    howto_install_content_array=(${howto_install_content})
    for howto_install_content_array_element in ${howto_install_content_array[*]}
    do
      echo "Running ${howto_install_content_array_element}..."
      ${howto_install_content_array_element}
    done
  fi
fi

# if user inputs -l parameter then show all downloaded howtos

if [ "$1" = "-l" ]; then
  echo "Showing all downloaded howtos..."
  ls /MatuusOS/howto
fi

# if user inputs -c parameter then clear howtos from the /MatuusOS/howto directory

if [ "$1" = "-c" ]; then
  echo "Clearing all downloaded howtos..."
  rm -rf /MatuusOS/howto/*
fi

# if user inputs -s parameter, make a database of howtos that are on the urls that are in mpm.conf and then show what packages are available
if [ "$1" = "-s" ]; then
  echo "Showing all available howtos..."
wget 