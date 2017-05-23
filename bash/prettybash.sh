#!/usr/bin/bash
#
# prettybash.sh
#
# K. P. Chase
#
################

trap cleanup SIGINT SIGTERM

function cleanup() {
    echo -ne "\e[${NROWS};1fDONE"
    #sleep 2 ; wait $!
    #displaymap
    #sleep 2 ; wait $!
    exit 0
}

function initmap() {
    for ii in $(seq 1 $NROWS) ; do
        for jj in $(seq 1 $NCOLS) ; do
            map[$ii,$jj]=' '
        done
    done
}

function displaymap() {
    for ii in $(seq 1 $NROWS) ; do
        #echo -e "\r"
        for jj in $(seq 1 $NCOLS) ; do
            echo -ne "${map[$ii,$jj]}"
            echo -ne "\e[${ii};${jj}f${map[$ii,$jj]}"
        done
    done
}

function genrandom() {
# Generates uniformly distributed random numbers between startn and stopn (inclusive)
    startn=$1
    stopn=$2
    num=$(echo "( $RANDOM * ($stopn - $startn + 1 ) / 32767 ) + $startn"|bc)
    echo -ne "$num"
}

function paintchar() {
    character="X"
    character=$1
    rr=$2
    cc=$3
    clfg=$4

    attr=1
    clbg=49 ; #clbg=$(genrandom 40 47)

    map[$rr,$cc]="\e[${attr};${clbg};${clfg}m${character}\e[0m"
    echo -ne "\e[${rr};${cc}f${map[$rr,$cc]}"
}

function movelocn() {
    rloc=$(genrandom $(echo "$rloc -1"|bc) $(echo "$rloc +1"|bc))
    if [[ $rloc -lt 1 ]] ; then
        rloc=1
    fi
    if [[ $rloc -gt $NROWS ]] ; then
        rloc=$NROWS
    fi

    cloc=$(genrandom $(echo "$cloc -1"|bc) $(echo "$cloc +1"|bc))
    if [[ $cloc -lt 1 ]] ; then
        cloc=1
    fi
    if [[ $cloc -gt $NCOLS ]] ; then
        cloc=$NCOLS
    fi
}

function movecolr() {
    color=$(genrandom $(echo "$color -1"|bc) $(echo "$color +1"|bc))
    if [[ $color -lt 30 ]] ; then
        color=30
    fi
    if [[ $color -gt 37 ]] ; then
        color=37
    fi
}

# ================== MAIN ROUTINE ==================
clear
NROWS=$(tput lines)
NCOLS=$(tput cols)

declare -A map

initmap

rloc=$(genrandom 1 $NROWS)
cloc=$(genrandom 1 $NCOLS)
color=$(genrandom 30 37)

while [ 1 ] ; do
    paintchar o $rloc $cloc $color
    movelocn
    movecolr
    #rloc=$(genrandom 1 $NROWS)
    #cloc=$(genrandom 1 $NCOLS)

    sleep 0.002 ; wait $!
done
