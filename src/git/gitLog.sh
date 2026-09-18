#!/usr/bin/env zsh

_main_gitLog() {  

    gitLog_args() {
        git log --pretty=fuller $@
    }

    gitLogNameStatus-args() {
      gitLog_args --name-status ${@}
    }

    gitLogNameStatusSignature-args() {
      gitLogNameStatus-args --show-signature ${@}
    }
    gl() {
      gitLogNameStatusSignature-args ${@}
    }

    gitLogHeadMovements() {
      git reflog
    }
    grl() {
      gitLogHeadMovements
    }

    gitLogGraph() {
      gitLog_args --graph --decorate --name-status
    }
    glg() {
      gitLogGraph
    }

    gitLogGraphWithAllDetails() {
      gitLog_args --show-signature --all --graph --decorate --name-status
    }
    glga() {
      gitLogGraphWithAllDetails
    }
    
    gitLog_upToCommit_numberOfCommits() {
        local args=${@:3}  
        _gitLogExtract_logRetrieverFunc_upToCommit_numberOfCommits_prefix_postfix \
            gitLogToConsole "$1" "$2" \
                "\`\`\`\n  " \
                "\n\`\`\`  " \
                "$args"
    }

    gitLogShort_upToCommit_numberOfCommits() {
        _gitLogExtract_logRetrieverFunc_upToCommit_numberOfCommits_prefix_postfix \
            gitLogShortToConsole "$1" "$2"
    }
    glsc() {
      gitLogShort_upToCommit_numberOfCommits ${@}
    }


    gitLogHeadline_upToCommit_numberOfCommits() {
        _gitLogExtract_logRetrieverFunc_upToCommit_numberOfCommits_prefix_postfix \
            gitLogHeadlineToConsole "$1" "$2"
    }

    gitLogHeadline_startingFromCommit() {
        if isEmpty_String__i $1 ;then
            print_errorMsg__hsl "Missing 1st Argument – the hash of starting-point commit"
            return 1;
        fi
        gitLogHeadline "$1"^1..
    }
    glha() {
      gitLogHeadline_startingFromCommit ${@}
    }


    gitLogHeadlineToConsole_startingFromCommit() {
        gitLogHeadline_startingFromCommit $@ | trimEndSpaces__i
    }
    glhca() {
      gitLogHeadlineToConsole_startingFromCommit ${@}
    }


    gitLogHeadline() {
        gitLog_format_args "* %s" $@
    }

    gitLogHeadlineToConsole() {
        gitLogHeadline $@ | trimEndSpaces__i
    }

    gitLogShortCopyToClipboard_commit() {
        gitLogCopyToClipboard_logRetrieverFunc_commit "gitLogShort_commit" "$1"
    }
    glscp() {
      gitLogShortCopyToClipboard_commit ${@}
    }


    gitLogCopyToClipboard_commit() {
        gitLogCopyToClipboard_logRetrieverFunc_commit "gitLog_commit" "$1"
    }
    glcp() {
      gitLogCopyToClipboard_commit ${@}
    }


    gitLogCopyToClipboard_logRetrieverFunc_commit() {
        copyToClipboard_args__i "$("$1" "$2")"

        isEmpty_String__i "$2" \
            && local feedbackMessage="Most recent commit info copied to clipboard" \
            || local feedbackMessage="$2 commit info copied to clipboard"

        printSuccessAdding_text__i "$feedbackMessage"
    }

    gitCopyToClipboardInfoOfCommit_howManyCommitsAgo() {
        copyToClipboard_args__i $(gitLogCommit_howManyCommitsAgo $1)
    }

    gitLogCommit_howManyCommitsAgo() {
        gitLog_upToCommit_numberOfCommits "HEAD^$1" 1
    }

    gitLog_commit() {
        gitLog_upToCommit_numberOfCommits "$1" 1
    }

    gitLogShort_commit() {
        gitLogShort_upToCommit_numberOfCommits "$1" 1
    }

    gitLogLatestCommits_count() {
        local args=${@:2} 
        gitLog_upToCommit_numberOfCommits HEAD "$1" "$args"
    }
    glc() {
      gitLogLatestCommits_count ${@}
    }


    gitLogShortLatestCommits_count() {
        gitLogShort_upToCommit_numberOfCommits HEAD "$1"
    }
    glslc() {
      gitLogShortLatestCommits_count ${@}
    }


    gitLogHeadlineLatestCommits_count() {
        gitLogHeadline_upToCommit_numberOfCommits HEAD "$1"
    }
    glhlc() {
      gitLogHeadlineLatestCommits_count ${@}
    }


    gitLogLatestCommit() {
        gitLogLatestCommits_count 1 \-\-stat
    }
    gll() {
      gitLogLatestCommit ${@}
    }


    gitLogShortToConsole_fromCommit() {
        gitLogShort_startingFromCommit $@ | trimEndSpaces__i
    }
    glsca() {
      gitLogShortToConsole_fromCommit ${@}
    }
 # 'a' stays for 'after'

    gitLogShort_startingFromCommit() {
        if isEmpty_String__i $1 ;then
            print_errorMsg__hsl "Missing 1st Argument – the hash of starting-point commit"
            return 1;
        fi
        gitLogShort "$1"^1..
    }
    glsa() {
      gitLogShort_startingFromCommit ${@}
    }
 # 'a' stays for 'after'

    gitLogToConsole() {
        gitLog_args $@ | trimEndSpaces__i
    }

    gitLogShortToConsole() {
        gitLogShort $@ | trimEndSpaces__i
    }

    gitLogShort() {
        local repo_top_level=$(git rev-parse --show-toplevel)
        local repo_name=$(basename $repo_top_level)
        gitLog_format_args "%h  %ad $repo_name  %s" $@
    }
    gls() {
      gitLogShort ${@}
    }


    gitLog_format_args() {
        # debugLogFunc-args__hsl "$@"
        # %h = abbreviated commit hash
        # %x09 = tab (character for code 9)
        # %an = author name
        # %ad = author date (format respects --date= option)
        # %s = subject
        
        # %a – short day of week
        # %b - short month
        gitLog_args --decorate --pretty=format:"$1" --date=format:%H:%M\ %a\ %b\ %d\ %Y ${@:2}
    }

    _gitLogExtract_logRetrieverFunc_upToCommit_numberOfCommits_prefix_postfix() {
        # debugLogFunc-args__hsl "$@"
        local args=${@:6}  
        local gitLogExtract=$($1 -"$3" "$args" "$2")
        if isEmpty_String__i "$3" ;then
            local gitLogExtract=$($1 "$args" "$2")
        else
            local gitLogExtract=$($1 -"$3" "$args" "$2")
        fi
        isEmpty_String__i $gitLogExtract \
            && return 1 \
            || print__i "$4$gitLogExtract$5" | trimEndSpaces__i
    }

    gitLogWithMessagesContain_Text() {
        gitLogToConsole --all --graph --decorate --name-status -i --grep="$1" 
    } 

    gitLogShortGraphWithMessagesContain_Text() {
        gitLogToConsole --all --graph --decorate --oneline -i --grep="$1"  
    }

    gitLogShortWithMessagesContain_Text() {
        gitLogToConsole log --all --oneline -i --grep="$1"  
    }

    #import
    copyToClipboard_args__i() { sysClipboardCopy-args $@; }
    isEmpty_String__i() { isEmpty:string__hsl $@; }
    printSuccessAdding_text__i() { printSuccessOrError-msgit__hsl $@; }
    print__i() { print__hsl $@; }
    trimEndSpaces__i() { trimEndSpaces $@; }
}
_callAndForget_functions _main_gitLog  