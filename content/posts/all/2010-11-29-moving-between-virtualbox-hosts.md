---
date: 2010-11-29 00:22:55+00:00
slug: moving-between-virtualbox-hosts
title: Moving between VirtualBox Hosts
tags:
- VirtualBox
---

**Published**: 2010-11-28

A description of the issues I encountered moving my VBox environment from one host to another.

<!--more-->

Source host 
     Dell Studio XPS Core i7 running Vista Home Premium x64, VBox 3.2.10. 
Target host 
     HP TouchSmart tm2 Core i5 running Win7 Home Premium x64. 

I installed VBox 3.2.10 on the target host (same as on the source host) then copied the .VirtualBox directory from the source to the target via a USB HDD.

VBox configuration files contain absolute VDI path names: copy the .VirtualBox directory to the same location on the target to ensure the path names are same on both hosts. If you don't do this you'll need to edit the VBox XML configuration files on the target.

I use the default location for VBox files so had to create the same _srackham_ user on the target as on the host (VBox files stored in `C:\Users\srackham\.VirtualBox` on both hosts).

Here are the procedures I used and the issues I encountered.



## Adjust network settings

My guest VMs use the _Bridged_ networking mode and found I had to open VBox _Settings_ on each target VM and change the _Intel 82567LF-2 Gigabit Network Connection_ wired adaptor to the _Intel WiFi Link 1000 BGN_ WiFi adaptor option (because the target host had a WiFi network connection whereas the source host had a wired network connection).




**_Note_**:
The _Microsoft Virtual WiFi Miniport Adaptor_ was also presented as an option but it did not work.




## Unable to boot Windows VDIs on target host

The Windows VMs failed to boot on the target host.

### Symptoms

About 3 seconds into the Windows guest boot sequence (just after the splash screen appears) a Blue Screen Of Death appears briefly (to quick to ready anything), then the VM reboots and the cycle repeats.

### Solutions

It took me while to find the solution, but it turned out to be simple: enable virtualization in the host BIOS (the factory setting of the HP TouchSmart tm2 BIOS _System Configuration->Virtualization Technology_ option is _Disabled_, I set it to _Enabled_ and the problem went away).

Another, more complicated, solution is to change the `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Intelppm\Start` registry entry to 4 as detailed in this blog:

<http://blogs.msdn.com/b/virtual_pc_guy/archive/2005/10/24/484461.aspx>

If the Intelppm registry entry does not exists change the `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Processor\Start` registry entry instead.

You need to boot the Windows guest in _Safe Mode_ -- to do this press F8 when the Windows guest is booting to select _Safe mode_.

Apparently the reason for this crash is because the intelppm.sys driver is attempting to perform an unsupported operation inside of the virtual machine (like upgrading the physical processors microcode, changing power state on the physical processor) -- looks like the Intel Core i5-430UM processor does not support the same operations as the Core i7 processor. I guess there must be some processor ID stored in by Windows that is used at boot time.  I was unable to find any definitive documentation as to the actual purpose of the intelppm.sys.

  * Similar problems have been reported in the past: 
    * [http://www.virtualbox.org/ticket/420](http://www.virtualbox.org/ticket/420)
    * [http://forums.virtualbox.org/viewtopic.php?t=1560](http://forums.virtualbox.org/viewtopic.php?t=1560)
    * [http://www.sssgmbh.de/download/install/suse103/VirtualBox](http://www.sssgmbh.de/download/install/suse103/VirtualBox)
  * Apparently there is also an amdppm.sys driver (used on other processor architectures) that has a corresponding _amdppm_ registry entry and can also cause problems. 
  * Section 12.3.4 of the 3.2.10 _VirtualBox User Manual_ describes how to record bluescreen information from Windows guests. 
  * Interestingly there was no _intelppm_ registry entry in one of the WinXP VMs an it never exhibited the problem. 
  * On Windows 7 Professional the _Start_ registry value was set to 3 not 1. 
  * Booting Win7 Pro x64 guest for the first time on the target host _Intel Core i5 CPU_ device driver software was successfully installed -- presumably Windows had sensed a CPU change. 

The second solution is apparently more general in that it will work irrespective of the target host CPU virtualization capabilities, see replies to my post to the VBox forums: [http://forums.virtualbox.org/viewtopic.php?f=6&t=36398](http://forums.virtualbox.org/viewtopic.php?f=6&t=36398)



## Duplicate Name Exists errors

I sometimes got a _Duplicate Name Exists_ error when starting WinXP guest on the new host. This error occurs if two PC with the same Windows computer name exist in the same workgroup -- but not so in this case as I was not running the same VM on the source host.  The problem goes away after rebooting.
