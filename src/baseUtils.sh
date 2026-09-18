
version__hsl() {
  print__hsl "10.1.32.260615"
  print__hsl "HmnShellLib__hsl"
}

doc__hsl() {
  # Does nothing currently
  
  # Used for making source-code docs to be part of the source code itself (like in Python). 
  # We can inspect the calling stack and forward it to a dedicated file along with 
  # the arguments, in machine- or human-readable formats.  
  # It's also handy to have docs written within a function's lexical scope, so they are 
  # folded/unfolded and moved/deleted together with the function.
}

yes__hsl() {
  ## Logical "yes"
  
  print__hsl 0
}

no__hsl() {
  ## Logical "no"
  
  print__hsl 20211201
}

isLastCommandSucceed__hsl() {
  if [[ $? -eq 0 ]] ;then
    return $(yes__hsl)
  else
    return $(no__hsl)
  fi
}

isCommandExist-command() {
  command -v "$1" >/dev/null 2>&1 && return $(yes__hsl) || return $(no__hsl)
}

error__hsl() {
  ## General error
  
  print__hsl 20220516
}

trimEndSpaces() {
  sed 's/ *$//g'
}

is-substringOf-string() {
  if test "${2#*$1}" != "$2" ;then
    return $(yes__hsl)
  else
    return $(no__hsl)
  fi
}

is-stringStartsWith-prefix() {
  [[ ${1} = ${2}* ]] && return $(yes__hsl) || return $(no__hsl)
}

is-stringEndsWith-postfix() {
  [[ ${1} = *${2} ]] && return $(yes__hsl) || return $(no__hsl)
}

is-stringEqualTo-string() {
  [[ ${1} = ${2} ]] && return $(yes__hsl) || return $(no__hsl)
}

isEmpty:string__hsl() {
  [[ -z $1 ]] && return $(yes__hsl) || return $(no__hsl)
}

filterNotIncludingAfter-spitterStr() {
    sed -e '/'"$1"'/,$d'
}

filterLinesThatStartWith-prefixStr() {
    sed -e '/^'"$1"'/d'
}

useWithCaution() {
  local e=${?}
  print "__useWithCaution"
  return ${e}
}

isShellSupported__hsl() {
  [ -z "${ZSH_NAME}" ] && return $(no__hsl) || return $(yes__hsl)
}

abortBecauseOf-reason-timeoutSec__hsl() {
  print "${1}\nKILLING this process in ${2} seconds"
  sleep ${2}
  exit 260710
}

isExecutedFromAnotherScript() {
  isEmpty:string__hsl ${funcstack[3]} \
    && return $(no__hsl) \
    || return $(yes__hsl)
}

userLibraryDir() {
  print__hsl "$(userHomeDir)/Library"
}

userPrefsDir() {
  print__hsl "$(userLibraryDir)/Preferences"
}

userHomeDir() {
  print__hsl "/Users/$(whoami)"
}

userDesktopDir() {
  print__hsl "$(userHomeDir)/Desktop"
}

userAppsDir() {
  print__hsl "$(userHomeDir)/Applications"
}

userTrashDir() {
  print__hsl "$(userHomeDir)/.Trash"
}

edit__hsl() {
  "${EDITOR}" "${@}"
}

tempDir__hsl() {
  print__hsl "/Users/$(whoami)/.zZshFramework/temp"
}

stacktrace-offset__hsl() {
  local offset=${1}
  ((offset+=2))
  local stacktrace="\n  [$funcstack[${offset}]"
  if true ;then
    local last=${#funcstack[@]}
    for (( i=((offset+=1)); i<=${last}; i++ )); do
      stacktrace+="\n    <- ${funcstack[${i}]}"
    done
  fi
  print "${stacktrace}]\n"
}

print__hsl() {
  print ${@}
}

return__hsl() {
  doc "Denotes returning the value rather than general printing out"
  print__hsl ${@}
}

printWithRedHighlights-args__hsl() {
  local itemsToMakeRed=(\
    "error" "Error" "ERROR" "ERR" \
    "fail" "Fail" "FAIL" \
    "fatal" "Fatal" "FATAL" \
    "exception" "Exception" "EXCEPTION")
  local result=""
  for line in ${@} ;do
    local coloredSubstring="${line}"
    for match in ${itemsToMakeRed} ;do
      coloredSubstring=${coloredSubstring//${match}/$fg_bold[red]${match}$reset_color}
    done
    result+="${coloredSubstring}"
  done
  print__hsl ${result}
}

_basePrintingFunction__hsl() {
  printf ${@}
}

printStarted-scriptName__hsl() {
  print-headline-message__hsl "STARTED ${1}"
}

printFinished-scriptName__hsl() {
  print__hsl "FINISHED: " "$1"
}

printSuccessOrError-msgit__hsl() {
  isLastCommandSucceed__hsl && print__hsl "SUCCESS: " "$1" || print_errorMsg__hsl "$1"
}

print_errorMsg__hsl() {
  print__hsl "ERROR in $(stacktrace-offset__hsl 1)" "$1"
}

print-exceptionMessage__hsl() {
  print__hsl "EXCEPTION: " "$1"
}

print-warningMessage__hsl() {
  print__hsl "WARNING: " "$1"
}

print-headline-message__hsl() {
  local prefix="\n>>>>>>>>>>>>>>>>>> $1"
  local subject="$2"
  isEmpty:string__hsl $subject \
    && print__hsl "$prefix" \
    || print__hsl "$prefix\n$subject"
}

argsOrPipeIn-args__hsl() {
  local input
  input=$(if isEmpty:string__hsl ${@} ;then \
      read -r -d '' -t $(_inputWaitingTimeout__hsl) inputPipe
      print__hsl "${inputPipe}"
      return $(no__hsl)
    else
      print__hsl ${@}
      return $(yes__hsl)
    fi)
  local e=$?
  print__hsl "${input}"
  return $e
}

pipeInOrArgs-args__hsl() {
  local input=$(read -r -d '' -t $(_inputWaitingTimeout__hsl) inputPipe; print__hsl "${inputPipe}")
  if isEmpty:string__hsl ${input} ;then
    print__hsl ${@}
    return $(no__hsl)
  else
    print__hsl ${input}
    return $(yes__hsl)
  fi
}

_inputWaitingTimeout__hsl() {
  print__hsl 1
}