+++
draft = false
date = "2015-01-04T19:58:37+13:00"
title = "Easier Terminal pasting in Ubuntu"
slug = "easier-terminal-pasting-in-ubuntu"
tags = ["Ubuntu"]
templates = ""
author = ""
+++

Everyone knows about the traditional clipboard where you explicitly
copy the text selection using the application's _Copy_ command, but
few know that there is a second called the _primary selection_ that
always holds the current text selection i.e. you don't have to copy to
it.

<!--more-->

This reduces _select->copy->paste_ to _select->paste_ which I find
incredibly helpful as I spend much of my computer time inside a
terminal am constantly copying and pasting text.

You can paste the primary selection by clicking the middle button on the
mouse. The Terminal application also assigns the _Shift+Insert_
keyboard shortcut to paste the primary selection.

So, if you're in the Terminal and want to paste the text selection to
the cursor just middle-click the mouse or press _Shift+Insert_ (a lot
less tedious than _Ctrl+Shift+C_ plus _Ctrl+Shift+V_).

Here's another tip: Use `xclip(1)` to copy and paste between the
terminal and Desktop applications (first you'll need to install `xclip`
with `sudo apt-get install xclip`).

Example usage:

``` bash
cat pages.html | xclip -sel clip  # Copy file to clipboard.
xclip -sel clip -o > foo.txt      # Write clipboard to file.
```

By default `xclip(1)` uses the primary selection (not the clipboard)
so I've added the following alias in my `~/.bashrc` file:

``` bash
alias xclip='xclip -sel clip'
```

This makes working with the clipboard less verbose:

``` bash
cat pages.html | xclip    # Copy file to clipboard.
xclip -o > foo.txt        # Write clipboard to file.
```

**Bonus tip**: To select text column-wise hold down the _Ctrl_ key then select the
text with the mouse.