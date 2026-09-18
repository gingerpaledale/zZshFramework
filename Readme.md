Created on Jan 24 20  
Updated on Jun 15 26  


# HmnShell Lib  
A human-readable wrappers and utility functions for Zsh (Z-Shell). Some may work or easily adapted for Bash too. This library helps bigger shell codebases to become reliably maintainable, regardless of what AI may generates nowadays.  

The library is designed to be distributed as source code and be easily modified. OWN your code after making mine YOURS;) 


## User NOTE  
> These tools were developed, used and tested under MacOS. I'm not sure how well they'll play in other environments. Some of them will not for sure.  


## How To Use It
If you wanna add ALL of the utility functions, add the following to ONE of your shell profile (initializer) scripts, e. g. ~/.zshrc, or ~/.bashrc, or ~/.zprofile:  
```shell
# in ~/.zshrc
source ${REPLACE_WITH_PATH_TO_THIS_DIR}/src/_index__hsl.sh
```

Alternatively, you can add individual scripts. In this case, make sure you include the `baseUtils.sh`:  
```shell
# in ~/.zshrc
LIB_DIR__HSL="${REPLACE_WITH_PATH_TO_THIS_DIR}/src"
source ${LIB_DIR__HSL}/baseUtils.sh
source ${LIB_DIR__HSL}/files.sh # only the file utils are included
```


## Tested in environment  
###### Mon Oct 10 13:28:10 PDT 2022
* MacOS 13.0 (you can check yours by running `sw_vers -productVersion`)  
* zsh 5.8.1 (x86_64-apple-darwin22.0) (check yours with `zsh --version`)  

Check if everything works by running in your terminal:  
```
version_hsl
```

Expected output example:  
```
$: 10.1.32.260615
HmnShellLib__hsl
```


## Coding Conventions (Style and Logic)
### Functions    
Function name should be written in a camelCase with an underscore `_` denoting a parameter AND end w/ `__hsl`  

E. g.  
```shell
printWarning_message__hsl() { #the function expects a single parameter named [message]
  local message=$1
  ...
}

print_prefix_message__hsl() { #the function expects two parameters: the prefix and the message
  local prefix=$1
  local message=$2
  ...
}
```


## Author
Ali – engineer and manager focused on cybersecurity   
pub@rssCyber.com  
