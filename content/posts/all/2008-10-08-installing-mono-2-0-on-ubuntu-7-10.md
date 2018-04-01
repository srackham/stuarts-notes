---
date: 2008-10-08 19:37:47+00:00
slug: installing-mono-2-0-on-ubuntu-7-10
title: Installing Mono 2.0 on Ubuntu 7.10
---

Currently the Mono project does not release Ubuntu binary packages so if you want the latest version of Mono you need to compile and install yourself.  I use the Xubuntu, Here are the steps I took to install Mono 2.0 on Xubuntu 7.10:

<!--more-->

  1. Download _mono_ and _libgdiplus_ tarballs from [http://ftp.novell.com/pub/mono/sources-stable/](http://ftp.novell.com/pub/mono/sources-stable/).
    
        $ wget http://ftp.novell.com/pub/mono/sources/mono/mono-2.0.1.tar.bz2
        $ wget http://ftp.novell.com/pub/mono/sources/libgdiplus/libgdiplus-2.0.tar.bz2


 
  2. Install _libglib2_ development headers:
    
        $ sudo apt-get install libglib2.0-dev


 
  3. Install _libfontconfig1_ development headers (without this ./configure emits configure: error: Cairo requires at least one font backend):
    
        $ sudo apt-get install libfontconfig1-dev


 
  4. Compile and install _libgdiplus_. _libgdiplus_ is required for Winforms, if you don't use Winforms you can skip this step and use ./configure --with-libgdiplus=no when you compile Mono.
    
        $ tar -xjf libgdiplus-2.0.tar.bz2
        $ cd libgdiplus-2.0
        $ ./configure
        $ make
        $ sudo make install


 

The libraries were installed in /usr/local/lib.

  5. Install _bison_:
    
        $ sudo apt-get install bison


 
  6. Compile Mono:
    
        $ tar -xjf mono-2.0.tar.bz2
        $ cd mono-2.0
        $ ./configure
        $ make
        $ sudo make install


 

See also [http://www.mono-project.com/Release_Notes_Mono_2.0](http://www.mono-project.com/Release_Notes_Mono_2.0)

If you want to compile or run GUI applications using GTK bindings instead of WinForms you need to download and compile Gtk#:

  1. First install the following packages to ensure the necessary headers:
    
        $ sudo apt-get install libpango1.0-dev
        $ sudo apt-get install libatk1.0-dev
        $ sudo apt-get install libgtk2.0-dev


 
  2. Download Gtk# source tarball from [http://www.mono-project.com/GtkSharp](http://www.mono-project.com/GtkSharp)
  3. Extract, compile and install Gtk#:
    
        $ tar -zxf gtk-sharp-2.12.0.tar.gz
        $ cd cd gtk-sharp-2.12.0
        $ ./configure
        $ make
        $ sudo make install


 

**Other dependencies**  
One last point, the following packages were already installed on my machine: _fontconfig_, _fontconfig-config_, _libfontconfig1_ -- not sure if they are _'libgdiplus_' compilation dependents but if you have problems these may be what are required.  My machine already had a number of development tools and utilities installed, so there may be other dependencies I've missed for an "out of the box" Xubuntu install.



## Getting Started

You need to tell Mono where to find it's libraries:
    
    $ export LD_LIBRARY_PATH=/usr/local/lib


 

See [http://www.mono-project.com/DllNotFoundException](http://www.mono-project.com/DllNotFoundException)

Next compile and run the _Hello Worlds_ as described in [Mono Basics](http://mono-project.com/Mono_Basics).

If you have problems turn on debugging by setting MONO_LOG_LEVEL the environment variable. For example:
    
    $ MONO_LOG_LEVEL=debug mono hello.exe


 



## Closing thoughts

I like the idea of WinForms as a way of writing desktop apps that run on both Windows and Linux and I like to use Linux for development, problem at the moment is that there's no SharpDevelop-like IDE for creating WinForm UIs on Linux (MonoDevelop uses GTK). There is a [WinForms Designer](http://www.mono-project.com/WinForms_Designer) that runs under Linux but it's not a full IDE and currently is more a "proof of concept" thing.
