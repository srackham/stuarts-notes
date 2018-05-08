---
date: 2011-07-16 05:32:45+00:00
slug: using-an-ipad-to-access-remote-windows-desktops
title: Using an iPad to access remote Windows desktops
tags:
- ipad
- rdp
- vnc
---


I went from initial scepticism, when I started looking for a usable iPad remote desktop solution for accessing Windows PCs, to (almost) wild enthusiasm.

I evaluated four of the best iPad remote access apps and am delighted to have found one that does exactly what I want. This post outlines why I settled on _Jump Desktop_ along with a few usage tips.

<!--more-->

The four apps I evaluated were:

  * [Remote Desktop Lite - RDP](http://www.mochasoft.dk/iphone_rdp.htm) version 2.7. 
  * [iTAP RDP](http://itap-mobile.com/itap-rdp/) version 1.7.3. 
  * [Desktop Connect](http://www.antecea.com/apps/desktop_conn/overview.html) version 4.2. 
  * All four have very good RDP (Microsoft Remote Desktop Protocol) clients, the latter two also include VNC clients.  _Remote Desktop Lite - RDP_ is a free app the others are non-free.



## The hard part: getting back into your office

My principle use case is remote Internet access from a wireless iPad tethered to my mobile phone back into desktops running Microsoft Windows on my (Internet connected) office LAN.  The hard part is locating and securely connecting to desktop PCs from an external location on the Internet. This is because most desktop PCs are isolated from the Internet behind a NAT router/firewall with a dynamic IP address, so you can't use DNS to locate the router or the PC. You have two choices:

  1. You can manually reconfigure your router NAT and firewall rules; then configure your desktop PC's firewall and remote access permissions; then setup dynamic DNS to your router ([this web page](http://support.jumpdesktop.com/entries/194620-setup-manual-configuration) outlines the process). 
  2. Or you can install a desktop app which sets up and manages your connections automatically. 

Manual configuration is time consuming and fiddly. It can be downright dangerous if you're not careful or don't understand what you're doing. Of the four apps I tried only _Desktop Connect_ and _Jump Desktop_ support the automatic configuration option (both use Google Talk to facilitate the connection) -- this is why, for me, the choice was between these two remote access apps.




### How does the auto-connect feature work?

A first it seems like magic -- how can all this manual jiggery-pokery be obviated by your Google login? The answer is that the auto-connect program on your desktop logs into Google's servers and registers your computers address, the remote access client on you iPad also logs into your Google account and retrieves the address of your desktop. Here is [some more information](http://support.jumpdesktop.com/entries/223751-general-how-does-jump-desktop-use-my-google-account).





## Why I choose Jump Desktop over Desktop Connect

Both _Jump Desktop_ over _Desktop Connect_ have excellent RDP and VNC iPad clients, but _Jump Desktop_ really shines when it comes to the auto-connect functionality.

  * _Jump Desktop_ auto-connect supports both RDP and VNC protocols, _Desktop Connect_ only supports VNC. 
  * The free [Jump Desktop Viewer](http://support.jumpdesktop.com/entries/20097387-jump-desktop-viewer-for-pc) is a real gem, it gets installed with the PC _Jump Desktop_ and allows you to use a PC in place of an iPad for the remote access client. 
  * The _Jump Desktop_ PC auto-connect installer is very polished -- it handles VNC server and .NET dependency installation (if necessary). _Desktop Connects_ PC auto-connect app (_Easy Connect_) was still in beta at the time of my evaluation. 

The only thing I would like to see added to _Jump Desktop_ would be built-in help with some sort of first time use wizard or guide. The _Jump Desktop_ website has a very good searchable [Knowledge Base](http://support.jumpdesktop.com/forums) which you'll probably need to use while learning the app. I had a more favorable initial experience with _Desktop Connect_, it has built-in help and a more discoverable and attractive user interface.

But at the end of the day my choice of _Jump Desktop_ over _Desktop Connect_ was clear cut and unequivocal.

I evaluated RDP connections to Windows 7 Pro and Windows XP Pro; VNC on Windows 7 Home.



## RDP or VNC?

The target desktop PC must run a remote access server. All current versions of Windows (apart from Windows Home and Starter editions) come with an RDP server and I recommend using RDP over VNC for Windows access:

  1. RDP can run the client at different resolution to the host PC, this means you can always view the remote desktop using the iPad's native 1024x768 resolution, there's no pixel interpolation and the clarity is greater. 
  2. I found RDP performed faster and smoother than VNC alongside each other to a Windows 7 desktop (my iPad was connected to the Internet over a fairly slow tethered mobile 3G connection). 
  3. The RDP server comes preinstalled and supported by Microsoft. 

VNC is useful for non-Windows desktops (Linux, OS X) and for Windows Home edition (which does not include an RDP server).



## Jump Desktop tips

Unless stated otherwise these comments relate to RDP connections.

  * When using RDP the desktop PC user account that you want to log into must have a password (unless you are prepared to [change the password policy](http://dandar3.blogspot.com/2008/04/windows-vista-allow-remote-desktop.html)). You can set the PC's _autologon_ to get _Jump_ to automatically submit your logon parameters. 
  * By default the desktop wallpaper is disabled over RDP (see next item) and the solid desktop color will be displayed. The default solid desktop color is black on Windows 7 but you can change it: 
    1. Right-click on the desktop and select _Personalize_. 
    2. Click the _Desktop background_ link then select _Solid colors_ from the _Picture location_ drop-down list and choose a color. 
    3. Click _Save Changes_. 
    4. Optionally restore your wallpaper for local access. 
  * You can enable the desktop wallpaper by editing the Jump _quality_ settings (though this will slow performance and increase data traffic). 
  * Take time out to learn the _Jump Desktop_ [gestures and toolbar](http://support.jumpdesktop.com/entries/280968-ipad-input-methods) and experiment with the user interface options to find the ones that suit you best (I disable the cursor and use pinch and zoom when I need pointer accuracy). 
  * The [Jump Desktop Knowledge Base](http://support.jumpdesktop.com/forums) is your friend. 



## Q & A

_What if I don't have an iPad?_
     You don't need an iPad for remote access, for example the free [Jump Desktop Viewer](http://support.jumpdesktop.com/entries/20097387-jump-desktop-viewer-for-pc) allows you to use a Windows PC in place of an iPad for the remote access client -- an option if you're wanting to dip your toes in the water before deciding on buying an iPad.

_Don't I need an iPad with the 3G option to use a mobile data connection?_
     No, not if you have a mobile phone that supports WiFi tethering. WiFi tethering turns your phone into your own private wireless hotspot, in most new Android phones turning tethering on is a simple one-click option.

_How can I keep a lid on mobile data costs?_
     Remote access typically uses less data than Web browsing but mobile data is expensive in New Zealand, so only use it when you have to and if, for example, you're at home connect the iPad to the Internet over your home WiFi connection. [I blogged about this recently](/posts/keeping-a-lid-on-mobile-data/).

_Is it true that remote access won't work on a PC running Windows Home edition?_
     Microsoft does not bundle an RDP server with _Windows Home_ editions so you need to install an alternative. Jump Desktop will optionally install a VNC server on Windows Home PCs, but a version of Windows with built-in RDP is preferable.

_What happens if my desktop PC is powered off?_
     Your desktop PC has to be powered on to access it remotely so you do need to leave your PC on and don't enable the _Hibernate_ or _Sleep_ power options.  Most PCs are capable of being turned on by a remote command over the Internet, but getting this configured and working is outside the scope of this post.

_So now I've got a tablet I don't need a desktop PC, right?_
     Not so fast, tablets are content consumers not content creators. The tablet on-screen keyboard and small screen is OK for casual input and browsing but is not suitable for ongoing data entry or document creation. 
