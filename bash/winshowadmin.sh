#!/usr/bin/bash
# obtained from http://superuser.com/a/722943
# attributed to user Steven

# make the cygwin terminal look different when running as administrator
#
# add "source winshowadmin.sh" to the .bashrc file when on cygwin

# Set a white $ initially
eStyle='\[\e[0m\]$'

# If 'at' succeeds, use a red # instead
at &> /dev/null && eStyle='\[\e[0;31m\]#\[\e[0m\]'  # Use # in red

PS1='\n\[\e[0;32m\]\u@\h \[\e[0;33m\]\w\[\e[0m\]\n'"$eStyle "

