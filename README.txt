#####################
Project: general
By: Kathleen P Chase
#####################

# Install ssh server for remote access
## ...on Linux
sudo apt-get install openssh-server

# Install git...
## ...on Linux
sudo apt-get install git

# Before cloning project, create a public key.
ssh-keygen
cat ~/.ssh/id_rsa.pub

# Add ssh key to git ssh-agent

# Clone git repo
cd ~/
git init
git remote add origin git@github.com:powerskem/general.git
git pull origin master

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

git config --global push.default matching

# ?? git branch --set-upstream-to=origin/master master

git push --set-upstream origin master
