#!/usr/bin/env zsh

sysClipboardCopyVerbose-args() {
  local input=$(argsOrPipeIn-args__hsl ${@})
  if isEmpty:string__hsl ${input} ;then
    return 0
  else
    sysClipboardCopyRemovingLinebreaks-args "${input}"
    printSuccessOrError-msgit__hsl "${input}\nis copied to clipboard"
  fi
}

sysClipboardCopy-args() {
    local input=$(argsOrPipeIn-args__hsl ${@})
    sysClipboardCopy-isRemovingLinebreaks-args false "${input}"
}

sysClipboardCopyRemovingLinebreaks-args() {
    local input=$(argsOrPipeIn-args__hsl ${@})
    sysClipboardCopy-isRemovingLinebreaks-args true "${input}"
}

sysClipboardCopy-isRemovingLinebreaks-args() {
    local isRemovingLinebreaks="$1"
    local file="${@:2}"
    if [[ $OSTYPE == darwin* ]] ;then
      if [[ -z $file ]]; then
        pbcopy
      else
        if $isRemovingLinebreaks ;then
          print__hsl "$file" | tr -d '\n' | pbcopy
        else
          print__hsl "$file" | pbcopy
        fi
      fi
    elif [[ $OSTYPE == cygwin* ]] ;then
      if [[ -z $file ]]; then
        print__hsl > /dev/clipboard
      else
        print__hsl "$file" > /dev/clipboard
      fi
    else
      if (( $+commands[xclip] )) ;then
        if [[ -z $file ]]; then
          xclip -in -selection clipboard
        else
          xclip -in -selection clipboard "$file"
        fi
      elif (( $+commands[xsel] )) ;then
        if [[ -z $file ]]; then
          xsel --clipboard --input
        else
          print__hsl "$file" | xsel --clipboard --input
        fi
      else
        print__hsl "systemCopyToClipboard: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
        return 1
      fi
    fi
}