#!/bin/bash
# colors_and_formatting.sh
# 
#  Modified: 4/27/2017 By: K.P.Chase
# Original Author: Sam Hocevar
#
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fxxx You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

#Background
#for clbg in {40..47} {100..107} 49 ; do
clbg=49
  #Foreground
  for clfg in {30..37} {90..97} 39 ; do
    #Formatting
    #for attr in 0 1 2 4 5 7 ; do
    #for attr in 1 2 4 5 7 8 ; do #KPC 0-unkn 1-bold 2-dim 4-UL 5-blink 7-reverse 8-hide
    attr=1
      #Print the result
      echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
    #done
    echo #Newline
  done
#done

exit 0

