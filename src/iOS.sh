#!/usr/bin/env zsh

_main_IOS() {

    iOSSimulatorList() {
      xcrun simctl list  
    }

    iOSDeviceList() {
      instruments -s devices  
    }  
}
_main_IOS; _unset_functions _main_IOS