#!/bin/bash

function guard_root() {
  if [ "$(id -u)" != "0" ]; then
      echo "This script requires root privileges. Please run it as root."
      exit 1
  fi
}

function continue_wait() {
  echo $1
  echo "Continue? Pres any key. Ctrl+C to exit"
  read userInput
}
