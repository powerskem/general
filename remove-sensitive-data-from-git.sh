#!/bin/bash
# ##################################################
#
version="0.01"              # Sets version variable
#
# HISTORY:
#
# * 12/2/2016 - v0.1  - First Creation
#
# USAGE: ./remove-sensitive-data-from-git.sh [OPTIONS] name_of_sensitive_file
#
# ##################################################

# Immediately exit if any cmd has non-zero exit status
set -e

# Immediately exit if ref to any var not previously
# defined - with the exceptions of $* and $@
set -u

# If any cmd in a pipeline fails, use that return code
# as the return code of the whole pipeline
set -o pipefail

# Set Internal Field Separator
IFS=$'\n\t'

# ##################################################

# ------------------------------------------------------
# Set Colors
# ------------------------------------------------------
export TERM=xterm

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
ltblue=$(tput setaf 6)
white=$(tput setaf 7)

# ##################################################
# Hat tip:
# utils are from https://github.com/natelandau/shell-scripts/
# ##################################################

# ------------------------------------------------------
# Traps - These functions are for use with trap scenarios
# Non destructive exit for when script exits naturally.
# Usage: Add this function at the end of every script
# ------------------------------------------------------

function safeExit() {
  # Delete temp files, if any
  debug "Checking ${tmpDir} before deleting..."
  if is_dir "${tmpDir}"; then
    debug "Removing temporary directory"
    rm -r "${tmpDir}"
    if is_exists "${tmpDir}"; then
      warning "Could not remove $tmpDir"
    fi
  else
    warning "${tmpDir} is not a directory or doesn't exist"
  fi
  trap - INT TERM EXIT
  exit
}


# ------------------------------------------------------
# File Checks - A series of functions which make checks 
# against the filesystem. For use in if/then statements.
#
# Usage:
#    if is_file "file"; then
#       ...
#    fi
# ------------------------------------------------------

