Mac_SleepDisabler
=================

Sleep Disabler background process which will disable sleep for the system. For use in systems which crash when sleep is started

Installation
============

You need to have XCode.<br />
Download/Clone the source code.<br />
Open the project and Archive. Save the archive by selecting Distribute and Save.<br />
Copy the output directory structure to /<br />
Modify in.renjithis.sleepdisabler.plist to reflect the path of SleepDisabler binary<br />
Copy in.renjithis.sleepdisabler.plist to /Library/LaunchDaemons/<br />
The binary will be loaded automatically on boot.<br />
To test sleep, issue the command in Terminal :<br />
  $ sudo launchctl load /Library/LaunchDaemons/in.renjithis.sleepdisabler.plist<br />
Select sleep and press any key, mouse click, etc to resume.<br />
