# To the extent possible under law, the author(s) have dedicated all 
# copyright and related and neighboring rights to this software to the 
# public domain worldwide. This software is distributed without any warranty. 
# You should have received a copy of the CC0 Public Domain Dedication along 
# with this software. 
# If not, see <http://creativecommons.org/publicdomain/zero/1.0/>. 

# base-files version 4.2-4

# ~/.bash_profile: executed by bash(1) for login shells.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.bash_profile

# Modifying /etc/skel/.bash_profile directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bash_profile) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benifitial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bash_profile file
# .bash_profile

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

# Set PATH so it includes user's private bin if it exists
 if [ -d "${HOME}/bin" ] ; then
   PATH="${HOME}/bin:${PATH}"
 fi

export PATH

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi


#  from http://www.thegeekstuff.com/2010/03/introduction-to-bash-scripting/...
#  "...when the bash is invoked as an interactive shell, it first reads and executes commands from /etc/profile. If /etc/profile doesn’t exist, it reads and executes the commands from ~/.bash_profile, ~/.bash_login and ~/.profile in the given order."
hname=`hostname`
echo "Welcome on $hname."

export PATH=/usr/local/bin:$PATH

echo -e "Kernel Details: " `uname -smr`
echo -e "`bash --version`"
echo -ne "Uptime: "; uptime
echo -ne "Server time : "; date

#  lastlog | grep "root" | awk {'print "Last login from :"$3

#  print "Last Login Date & Time: ",$4,$5,$6,$7,$8,$9;}'
