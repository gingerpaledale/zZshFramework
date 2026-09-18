#!/usr/bin/env zsh

_main_beta-sourceDir() {
#    debugLogFunc-args__hsl {$@}
  local srcDir="$1"

  sysWifiListNetworks() {
    /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
  }

  _print-fileExcludingLinesThatStartWith-character__hsl() {
    cat "$1" | sed -e '/^'"$2"'/d'
  }

  #/* 2023-02-08 21:10:02 TODO: @VladZams: Implementation */
  timestamp__hsl() {
    print_errorMsg__hsl "NOT implemented"
    return $(error__hsl)
  }

  calculate() {
    print__hsl $((${@}))
  }
  # clcl() {
  #   calculate ${@} | sysClipboardCopyVerbose-args
  # }

  isUnixOS() {
    local OS="$(uname)"
    if [[ "${OS}" == "Linux" || "${OS}" == "Darwin" ]] ;then
      return $(yes__hsl)
    else
      return $(no__hsl)
    fi
  }

  #/**
  #* https://stackoverflow.com/questions/9964823/how-to-check-if-a-file-is-empty-in-bash/9964890
  #* 2021-12-01 12:03:02 TODO: @DexHo:  Unit test */
  #*/ 
  isEmpty-file() {
    if [[ -s $1 ]] ;then
      return $(no__hsl)
    else 
      return $(yes__hsl)
    fi
  }
  
  askUserFor-file() {
    local requiredFile="$1"
    while ! [[ -a ${requiredFile} ]] ;do
      print__hsl "Add [${requiredFile}] file and press Enter to continue..."
      read -k1 -s
    done
  }

  sysProcessId() {
    print__hsl \[$$\]
  #   # ps  -ef | grep $$ | grep -v grep
    # print without parent-process ID
  }
}
_callAndForget-function-args _main_beta-sourceDir $(dirname $0)