_main_gpg-sourceDir() {
  # debugLogFunc-args__hsl {$@}
  local srcDir="$1"

  gpgSetupGuideForGithub() {
    print__hsl gpgGenerateKey
    print__hsl gpgCopyExportedKeyToClipboard-keyId
    print__hsl paste the key to GitHub web GUI
    print__hsl gitConfigSet-signingKeyId
    print__hsl For troubleshooting see "https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key"
  }
  
  gpgGenerateKey__hsl() {
    # https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
    if ! isCommandExist-command gpg ;then
      print-errorMessage "gpg not found"
      return $(error__hsl)
    fi
    $(_gpgCommand__hsl) --default-new-key-algo rsa4096 --gen-key
    $(_gpgCommand__hsl) --list-secret-keys --keyid-format=long
  }

  gpgPrintExported-keyId__hsl() {
    $(_gpgCommand__hsl) --armor --export ${1}
  }

  gpgCopyExportedKeyToClipboard-keyId__hsl() {
    local keyId=${1}
    sysClipboardCopy-args "$(gpgPrintExported-keyId__hsl ${keyId})"
  }

  gpgListKeys__hsl() {
    $(_gpgCommand__hsl) --list-secret-keys --keyid-format=long
  }

  _gpgCommand__hsl() {
    print__hsl "gpg"
  }
}
_callAndForget-function-args _main_gpg-sourceDir $(dirname $0)