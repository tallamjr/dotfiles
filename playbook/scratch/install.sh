#!/bin/bash
clear
cd

# Ensure Apple's command line tools are installed
if ! command -v cc > /dev/null; then
  echo "Installing xcode ..."
  xcode-select --install
else
  echo "Xcode already installed. Skipping."
fi

if ! command -v brew > /dev/null; then
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Homebrew already installed. Skipping."
fi

# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible > /dev/null; then
  echo "Installing Ansible ..."
  brew install ansible
else
  echo "Ansible already installed. Skipping."
fi

brew isntall git

# Clone the repository to your local drive.
if [ -d "./macOS-playbook" ]; then
  echo "Playbook repo dir exists. Removing ..."
  rm -rf ./macOS-playbook/
fi
echo "Cloning masOSplaybook repo ..."
git clone https://github.com/tallamjr/macOS-playbook.git

echo "Changing to laptop repo dir ..."
cd macOS-playbook

# echo "Installing ansible playbook requirements ..."
# ansible-galaxy install -r requirements.yml
# Run this from the same directory as this README file.
echo "Running ansible playbook ..."
ansible-playbook playbook.yml -i HOSTS -K -v
