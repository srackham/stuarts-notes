---
date: 2011-08-30 03:02:03+00:00
slug: fossil-backend-for-asciidoc
title: Fossil Backend for AsciiDoc
tags:
- AsciiDoc
- fossil
---


The [AsciiDoc](http://www.methods.co.nz/asciidoc/) Fossil backend plugin is [hosted on Github](https://github.com/srackham/asciidoc-fossil-backend), it generates [Fossil](http://www.fossil-scm.org) friendly Wiki markup from AsciiDoc source.  As of version 1.0.0 (2012-08-30) the Fossil backend plugin embeds linked images and admonition icons in the wiki documents.

<!--more-->

The backend itself is a single [fossil.conf](https://github.com/srackham/asciidoc-fossil-backend/blob/master/fossil.conf) configuration file.

To install the Fossil plugin download [fossil.zip](https://github.com/downloads/srackham/asciidoc-fossil-backend/fossil.zip) and install it with AsciiDoc (you will need AsciiDoc version 8.6.6 or newer):
    
    asciidoc --backend install fossil.zip


 

Use the _fossil_ backend as you would the built-in backends then pipe the output into Fossil. For example, this command will create a Wiki page called _AsciiDoc_ in the current Fossil repository:
    
    asciidoc -b fossil -a iconsdir=./icons -o - asciidoc.txt | fossil wiki create AsciiDoc


 

This command updates the existing wiki page:
    
    asciidoc -b fossil -a iconsdir=./icons -o - asciidoc.txt | fossil wiki commit AsciiDoc


 


**_Note_**:
Specifying the location of the admonition icons by setting the _iconsdir_ attribute has been rendered unnecessary by [a commit](https://code.google.com/p/asciidoc/source/detail?r=dd07b38888fdfe8cd80d18f12aa7d21e3dd11eb6) made on 11-September-2012.
 


### Fossil

[Fossil](http://www.fossil-scm.org) is a wonderful distributed version control system (DVCS) by Richard Hipp, the author of SQLite. It is built on SQLite and shares the same small-is-beautiful single stand-alone executable philosophy.

A Fossil repository doesn't just manage source, it also supports distributed project bug tracking, wiki and blog -- all managed by an integrated Web UI.

 


**_Note_**:

  * By default linked images and admonition icons will be embedded in the wiki documents using the [data URI scheme](https://en.wikipedia.org/wiki/Data_URI_scheme) (AsciiDoc _data-uri_ and _icons_ attributes are set in the plugin's `fossil.conf` file). 
  * Older browsers (notably IE8) limit the size of data URIs. 
  * You will need AsciiDoc version 8.6.6 or newer to use the Fossil backend. 
  * To update an existing wiki page use the Fossil `wiki commit` command (not `wiki create`). 
 


### Wiki HTML limitations

By default the Fossil [wiki formatting rules](http://fossil-scm.org/xfer/wiki_rules) enforce an HTML subset. If you want richer HTML wiki pages you could enable the Fossil _Use HTML as wiki markup language_ configuration option, but this is not advisable because:

  1. Malicious users could inject dangerous HTML, CSS and JavaScript code into your wiki. 
  2. It is not a supported option. 
  3. Wiki links `[...]` are translated to HTML links which in turn precludes the use of HTML embedded _script_ and _style_ elements. 

Keep in mind that wikis are designed  to allow casual users to enter short relatively simple notes. Project documentation (which is often longer and more complex) is usually better served using Fossil's [Embedded Documentation](http://www.fossil-scm.org/index.html/doc/tip/www/embeddeddoc.wiki) feature.

Another gotcha is that currently the Fossil web server does not follow symlinks, instead it displays the content of the symlink file.


