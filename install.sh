#!/bin/bash

PATH_TO_FILE="$(cd `dirname $0` && pwd)";
export		RED="[0;31m"
export		GREEN="[0;32m"
export		DEFAULT="[0;39m"

# Pry 
if which pry >/dev/null; then
  rm -rf ~/.pryrc
  ln -s ${PATH_TO_FILE}/pryrc ~/.pryrc
else
  echo "${RED}Attention: ${DEFAULT} Pry not found"
fi 
