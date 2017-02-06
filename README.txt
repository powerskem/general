#####################
Project: general
By: Kathleen P Chase
#####################

# For new clone, save existing config files first.
cd ~
cp .bashrc orig.bashrc
cp .profile orig.profile

# Install ssh server for remote access
## ...on Linux
sudo apt-get install openssh-server

# Install git...
## ...on Linux
sudo apt-get install git

# Before cloning project, create a public key.
ssh-keygen
cat ~/.ssh/id-rsa.pub

# Add ssh key to git ssh-agent

# Clone git repo
cd ~/
git init
git remote add origin git@github.com:powerskem/general.git
git pull origin master
