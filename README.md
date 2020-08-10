# hubitat-snitch

I found this repo that uses Microsnitch to toggle some wemo stuff and
ported it to my needs which is to toggle a virtual switch in a 
hubitat system to close a blind when a camera is in use and put it back when
the video gets turned off.

The script watches the log for the in use and not in use messages and toggles 
a Hubitat virtual switch via the maker api.

It runs via LaunchAgent.

You have to edit the script for your setup and the launch agent with your details.