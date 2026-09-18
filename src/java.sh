
javaHomeDir__hsl() {
  /usr/libexec/java_home
}

javaHomeCopyPathToClipboard() {
  if isCommandExist-command java ;then
    sysClipboardCopyVerbose-args $(javaHomeDir__hsl)
  else
    print-errorMessage "java not installed"
    return $(error__hsl)
  fi
}