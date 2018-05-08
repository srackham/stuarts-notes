---
date: 2012-10-26 22:19:01+00:00
slug: reclaiming-the-windows-8-desktop
title: Reclaiming the Windows 8 Desktop
tags:
- Start8
- Windows 8
---


<!--more-->

Here's what we are going to do:

  1. Restore the Windows Start Menu. 
  2. Boot directly to the Windows 8 desktop (and optionally bypass the login screen). 
  3. Restore the Quick Launch toolbar and the Show Desktop icon. 

Here is a screenshot of the reconfigured Windows 8 desktop (note the Start Menu and the Quick Launch toolbar at the bottom left):

![win8-desktop.png]({{.urlprefix}}/images/win8-desktop.png)




**TIP**: Press the _Windows_ key to switch from the Metro user interface to the traditional Desktop user interface.


## Restoring the Start Menu

There are a number of Windows 8 Start Menu apps available but by far the best I was able to find is [Start8](http://www.stardock.com/products/start8/), it's not free but it's the best five bucks I've spent in long while.

Once you've installed Start8 you not only have a nice Windows 8 themed Start Menu but you can also automatically go to the Desktop when you sign in to Windows (right-click on the Start Menu button and select _Configure Start8…_ to customize).


## Bypass login screen

If you don't want the bother of having to type your login name every time you start your PC follow this [CNET article](http://news.cnet.com/8301-10805_3-57457967-75/how-to-bypass-the-windows-8-log-in-screen/).


## Restore the Quick Launch toolbar and the Show Desktop icon

See this excellent EightForumks tutorial explaining [How to Add Quick Launch to the Taskbar in Windows 8](http://www.eightforums.com/tutorials/5069-quick-launch-add-taskbar-windows-8-a.html).

Here's a paraphrased how-to:

  1. Right-click on the Taskbar and select _Toolbars->New Toolbar…_
  2. Paste `%userprofile%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch` into the _Folder_ input and click _Select Folder_. The Quick Launch toolbar will appear, next we will change it's appearence and reposition it. 
  3. Unlock the Taskbar (right-click Taskbar and untick _Lock the taskbar_). 
  4. Right-click on Quick Launch toolbar and untick _Show Text_ and _Show Title_. 
  5. Right-click on Quick Launch toolbar and select _View…_ to set the desired Quick Launch toolbar icon size. 
  6. Reposition and resize the Quick Launch toolbar next to the Start Menu. 
  7. Finally lock the Taskbar (right-click Taskbar and tick _Lock the taskbar_). 

To add application icons to the Quick Launch toolbar find the application shortcut using the File Explorer then drag and drop it onto the Quick Launch toolbar, here how:

  1. First you need to show hidden files: 
    1. Open the _Control Panel_ search for _folder_. 
    2. Click on _Show hidden files and folders_ then select the _Show hidden files, folders and drives_ option. 
  2. Now open _File Explorer_ (_Start Menu->All Programs->System Tools->File Explorer_). 
  3. Navigate to the folder `C:\ProgramData\Microsoft\Windows\Start Menu\Programs` then drap-and-drop program shortcuts to the Quick Launch toolbar. 


## Resize windows borders

The [Tiny Windows Borders](http://winaero.com/comment.php?comment.news.96) tool can be used to make the annoyingly large Windows 8 border widths small.
