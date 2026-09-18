#!/usr/bin/env zsh

import_fileC() {
  for file in $@ ;do
    import_file_args "$file"
  done
}

import_file_args() {
  local fileToImport="${1}"
  fileMakeExecutable-filePaths ${fileToImport}
  source "${fileToImport}" "${@:2}"
}

forget_functionC() {
  for func in $@; do
    unset -f "$func" 2> /dev/null
  done
}

_callAndForget-function-args() {
  "$1" ${@:2}
  forget_functionC $1
}

_callAndForget_functions() {
  # debugLogFunc-args__hsl "$@"
  for func in $@; do
    "$func"
  done
  forget_functionC $@
}

_import_shFilesPaths() {
  # deprecated. Use [import_fileC]

  for file in $@ ;do
    # print "importing [$file]"
    _import_shFile_args "$file"
  done
}

_importFrom-dir-shFileNames() {
  for file in ${@:2} ;do
    _import_shFilesPaths ${1}/${file}
  done
}

fileMakeExecutable-filePaths() {
    chmod +x ${@}
}

_import_shFile_args() {
  # deprecated. Use [import_file_args]

  local fileToImport="${1}.sh"
  fileMakeExecutable-filePaths ${fileToImport}
  source "${fileToImport}" "${@:2}"
}

_unset_functions() {
  # deprecated. Use [forget_functionC]

  for func in $@; do
    unset -f "$func" 2> /dev/null
  done
}

addToShellPath_paths() {
  for _path in ${@}; do
    export PATH="${_path}:$PATH"
  done
}