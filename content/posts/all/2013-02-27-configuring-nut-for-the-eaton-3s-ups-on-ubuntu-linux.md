---
date: 2013-02-27 00:54:22+00:00
slug: configuring-nut-for-the-eaton-3s-ups-on-ubuntu-linux
title: Configuring NUT for the Eaton 3S UPS on Ubuntu Linux
categories:
- Linux
- NUT
- Ubuntu
- UPS
---

**Note**: Since this post was published I've installed and tests on Ubuntu Server 14.04 and have highlighted the difference between Ubuntu 14.04 and 12.04 at the end of this post.

This post explains how to configure [Network UPS Tools (NUT)](http://www.networkupstools.org/) to work with an [Eaton 3S UPS](http://powerquality.eaton.com/Products-services/Backup-Power-UPS/3S.aspx) on a stand-alone Ubuntu 12.04 PC (Nut version 2.6.3).

<!--more-->

[Network UPS Tools (NUT)](http://www.networkupstools.org/) seems to be the most widely supported and used UPS management package for Linux. It is extremely flexible and caters for a wide range of UPS makes, models and deployment scenarios. The sheer scope and flexibility of NUT makes UPS selection and configuration daunting. The purpose of this article is to illustrate a minimal configuration to achieve stand-alone UPS management of a single Ubuntu 12.04 based PC.


## NUT configuration

Here's how this configuration works: when power has dropped out for more than 3 minutes NUT triggers a shutdown. The shutdown sequence closes down Ubuntu; commands the UPS to commence shutdown; and then turns off the PC. Once the PC is off the UPS turns off to conserve the UPS battery. When power is reestablished the UPS powers up and reapplies power to the PC (whether your PC turns on automatically at power resumption is determined by it's BIOS settings).

Here are the minimal NUT configuration files:

**/etc/nut/nut.conf**

    # Set MODE=none to disable UPS monitoring, MODE=standalone to enable UPS monitoring.
    MODE=standalone

**/etc/nut/ups.conf**

    [eaton3s]
    driver=usbhid-ups
    port=auto

**/etc/nut/upsd.conf**

<pre>
</pre>

**/etc/nut/upsmon.conf**

    MONITOR eaton3s@localhost 1 monuser pass master
    SHUTDOWNCMD "/sbin/shutdown -P now"
    POWERDOWNFLAG /etc/killpower
    
    NOTIFYFLAG ONBATT SYSLOG+WALL+EXEC
    NOTIFYFLAG ONLINE SYSLOG+WALL+EXEC
    NOTIFYCMD "/etc/nut/notifycmd"

**/etc/nut/upssched.conf**

<pre>
</pre>

**/etc/nut/upsd.users**

    [monuser]
    password=pass
    upsmon master

The following `notifycmd` bash script handles NUT _ONBATT_ and _ONLINE_ events. Put it in `/etc/nut`, it is executed when NUT detects power resumption (prior to the 3 minute timeout) and when NUT detects the UPS has switched to battery (power outage). Don't forget to make this script executable (`sudo chmod +x /etc/nut/notifycmd`).

**/etc/nut/notifycmd**

    #!/bin/bash
    #
    # NUT NOTIFYCMD script
    
    PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin
    
    trap "exit 0" SIGTERM
    
    if [ "$NOTIFYTYPE" = "ONLINE" ]
    then
            echo $0: power restored | wall
            # Cause all instances of this script to exit.
            killall -s SIGTERM `basename $0`
    fi
    
    if [ "$NOTIFYTYPE" = "ONBATT" ]
    then
            echo $0: 3 minutes till system powers down... | wall
            # Loop with one second interval to allow SIGTERM reception.
            let "n = 180"
            while [ $n -ne 0 ]
            do
                    sleep 1
                    let "n--"
            done
            echo $0: commencing shutdown | wall
            upsmon -c fsd
    fi


## Testing the UPS

  * Check NUT status:

          $ sudo service nut status
          Checking status of Network UPS Tools
          * upsd is running
          * upsmon is running


  * If necessary start NUT:

          $ sudo service nut start

  * Plug in USB cable and check it's been detected:

          $ lsusb
            :
          Bus 005 Device 003: ID 0463:ffff MGE UPS Systems UPS


  * Check the UPS status:

          $ sudo upsc eaton3s

          battery.charge: 100
          battery.charge.low: 20
          battery.runtime: 3000
          battery.type: PbAc
          device.mfr: EATON
          device.model: Eaton 3S 700
            :
          ups.status: OL CHRG
          ups.timer.shutdown: -1
          ups.timer.start: -1
          ups.vendorid: 0463


  * Check power off/on status by unplugging the power to the UPS until it beeps a few times then plug it back in. You will get the following console messages:

        Broadcast Message from nut@nas1
                (somewhere) at 13:23 ...

        UPS eaton3s@localhost on battery


        Broadcast Message from nut@nas1
                (somewhere) at 13:23 ...

        /etc/nut/notifycmd: 3 minutes till system powers down...


        Broadcast Message from nut@nas1
                (somewhere) at 13:23 ...

        UPS eaton3s@localhost on line power


        Broadcast Message from nut@nas1
                (somewhere) at 13:23 ...

        /etc/nut/notifycmd: power restored

  * The `/var/log/syslog` should have two messages like:

        Feb 19 11:37:54 nas1 upsmon[3044]: UPS eaton3s@localhost on battery
        Feb 19 11:38:14 nas1 upsmon[3044]: UPS eaton3s@localhost on line power


  * Simulate a power outage (NOTE: this will take the PC to shutdown **immediately**):

          $ sudo upsmon -c fsd

  * Test the `/etc/nut/notifycmd` script fully by unplugging the power from the UPS and waiting until the full shutdown sequence is played out (takes 3 minutes). Look for the message:

          /etc/nut/notifycmd: 3 minutes till system powers down...


## UPS selection

The key to using a UPS with NUT is getting a UPS that is fully supported by the NUT version you are using (Ubuntu 12.04 has NUT 2.6.3).  Here's why I chose the Eaton 3S:

  1. It is [fully supported by NUT UPS Tools 2.6.3](http://www.networkupstools.org/stable-hcl.html) on Unbuntu 12.04 with the _usbhid-ups_ driver. 
  2. The vendor has a Linux commitment -- they provide their own [Intelligent Power Protector](http://pqsoftware.eaton.com/explore/eng/ipp/default.htm?lang=en) (IPP) software for Linux (I didn't use it, choosing NUT instead). 
  3. Readily available replacement battery. 
  4. Other users report [it works with Ubuntu 12.04](http://askubuntu.com/questions/107883/how-to-use-a-eaton-3s-700va-ups-with-ubuntu-server). 


## Ubuntu 14.04
Since this post was originally published I've installed and tested Nut on Ubuntu Server 14.04 (Nut version 2.7.1) where I encountered an intermittent startup error viz. about one boot in six the UPS driver failed to connect leaving the following error in the _syslog_:

    Poll UPS [eaton3s@localhost] failed - Driver not connected

I tried unsuccessfully to find the root of the problem by changing the startup order, in the end I worked around it by starting the Nut server at the end of the boot from `/etc/rc.local`:

    # If UPS server driver is not connected then restart the server.
    /bin/upsc eaton3s || /usr/sbin/service nut-server restart

**NOTE**: NUT in 14.04 has two startup services (replacing the single `nut` in 12.04): `nut-client` and `nut-server` -- they are both started at reboot, aside from the startup error I have encountered no other differences in the move from Ubuntu 12.04 to 14.04.
