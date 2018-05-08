---
date: 2008-05-15 02:33:24+00:00
slug: blogging-with-asciidoc
title: Blogging with AsciiDoc
tags:
- AsciiDoc
- blogpost
- Weblog client
- WordPress
---

> Since this blog was written many new features have been added to `blogpost` -- see [blogpost media processing](/posts/blogpost-media-processing/)

I make lots of notes using [AsciiDoc](http://www.methods.co.nz/asciidoc/), the sort of stuff that's to minor and/or not rigorous enough for formal publication, but possibly useful to others.

So I decided it was about time I started posting my notes to a blog. Creating and maintaining posts using the normal browser based interfaces was not an option -- just to tedious for words.  So I looked around for an HTML friendly blog host that could make a reasonable job of rendering AsciiDoc generated HTML.

<!--more-->

After a search (albeit brief) I settled on [Wordpress.com](http://wordpress.com). There is a problem though: Wordpress massages HTML pasted into the Wordpress HTML editor.  Here are some rendering problems I observed after pasting AsciiDoc-generated HTML into Wordpress:

  * Paragraph tags are stripped and <br /> tags inserted at line breaks. 
  * Break tags inserted preceeding inline tags. 
  * Tables problems because Wordpress seems to insist on the opening _table_ tag occupying a single line. 
  * _Emoticons_ are auto-generated. 

These problems could be solved by installing the [WP Unformatted](http://wordpress.org/extend/plugins/wp-unformatted/) Wordpress plugin -- unfortunately wordpress.com dosn't allow plugins, in any case blog editing by pasting into the browser is still tedious. Submitting the unmodified HTML via the [Wordpress API](http://codex.wordpress.org/XML-RPC_Support) doesn't get round these problems either.

My solution was to write _blogpost_, a Wordpress command-line weblog client for AsciiDoc. _blogpost_ allows you to create, list, delete and update blogs written in AsciiDoc from the command-line. Here are some usage examples:



    
    $ blogpost.py create doc/blogging_with_asciidoc.txt
    creating published post 'Blogging with AsciiDoc'...
    id: 38
    
    $ blogpost.py list
    38: Thu May 15 22:36:47 2008: Blogging with AsciiDoc
    
    $ blogpost.py update 38 doc/blogging_with_asciidoc.txt
    updating published post 'Blogging with AsciiDoc'...
    id: 38
    url: http://srackham.wordpress.com/2008/05/38/blogging-with-asciidoc/
    
    $ blogpost.py delete 38
    deleting post 38...


 


I have used _blogpost_ to post the [AsciiDoc User Guide](http://srackham.wordpress.com/asciidoc-user-guide/), a long (around 100 page) and fairly complicated AsciiDoc document.

To get AsciiDoc output into a Wordpress compatible format:

  1. I've written an AsciiDoc wordpress.conf configuration file which implements a _wordpress_ backend -- all it contains is a few minor adjustments to the existing AsciiDoc _html4_ backend. 
  2. _blogpost_ runs AsciiDoc with the --backend wordpress --no-header-footer options. 
  3. _blogpost_ then captures the HTML output from AsciiDoc and removes all extraneous line breaks -- the HTML is now Wordpress friendly. 

See also:

  * [blogpost man page](http://srackham.wordpress.com/blogpost1/)
  * [blogpost README](http://srackham.wordpress.com/blogpost-readme/)
  * [blogpost Mercurial repository at ShareSource](http://hg.sharesource.org/blogpost/). 

_blogpost_ uses Michele Ferretti's [Python Wordpress library](http://www.blackbirdblog.it/programmazione/progetti/28) to communicate with the Wordpress XML-RPC API.
