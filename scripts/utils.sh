#!/usr/bin/env bash

if [ -t 1 ]; then
  _RED="$(tput setaf 1 2>/dev/null || true)"
  _GREEN="$(tput setaf 2 2>/dev/null || true)"
  _YELLOW="$(tput setaf 3 2>/dev/null || true)"
  _CYAN="$(tput setaf 6 2>/dev/null || true)"
  _GRAY="$(tput setaf 8 2>/dev/null || true)"
  _RESET="$(tput sgr0 2>/dev/null || true)"
  _BOLD="$(tput bold 2>/dev/null || true)"
else
  _RED=""; _GREEN=""; _YELLOW=""; _CYAN=""; _GRAY=""; _RESET=""; _BOLD=""
fi

log_info()  { printf "%s→%s %s\n" "$_CYAN" "$_RESET" "$*"; }
log_ok()    { printf "%s%s✓%s %s\n" "$_GREEN" "$_BOLD" "$_RESET" "$*"; }
log_skip()  { printf "%s- %s%s\n" "$_GRAY" "$*" "$_RESET"; }
log_warn()  { printf "%s!%s %s\n" "$_YELLOW" "$_RESET" "$*"; }
log_error() { printf "%s%s✗%s %s\n" "$_RED" "$_BOLD" "$_RESET" "$*" >&2; }

command_exists() { command -v "$1" &>/dev/null; }
