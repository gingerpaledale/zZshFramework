#!/usr/bin/env zsh

_main_FilesOperations() {  

    fileRemoveWithOverwrite-dirOrFile$(useWithCaution)__hsl() {
      chmod -R u+w ${1} && \
        find ${1} -type f -exec shred --remove=wipe {} + && rm -r ${1}
    }

    fileFind_name() {
      find . -name "$1"
    }

    fileFind_name_inDir() {
      find "$2" -name "$1"
    }
    
    fileSizeOf:File() {
      du -sh "$1" 2>/dev/null
    }

    sync_srcDir_targetDir() {
      local srcDir=$(fileAbsolutePathOf:File "$1")
      local targetDir=$(fileAbsolutePathOf:File "$2")
      rsync -r -v --delete "$srcDir/" "$targetDir/"
    }

    sync_srcRepoDir_targetRepoDir() {
      local srcDir=$(fileAbsolutePathOf:File "$1")
      local targetDir=$(fileAbsolutePathOf:File "$2")
      
      rsync -r --delete --exclude='/.git' \
        --exclude='*.iml' \
        --exclude-from="$srcDir/.gitignore" \
        "$srcDir/" "$targetDir/"
    }

    fileLink_link_src() {
      local link="${1}"
      local src="${2}"
      filePrepareDirAt-path "$(fileBasePartOf:Path "${link}")"
      fileMoveToTrash-filePaths "${link}"
      rm "${link}" > /dev/null 2>&1
      ln -s "${src}" "${link}"
    }

    md5_ofFiles() {
      for item in ${@}; do
        if isDir-path $item ;then
          md5_ofDir "$item"
        else
          md5_ofFile "$item"
        fi
      done
    }
    
    md5() {
      md5_ofFiles ${@}
    }

    md5_ofDir() {
      find -s "$1" -type f -exec md5 -q {} \; | md5 -q
    }

    md5_ofFile() {
        md5 -q ${1}
    }

    md5Short-filePath-outputLength() {
      local outputLength=${2}
      print__hsl "$(md5_ofFile "${1}" | colrm $((${outputLength}+1)))"
    }
    
    md5Short() {
      md5Short-filePath-outputLength ${1} 10
    }

    fileCopyMd5-file() {
      local md5="$(md5Short "${1}")"
      sysClipboardCopyVerbose-args "md5:${md5}"
    }

    copyMD5ToClipboard_files() {
      local md5hash=$(md5_ofFiles $@)
      sysClipboardCopy-args "$md5hash" && \
      printSuccessOrError-msgit__hsl "$md5hash is copied to clipboard"
    }
    mdc() {
      copyMD5ToClipboard_files ${@}
    }


    fileCopyPathToClipboard_file() {
      local pathToCopy;
      pathToCopy="$(fileAbsolutePathOf:File $1)"
      sysClipboardCopyVerbose-args "$pathToCopy"
    }
    cl() {
      fileCopyPathToClipboard_file ${@}
    }

    fileSizeOfEachFileIn:Dir() {
      local IFS=$'\n'
      local results=()
      for filename in $1/**; do
          [ -e "$filename" ] || continue
          results+=($(fileSizeOf:File "$filename"))
      done 
      printf '%s\n' ${results[@]} | sort -g
      
      # total run time: 
      # ###### Sat Jun 8 14:30:32 IDT 2019
      # ~4.6s for "/Users/vladzamskoi/Library"
    }

    copyFiles:FromDir:NameMatchingPattern:ToDir() {
      find  "$1" \
          -type f -name "$2" \
          -exec cp '{}' "$3" ';'
    }

    fileName:Path() {
      local absolutePath=$(fileAbsolutePathOf:File "$1")
      local fileName=$(fileLastPartOf:Path "$absolutePath")
      print__hsl "$fileName"
    }

    fileAbsolutePathOf:File() {
      if isPointsToCurrentDir:Path "$1"; then
          print__hsl "$(pwd)"
      else
          print__hsl "$(realpath ${1})"
      fi
    }

    # todo: rename to isRelativePathToCurrentDir
    isPointsToCurrentDir:Path() {
      is-stringEqualTo-string "$1" "." || isEmpty:string__hsl "$1" && return 0 || return 1;
    }

    filePrint:Text:ToFile() {
      fileCreateAt_path "$2"
      print__hsl "$1" >> "$2"
    }

    fileCopyPathOfEnclosingDir:RelativePathToFile() {
      sysClipboardCopy-args "$(fileEnclosingDirPath_relativePath $1)"
    }

    fileEnclosingDirPath_relativePath() {
      if isPointsToCurrentDir:Path "$1" ;then
        fileBasePartOf:Path $(fileCurrentDirPath)
      else
        fileBasePartOf:Path "$(fileCurrentDirPath)/$1"
      fi
    }

    fileCurrentDirPath() {
      print__hsl $(pwd)
    }

    fileEnclosingDirName_Path() {
      if isPointsToCurrentDir:Path "$1" ;then
        fileName:Path
      else 
        fileLastPartOf:Path $(fileEnclosingDirPath_relativePath "$1")
      fi
    }

    isEnclosingDirNameEqualsTo_name() {
      is-stringEqualTo-string $(fileEnclosingDirName_Path) "$1" \
        && return 0 \
        || return 1
    }

    fileCreateAt_path() {
      filePrepareDirAt-path "$(fileBasePartOf:Path $1)"
      fileCreateNewWith:Name "$1"
    }

    filePrepareDirWithKeepFileAt:Path() {
      filePrepareDirAt-path "$1"
      local fileName=".keep"
      if ! isFileExistAt-path "$1/$fileName" ;then
        fileCreateNewWith:Name "$1/$fileName"
      fi
      printSuccessOrError-msgit__hsl "$fileName file is ready at path: $1/$fileName"
    }

    fileCreateDirs-paths() {
      /bin/mkdir -p ${@}
    }
    filePrepareDirAt-path() {
      fileCreateDirs-paths ${@}
    }

    fileOverwrite-source-destination() {
      fileMoveToTrash-filePaths ${2}
      fileCopy-source-destination ${1} ${2}
    }

    fileCopy-destination-sources() {
      local destination="${1}"
      filePrepareDirAt-path "${destination}"
      cp -rv "${@:2}" "${destination}" && \
        printSuccessOrError-msgit__hsl "Copied to\n${destination}" && \
        lsa "${destination}"
    }

    fileCopy-source-destination() {
      cp -r "${1}" "${2}" && \
      local fileName=$(fileLastPartOf:Path "${1}") && \
      printSuccessOrError-msgit__hsl "Copied ${fileName} -->\n${2}"
    }

    fileMoveChangingNameToUnique-filePath-destinationDir() {
      local timeStamp=$(date)
      local uniqueName="${1}_${timeStamp}"
      fileMove-sourceFiles-destination__hsl "$1" "$uniqueName"
      fileMove-sourceFiles-destination__hsl "$uniqueName" "$2"
    }

    fileMove-sourceFiles-destination__hsl() {
      mv ${@}
    }

    fileCreateNewWith:Name() {
      touch "$1"
    }

    fileCreateNewAt:Path:InitialContent() {
      fileCreateAt_path ${1}
      print__hsl "$2" > "$1"
    }

    fileMoveToTrash-filePaths() {
      for file in ${@}; do
        if isSymlink:File $file; then
          rm ${file}
        elif isFileExistAt-path $file ;then
          fileMoveChangingNameToUnique-filePath-destinationDir ${file} "$(userTrashDir)"
        fi
      done
    }

    isSymlink:File() {
      test -h "$1"
    }

    fileInsertToBeginning-text-targetFile() {
      local tempFile="$(userTrashDir)/tempFile$(date).temp"
      print__hsl ${1} > ${tempFile}
      cat ${2} >> ${tempFile}
      fileMoveToTrash-filePaths ${2} \
        && fileMove-sourceFiles-destination__hsl ${tempFile} ${2}
    }

    fileCleanContent-dir__hsl() {
      local targetDirectory=${1}
      if is-stringEqualTo-string "" ${targetDirectory} \
        || is-stringEqualTo-string "." ${targetDirectory} ;then
        
        local targetDirectory=$(pwd)
        fileCreateAndGoto-dir__hsl ..
        fileCleanContent-dir__hsl ${targetDirectory}
        fileCreateAndGoto-dir__hsl ${targetDirectory}
      else
        fileMoveToTrash-filePaths ${targetDirectory}
        filePrepareDirAt-path ${targetDirectory}
      fi
    }

    fileCreateAndGoto-dir__hsl() {
      filePrepareDirAt-path ${1}
      cd ${1}
    }

    fileLastPartOf:Path() {
      basename "$1"
    }

    fileBasePartOf:Path() {
      dirname "$1"
    }

    isFileExistAt-path() {
      [[ -e $1 ]] && return $(yes__hsl) || return $(no__hsl)
    }

    isEmpty-dir() {
      isFileExistAt-path "${1}" && isAbsentOrEmpty-dir "${1}"
    }

    isAbsentOrEmpty-dir() {
      [[ -z "$(ls -A "${1}" 2>/dev/null)" ]] && return $(yes__hsl) || return $(no__hsl)
    }

    isDir-path() {
      [[ -d $1 ]] && return $(yes__hsl) || return $(no__hsl)
    }
}
_callAndForget_functions _main_FilesOperations
