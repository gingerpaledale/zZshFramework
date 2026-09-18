#!/usr/bin/env zsh

gitHookAddBranchNameInsertionHookToCurrentRepo() {
  if ! isFileExistAt-path ".git" ;then
    print_errorMsg__hsl "Running NOT within git_repo directory"
    return 1
  fi
  fileCopy-source-destination "$(dirname "${BASH_SOURCE[0]}")/hooks/commit-msg" "./.git/hooks/"
}