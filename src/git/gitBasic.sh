#!/usr/bin/env zsh


git__hsl() {
  git $@
}

gitIndexDirName__hsl() {
  print__hsl ".git"
}

ggpush() {
  git__hsl push --set-upstream origin HEAD ${@}
}

gitConfigGPGEnableSigningByDefault() {
  git config commit.gpgSign true
}

gitConfigSet-signingKeyId__hsl() {
  local signingKey="$1"
  git__hsl config user.signingkey ${signingKey} && \
    printSuccessOrError-msgit__hsl "Key is set to: " && \
    git__hsl config user.signingkey
}

gitUser() {
  git__hsl config user.name
  git__hsl config user.email
}

gitCheckoutToUpdated_branch() {
  git__hsl checkout "$1" && ggpull
}

gitMergeCurrentBranchOnto-sharedBranch-newMergedBranchName_optional() {
  local sourceBranch="$(gitCurrentBranch)"
  local baseBranch=${1}
  local newMergedBranch=$(_nameForNewBranchAfterMerge-sourceBranch-baseBranch-customNewName_optional__hsl \
    ${sourceBranch} ${baseBranch} ${3})
  git__hsl checkout ${baseBranch}
  git__hsl pull origin ${baseBranch} || return $(error__hsl)
  git__hsl checkout ${sourceBranch}
  gitMergeCurrentBranchOnto-localBranch-newMergedBranchName_optional ${baseBranch} ${newMergedBranch}
}

gitMerge-sharedBranchOnto-sharedBranch-newMergedBranchName_optional() {
  local sourceBranch=${1}
  local baseBranch=${2}
  local newMergedBranch=$(_nameForNewBranchAfterMerge-sourceBranch-baseBranch-customNewName_optional__hsl \
    ${sourceBranch} ${baseBranch} ${3})
  git__hsl checkout ${sourceBranch}  
  git__hsl pull origin ${sourceBranch} || return $(error__hsl)
  gitMergeCurrentBranchOnto-sharedBranch-newMergedBranchName_optional ${baseBranch} ${newMergedBranch}
}

grc() { grb --continue ${@} }
grb() { git__hsl rebase ${@} }

gitMergeCurrentBranchOnto-localBranch-newMergedBranchName_optional() {
  local sourceBranch="$(gitCurrentBranch)"
  local baseBranch=${1}
  local newMergedBranch=$(_nameForNewBranchAfterMerge-sourceBranch-baseBranch-customNewName_optional__hsl \
    ${sourceBranch} ${baseBranch} ${3})
  printStarted-scriptName__hsl "Rebasing ${sourceBranch} onto ${baseBranch} and storing result in ${newMergedBranch}"
  git__hsl checkout ${baseBranch}
  git__hsl checkout -b ${newMergedBranch}
  git__hsl checkout ${sourceBranch}
  git__hsl rebase ${newMergedBranch} || gitStatus
  gitLogLatestCommits_count 1
  git__hsl checkout ${newMergedBranch}
  git__hsl merge ${sourceBranch}
}

gs() {
  gitStatus ${@}
}; gitStatus() {
  git__hsl status ${@}
}

_nameForNewBranchAfterMerge-sourceBranch-baseBranch-customNewName_optional__hsl() {
  local sourceBranch=${1}
  local baseBranch=${2}
  local customNewName_optional=${3}
  if ! isEmpty:string__hsl ${customNewName_optional} ;then
    print__hsl ${customNewName_optional}
  else
    # newMergedBranch="${merged}-${sourceBranch}-on-${baseBranch}-$(timestamp__hsl)"
    print__hsl "merged-${sourceBranch}-__on__-${baseBranch}"
  fi
}

gitListStaged() {
    git__hsl diff --name-status --cached | cat
}

ggpull() {
    git__hsl pull --rebase --no-edit origin $(gitCurrentBranch)
}

gitSshSetKey_privateKeyFile() {
    git__hsl config core.sshCommand "ssh -i $1"
}

gitCurrentBranch() {
  local ref=$(git__hsl symbolic-ref --quiet HEAD 2> /dev/null)
	local ret=$?
	if [[ $ret != 0 ]] ;then
		[[ $ret == 128 ]] && return
		ref=$(git__hsl rev-parse --short HEAD 2> /dev/null) || return
	fi
	echo ${ref#refs/heads/}
}

gitDiffUncommittedChanges_args() {
  git__hsl difftool --no-prompt ${@}
}