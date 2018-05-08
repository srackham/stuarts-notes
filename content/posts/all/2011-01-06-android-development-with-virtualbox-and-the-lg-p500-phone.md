---
date: 2011-01-06 20:00:48+00:00
slug: android-development-with-virtualbox-and-the-lg-p500-phone
title: Android Development with VirtualBox and the LG P500 phone
tags:
- Android
- VirtualBox
---


Having recently acquired my first smart-phone (a new LG P500 Android phone) I decided it was time to learn some Android programming.  This post summarizes my trials and tribulations getting the LG P500 phone to talk to my Android Eclipse development environment (Eclipse plus Android SDK running on a VirtualBox Linux guest).

<!--more-->



## Preliminaries

Development environment:

  * Xubuntu 10.04 (VirtualBox 3.2.10 guest running in a Windows Vista x64 host). 
  * An LG P500 Optimus phone running Android 2.2 (USB connection to host PC). 
  * Eclipse 3.6.1 (with OpenJDK Java runtime). 
  * Android SDK version 8. 



**_Important_**:
**Do not install the LG USB driver (LG United Mobile Driver) on the Windows host**, if you've already downloaded and installed it you should uninstall it (from the Windows _Control Panel_). The reason being that the LG driver interferes with the USB passthrough to the guest -- it crashes the guest with a "The VirtualBox user interface has stopped working" message when you try to manually acquire the phone USB port on the guest.

If you had previously installed the Windows LG USB drive on the host then you will lose host USB mass storage functionality when you uninstall it (my experience on Vista x64) -- but, oddly, if you never install the LG driver then host USB mass storage is retained. The default mass storage functionality seems to be removed by the process of installing then uninstalling the LG driver. Guest USB mass storage functionality is not affected.





## Configuring the USB phone device on the VirtualBox guest

  1. Configure the VirtualBox guest USB filter as explained [here](http://forum.xda-developers.com/showthread.php?t=570452g). The phone's USB filter will appear as _LG Electronics Inc. LG Android USB Device [0226]_. 
  2. Start the VirtualBox guest. 
  3. Create a guest _udev_ rules file /etc/udev/rules.d/51-android.rules for the USB device.  The purpose of the rule is simple: it sets the USB device mode to 0666 so that all users have read/write access (via the Android Debug Bridge). 
    
        $ sudo vim /etc/udev/rules.d/51-android.rules
        $ sudo chmod a+r /etc/udev/rules.d/51-android.rules
        $ sudo udevadm control --reload-rules   # In theory not necessary.


 

My rules file contains a single line:
    
    SUBSYSTEM=="usb", ATTR{idVendor}=="1004", MODE="0666"


 


**_Warning_**:
Be careful cutting and pasting udev rules containing double quote characters: if there are opening and closing double quotation marks instead of the normal keyboard straight double quote character then the rule will fail (it's not unusual for some websites to translate straight quotes contained in user submissions). I fell for this one and spent ages trying to figure out what was wrong.


[ This post](http://www.google.com/support/forum/p/android/thread?tid=08945730bbd7b22b&hl=en) contains a very good explanation of the udev rules.

  4. Before plugging the phone in enable the phone's debug option (_Settings->Applications->Development->USB Debugging_). If this is not enabled the Android Debugging Bridge will not recognize the phone (the phone will not be listed when you run the adb devices command). 
  5. Plug in the phone. 
  6. Manually acquire the LG USB device using the VirtualBox guest menu command: _Devices->USB Devices->LG Electronics Inc. LG Android USB Device [0226]_ (not all host USB ports are able to be auto-acquired by VirtualBox guests). 
  7. You should now be able to see the phone's USB port from the VirtualBox guest:
    
        $ lsusb
        Bus 002 Device 004: ID 1004:61c5 LG Electronics, Inc.


 
  8. The Android Debug Bridge should also be able to see the phone: 
    
        $ adb devices
        List of devices attached
        80A354043044540021      device


 

If the phone's debug mode is off or an Android debug device is not detected the device list will be blank:
    
    $ adb devices
    List of devices attached


 

If you did not configure the udev rules file correctly the USB device file's mode will be 0664 instead of 0666 and you will get the following _no permissions_ error:
    
    $ adb devices
    List of devices attached
    ????????????    no permissions


 

  9. Finally, run your Android application from Eclipse, you should be prompted with an _Android Device Chooser_ dialog that includes your Android phone device (identified by the phone's serial number). 



## Mounting the phone's USB drive on the VirtualBox guest

It's important to realize that there are actually two mutually exclusive USB drivers: one for USB storage, the other (a USB serial interface) for debugging. The debug driver is activated when the phone is in debug mode. The phone's USB mass storage device is not available when the phone is in debug mode. To access the phone's USB drive from the VirtualBox guest:

  1. Unplug the phone. 
  2. Disable the phone's debug option (_Settings->Applications->Development->USB Debugging_). 
  3. Plug in the phone. 
  4. When the phone prompts you _Turn on USB storage_. 
  5. Manually acquire the LG USB device from the VirtualBox guest menu (_Devices->USB Devices->LG Electronics Inc. LG Android USB Device [0226]_). 
  6. Mount the USB storage device from the VirtualBox guest e.g.
    
        $ sudo mount /dev/sdb1 /mnt/


 
  7. Unmount it when you've finished e.g.
    
        $ sudo umount /mnt/


 



**_Tip_**:
You can use fdisk to determine the drive name e.g.
    
    $ sudo fdisk -l | grep FAT32
    /dev/sdb1               5       19270    16182272    c  W95 FAT32 (LBA)


 
 


**_Note_**:
On the Xubuntu 10.04 guest I had to disable the Thunar file manager's volume management (in _Edit->Preferences->Advanced_ uncheck the _Enable volume Management_ option). If this was not done Thunar would spontaneously close while scanning the auto-mounted drive.




## To reinstall the LG phone driver on the Windows host

Here's what to do if you ever need to (re)install the Windows host USB phone driver.  This will reinstate host USB functionality but you will lose guest USB functionality.

  1. Visit the [LG Mobile Phone Support page](http://www.lg.com/in/support/mc-support/mobile-phone-support.jsp) and install the _LG Mobile Support Tool_. 
  2. Run the _LGMobile Support Tool_. 
  3. Click on _Install USB Driver_ to install the driver for your LG phone. 

To stop the _LGMobile Support Tool_ running in the Icon Tray:

  1. Right-click on Icon Tray icon and select _Option_. 
  2. Uncheck _Autostart on Windows booting_ and press _OK_. 
