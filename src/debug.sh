#!/usr/bin/env zsh

debugLogFile__hsl() {
  print__hsl "$(userHomeDir)/.zZshFramework.log"
}

debugConsoleTurnON() {
  export $(_debugConsoleFlagit__hsl)="YES"
  debugPrintEnabledStatus_hsl
}

debugConsoleTurnOFF() {
  export $(_debugConsoleFlagit__hsl)="NO"
  debugPrintEnabledStatus_hsl
}

isDebugConsoleEnabled__hsl() {
  is-substringOf-string "YES" ${(P)$(_debugConsoleFlagit__hsl)} && return $(yes__hsl) || return $(no__hsl)
}

debugPrintEnabledStatus__hsl() {
  isDebugConsoleEnabled__hsl && print__hsl "DEBUG is ON" || print__hsl "DEBUG is OFF"
}

debugLogFunc-args__hsl() {
  local argsInfo=""
  for i in {1.."${#@[@]}"}; do
    ! isEmpty:string__hsl ${@[$i]} && argsInfo+="[arg $i [${@[$i]}]]\n"
  done
  debugLog-offset-msgit__hsl 1 "Entered func [$funcstack[2]]\n${argsInfo}"
}

debugCleanLogFile__hsl() {
  fileMoveToTrash-filePaths "$(debugLogFile__hsl)"
  debugLogit__hsl "Cleaned log"
}

debugLog-offset-msgit__hsl() {
  local msg="${@:2}\n  stacktrace: $(stacktrace-offset__hsl $((${1}+1)))"
  filePrepareDirAt-path $(fileBasePartOf:Path $(debugLogFile__hsl))
  print__hsl "\n[# $(date)\n${msg}]" >> "$(debugLogFile__hsl)"
  isDebugConsoleEnabled__hsl && print__hsl "\n[${msg}\n]"
}

debugLogit__hsl() {
  debugLog-offset-msgit__hsl 1 ${@}
}

debugEditLogFile__hsl() {
  edit__hsl "$(debugLogFile__hsl)"    
}

_debugConsoleFlagit__hsl() {
  print__hsl "_debugConsoleFlagValue_hsl"
}