function is_exists() {
  if [[ -e "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_exists() {
  if [[ ! -e "$1" ]]; then
    return 0
  fi
  return 1
}

function is_file() {
  if [[ -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_file() {
  if [[ ! -f "$1" ]]; then
    return 0
  fi
  return 1
}

function is_dir() {
  if [[ -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_dir() {
  if [[ ! -d "$1" ]]; then
    return 0
  fi
  return 1
}

function is_symlink() {
  if [[ -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_symlink() {
  if [[ ! -L "$1" ]]; then
    return 0
  fi
  return 1
}

function is_empty() {
  if [[ -z "$1" ]]; then
    return 0
  fi
  return 1
}

function is_not_empty() {
  if [[ -n "$1" ]]; then
    return 0
  fi
  return 1
}

# ------------------------------------------------------
# Alert functions
# ------------------------------------------------------

function _alert() {
  set +x

  if [ "${1}" = "emergency" ]; then local color="${bold}${red}"; fi
  if [ "${1}" = "error" ]; then local color="${bold}${red}"; fi
  if [ "${1}" = "warning" ]; then local color="${yellow}"; fi
  if [ "${1}" = "info" ] || [ "${1}" = "notice" ]; then local color="${bold}"; fi
  if [ "${1}" = "debug" ]; then local color="${purple}"; fi
  if [ "${1}" = "success" ]; then local color="${green}"; fi
  if [ "${1}" = "input" ]; then local color="${bold}"; printLog="false"; fi
  if [ "${1}" = "header" ]; then local color="${bold}""${yellow}"; fi
  # Don't use colors on pipes or non-recognized terminals
  if [[ "${TERM}" != "xterm"* ]] || [ -t 1 ]; then color=""; reset=""; fi
  # Print to $logFile
  if [[ ${printLog} = "true" ]] || [ "${printLog}" == "1" ]; then
    echo -e "$(date +"%Y-%m-%d %H:%M:%S.%3N") $(printf "[%9s]" "${1}") ${_message}" >> "${logFile}";
  fi
  # Print to console when script is not 'quiet'
  if [[ "${quiet}" = "true" ]] || [ "${quiet}" == "1" ]; then
   return
  else
   echo -e "$(date +"%Y-%m-%d %H:%M:%S.%3N") ${color}$(printf "[%9s]" "${1}") ${_message}${reset}";
  fi

  if [ "${debug}" == "1" ]; then
    set -x; # Print commands and their arguments as they are executed
  fi

}

function die ()       { local _message="${*} Exiting."; echo "$(_alert emergency)"; safeExit; }
function error ()     { local _message="${*}"         ; echo "$(_alert error)"; }
function warning ()   { local _message="${*}"         ; echo "$(_alert warning)"; }
function info ()      { local _message="${*}"         ; echo "$(_alert info)"; }
function notice ()    { local _message="${*}"         ; echo "$(_alert notice)"; }
function debug ()     { local _message="${*}"         ; echo "$(_alert debug)"; }
function success ()   { local _message="${*}"         ; echo "$(_alert success)"; }
function input()      { local _message="${*}"         ; echo "$(_alert input)"; }
function header()     { local _message="========== ${*} ==========  "; echo "$(_alert header)"; }

function trapCleanup() {
  if is_dir "${tmpDir}"; then
    rm -r "${tmpDir}"
  fi
  die "Exit trapped."
}

# ##################################################
# ##################################################
# 
# SETUP...
# 
# -----------------------------------
# Flags which can be overridden by user input.
# Default values are below
# -----------------------------------
quiet=0
printLog=0
verbose=0
force=0
debug=0
args=()

# Setting script and path variables
#scriptPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
scriptName=$(basename "$0")
scriptBasename="$(basename ${scriptName} .sh)" # Strips '.sh' from scriptName

# -----------------------------------
# Log is only used when the '-l' flag is set.
# -----------------------------------
logFile="$HOME/${scriptBasename}.log"

# -----------------------------------
# Create temp directory with three random numbers and the process ID
# in the name.  This directory is removed automatically at exit.
# -----------------------------------
tmpDir="/tmp/${scriptName}.$RANDOM.$RANDOM.$RANDOM.$$"

debug "Creating temporary directory at ${tmpDir}"
(umask 077 && mkdir "${tmpDir}") || {
  die "Could not create $tmpDir"
}

debug "checking for vars"
[ $# -gt 0  ] || {
die "No args provided."
}

# ##################################################
# ##################################################
# ##################################################

function mainScript() {

####################################################
############## Begin Script Here ###################
####################################################

header "Starting mainScript of ${scriptName}"

#-----------------------------------

#TODO calculate the date
dbdate="$(date +%Y-%m-%d_%H%Mhrs)"

for name_of_sensitive_file in "${args[@]}"; do
  debug "Processing: ${name_of_sensitive_file}"

    info "Copying ${name_of_sensitive_file} to ${name_of_sensitive_file}.save"
    cp ${name_of_sensitive_file} ${name_of_sensitive_file}.save

    info "Removing ${name_of_sensitive_file} from local git history..."
    git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch ${name_of_sensitive_file}' --prune-empty --tag-name-filter cat -- --all

    info "Pushing changes to git repo..."
    git push origin --force --all
done

echo -e "\n\n"

####################################################
############### End Script Here ####################
####################################################
}
# ##################################################
# ##################################################
# Print usage
usage() {
  echo -n "${scriptName} [OPTIONS] name_of_sensitive_file

 Options:
  --force           Skip all user interaction.  Implied 'Yes' to all actions.
  -q, --quiet       Quiet (no output)
  -l, --log         Print log to file
  -v, --verbose     Output more information. (Items echoed to 'verbose')
  -d, --debug       Runs script in BASH debug mode (set -x)
  -h, --help        Display this help and exit
      --version     Output version information and exit
  --                End options
"
}
# ##################################################

# Iterate over options breaking -ab into -a -b when needed and --foo=bar into
# --foo bar
optstring=h
unset options

while (($#)); do
  case $1 in
    # If option is of type -ab
    -[!-]?*)
      # Loop over each character starting with the second
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}
        debug "c = ${c}"

        # Add current char to options
        options+=("-$c")

        # If option takes a required argument, and it's not the last char make
        # the rest of the string its argument
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;

    # If option is of type --foo=bar
    --?*=*)
      options+=("${1%%=*}" "${1#*=}") ;;
    # add --endopts for --
    --)
      options+=(--endopts) ;;
    # Otherwise, nothing special
    *) 
      arguments+=("$1")
      options+=("$1") 
      ;;
  esac
  shift
done

set -- "${options[@]}"
unset options

#-----------------------------------
#Check for mandatory vars
#echo "$@"
#if [ ($@) == "" ]; then
  #usage >&2; safeExit
#fi
#-----------------------------------
# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help)
      usage >&2; safeExit ;;
    --version)
      echo "$(basename $0) ${version}"; safeExit ;;
    -v|--verbose)
      verbose=1 ;;
    -l|--log)
      printLog=1 ;;
    -q|--quiet)
      quiet=1 ;;
    -d|--debug)
      debug=1;;
    --force)
      force=1 ;;
    --endopts)
      shift; break ;;
    *)
      die "invalid option: '$1'." ;;
  esac
  shift
done

if [ "${debug}" == "1" ]; then
  set -x; # Print commands and their arguments as they are executed
fi

# Store the remaining part as arguments.
args+=("$@")

if [ "${#args[@]}" = "0" ]; then
  usage; safeExit
fi

# ##################################################
# ##################################################

trap trapCleanup EXIT INT TERM # Trap bad exits

mainScript # Run main script

safeExit # Exit cleanly
# ##################################################
# ##################################################

