#!/usr/bin/env zsh

main__zZshFramework_srcDir() {
  local d=${1}
  source "$d/baseUtils.sh"
  ! isShellSupported__hsl && abortBecauseOf-reason-timeoutSec__hsl "Current shell is NOT supported. This framework runs properly on zsh only." 5
  
  source "${v}/import.sh"
  _import_shFilesPaths \
    "${d}/printer" \
    "${d}/debug" \
    "${d}/inputReader" \
    "${d}/beta" \
    "${d}/clipboard" \
    "${d}/files" \
    "${d}/networking" \
    "${d}/docker" \
    "${d}/java" \
    "${d}/gpg" \
    "${d}/homebrew" \
    "${d}/shell" \
    "${d}/iOS" \
    "${d}/git/gitLog" \
    "${d}/git/gitHooks" \
    "${d}/git/gitBasic" \
    "${d}/android/android" \
    "${d}/android/macOS-android"
}

main__zZshFramework_srcDir "$(dirname "${BASH_SOURCE[0]}")"
forget_functionC main__zZshFramework_srcDir