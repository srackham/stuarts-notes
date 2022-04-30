---
date: 2008-05-22 05:45:34+00:00
slug: blogpost-media-processing
title: blogpost media processing
---

_blogpost_ 0.9.0 adds lots of new features to the previous 0.1.0 release.  The most important feature in the _blogpost_ 0.9.0 release is WordPress media file management:

  * Media files (images, videos, audio, document) referenced in your AsciiDoc (or HTML) documents are automatically uploaded and linked to the uploaded blog. 
  * Only new or modified media files are uploaded (changes detected using cached MD5 checksums). 
  * Metadata caching means post options are remembered and don't need to be repeated every time you update your posts. 
  * WordPress Pages can be posted and updated (blogpost includes a patched wordpresslib.py containing Page methods).

<!--more-->

This blog post along with this inline image ![smallnew.png](/images/smallnew.png) and this block image:

![tiger.png](/images/tiger.png)

Were uploaded by using this _blogpost_ create command:

    $ blogpost.py create blogpost_media_processing.txt
    
    uploading: /home/srackham/doc/blogs/smallnew.png...
    url: http://srackham.files.wordpress.com/2008/05/smallnew.png
    uploading: /home/srackham/doc/blogs/tiger.png...
    url: http://srackham.files.wordpress.com/2008/05/tiger1.png
    creating published post 'blogpost media processing'...
    id: 93
    url: http://srackham.wordpress.com/2008/05/22/blogpost-media-processing/


 


The _info_ command lists locally cached information:

    $ blogpost.py info blogpost_media_processing.txt
    
    title:   blogpost media processing
    id:      93
    url:     http://srackham.wordpress.com/2008/05/22/blogpost-media-processing/
    status:  published
    type:    post
    doctype: article
    created: Thu May 22 17:45:34 2008
    updated: Thu May 22 17:45:40 2008
    media:   http://srackham.files.wordpress.com/2008/05/tiger1.png
    media:   http://srackham.files.wordpress.com/2008/05/smallnew.png


 


Note how the update command skips uploading the unchanged image files:

    $ blogpost.py update blogpost_media_processing.txt
    
    skipping: /home/srackham/doc/blogs/smallnew.png
    skipping: /home/srackham/doc/blogs/tiger.png
    updating published post 'blogpost media processing'...
    id: 93
    url: http://srackham.wordpress.com/2008/05/22/blogpost-media-processing/


 


Here's the [AsciiDoc](http://www.methods.co.nz) blog file that generated this weblog entry:

**blogpost_media_processing.txt**

```
blogpost media processing
=========================

//
// Blog outlining blogpost media processing.
//

'blogpost' 0.9.0 adds lots of new features to the previous 0.1.0
release.  The most important feature in the 'blogpost' 0.9.0 release
is WordPress media file management:

- Media files (images, videos, audio, document) referenced in your
  AsciiDoc (or HTML) documents are automatically uploaded and linked
  to the uploaded blog.
- Only new or modified media files are uploaded (changes detected
  using cached MD5 checksums).
- Metadata caching means post options are remembered and don't need to
  be repeated every time you update your posts.
- WordPress Pages can be posted and updated (blogpost includes a
  patched wordpresslib.py containing Page methods).

pass::[<!--more-->]

This blog post along with this inline image image:smallnew.png[] and
this block image:

image::tiger.png[]

Were uploaded by using this 'blogpost' create command:

---------------------------------------------------------------------
$ blogpost.py create blogpost_media_processing.txt

uploading: /home/srackham/doc/blogs/smallnew.png...
url: http://srackham.files.wordpress.com/2008/05/smallnew.png
uploading: /home/srackham/doc/blogs/tiger.png...
url: http://srackham.files.wordpress.com/2008/05/tiger1.png
creating published post 'blogpost media processing'...
id: 93
url: http://srackham.wordpress.com/2008/05/22/blogpost-media-processing/
---------------------------------------------------------------------

The 'info' command lists locally cached information:

---------------------------------------------------------------------
$ blogpost.py info blogpost_media_processing.txt

title:   blogpost media processing
id:      93
url:     http://srackham.wordpress.com/2008/05/22/blogpost-media-processing/
status:  published
type:    post
doctype: article
created: Thu May 22 17:45:34 2008
updated: Thu May 22 17:45:40 2008
media:   http://srackham.files.wordpress.com/2008/05/tiger1.png
media:   http://srackham.files.wordpress.com/2008/05/smallnew.png
---------------------------------------------------------------------

Note how the update command skips uploading the unchanged image files:

---------------------------------------------------------------------
$ blogpost.py update blogpost_media_processing.txt

skipping: /home/srackham/doc/blogs/smallnew.png
skipping: /home/srackham/doc/blogs/tiger.png
updating published post 'blogpost media processing'...
id: 93
url: http://srackham.wordpress.com/2008/05/22/blogpost-media-processing/
---------------------------------------------------------------------

Here's the http://www.methods.co.nz[AsciiDoc] blog file that generated
this weblog entry:

.blogpost_media_processing.txt
---------------------------------------------------------------------
include::blogpost_media_processing.txt[depth=1]
---------------------------------------------------------------------

The how's and why's are explained on the
http://srackham.wordpress.com/blogpost1/[blogpost(1) man page].
```

The how's and why's are explained on the [blogpost(1) man page](http://srackham.wordpress.com/blogpost1/).
