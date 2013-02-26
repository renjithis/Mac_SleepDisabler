Mac_SleepDisabler
=================

Sleep Disabler background process which will disable sleep for the system. For use in systems which crash when sleep is started

Installation
============

You need to have XCode.
Download/Clone the source code.
Open the project and Archive. Save the archive by selecting Distribute and Save.
Copy the output directory structure to /
Modify in.renjithis.sleepdisabler.plist to reflect the path of SleepDisabler binary
Copy in.renjithis.sleepdisabler.plist to /Library/LaunchDaemons/
The binary will be loaded automatically on boot.
To test sleep, issue the command in Terminal :
  $ sudo launchctl load /Library/LaunchDaemons/in.renjithis.sleepdisabler.plist
Select sleep and press any key, mouse click, etc to resume.
