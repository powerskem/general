## from http://www.thegeekstuff.com/2010/03/introduction-to-bash-scripting/...
## "...when the bash is invoked as an interactive shell, it first reads and executes commands from /etc/profile. If /etc/profile doesn’t exist, it reads and executes the commands from ~/.bash_profile, ~/.bash_login and ~/.profile in the given order."
hname=`hostname`
echo "Welcome on $hname."

export PATH=/usr/local/bin:$PATH
