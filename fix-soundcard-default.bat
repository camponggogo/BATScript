@echo off
rem Show SoundCard Name form This Computer with Bat Command.
wmic sounddev get name /value

rem Manual change sound card name to Default fix Sound Card to HDMI Default alway on boot with Bat Commnd
nircmd setdefaultsounddevice "Speakers (Realtek High Definition Audio)" 1
nircmd setdefaultsounddevice "Speakers (NVIDIA Broadcast)" 2
echo Default audio device set.
@echo on
