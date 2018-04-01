---
date: 2010-08-23 06:08:49+00:00
slug: publishing-ebooks-with-asciidoc
title: Publishing eBooks with AsciiDoc
categories:
- AsciiDoc
- DocBook
- eBook
- EPUB
---




It’s easy to write and publish books in [EPUB](http://en.wikipedia.org/wiki/EPUB) and PDF formats using [AsciiDoc](http://www.methods.co.nz/asciidoc/). This article was originally published on the [AsciiDoc website](http://www.methods.co.nz/asciidoc/publishing-ebooks-with-asciidoc.html).

Here are three examples: The first is a minimal example introducing the AsciiDoc format, the second The Brothers Karamazov is a rather long multi-part book and the third The Adventures of Sherlock Holmes includes a front cover image and customized page styling.

<!--more-->

The examples presented below were created on a PC running Xubuntu Linux 10.04 but should be applicable to any UNIX-based operating system.

**Note**:
A number of _asciidoc_ and _a2x_ features used in this article require newer versions of AsciiDoc — version 8.6.5 or better is recommended. The version of [DocBook XSL Stylesheets](http://wiki.docbook.org/topic/DocBookXslStylesheets) used was 1.76.1.


**Tip**:
If you are experiencing _xsltproc_ errors when you run _a2x_ take a look at Francis Shanahan’s [Fixing the ePub problem with Docbook-XSL/A2X/Asciidoc](http://francisshanahan.com/index.php/2011/fixing-epub-problem-docbook-xsl-asciidoc-a2x/) blog post.





## Minimal Book


This didactic example contains a title and two chapters. The AsciiDoc source is a plain text file named minimal-book.txt:


    = The Book Title

    == The first chapter
    Nec vitae mus fringilla eu vel pede sed pellentesque. Nascetur fugiat
    nobis. Eu felis id mauris sollicitudin ut. Sem volutpat feugiat.
    Ornare convallis urna vitae.

    Nec mauris sed aliquam nam mauris dolor lorem imperdiet.

    == The second chapter
    Ut suspendisse nulla. Auctor felis facilisis. Rutrum vivamus nec
    lectus porttitor dui dapibus eu ridiculus tempor sodales et. Sit a
    cras. Id tellus cubilia erat.

    Quisque nullam et. Blandit dui tempor. Posuere in elit diam egestas
    sem vivamus vel ac.



To generate the EPUB formatted book file minimal-book.epub run AsciiDoc’s _a2x_ toolchain wrapper command from the command-line:


    a2x -fepub -dbook minimal-book.txt


The -f option specifies the output format, the -d option specifies the document type (book, article or manpage). The optional --epubcheck option tells _a2x_ to validate the EPUB file using [epubcheck](http://code.google.com/p/epubcheck/). To generate a PDF version (minimal-book.pdf) with _dblatex_ run:


    a2x -fpdf -dbook minimal-book.txt


The distributed example PDFs were built using FOP — if you prefer [FOP](http://xmlgraphics.apache.org/fop/) over [dblatex](http://dblatex.sourceforge.net/) use:


    a2x -fpdf -dbook --fop minimal-book.txt


You can also generate an HTML formatted book, either using DocBook XSL Stylesheets:


    a2x -fxhtml -dbook minimal-book.txt


or directly using the _asciidoc_ command:


    asciidoc -dbook minimal-book.txt


**Note**:
The [a2x toolchain wrapper](http://www.methods.co.nz/asciidoc/a2x.1.html) uses the following programs (most will be available prepackaged for your Linux distribution):




  * [xsltproc](http://xmlsoft.org/XSLT/)


  * [DocBook XSL Stylesheets](http://docbook.sourceforge.net/projects/xsl/)


  * [dblatex](http://dblatex.sourceforge.net/) (PDF file generator)


  * [FOP](http://xmlgraphics.apache.org/fop/) (alternative PDF file generator)


  * [epubcheck](http://code.google.com/p/epubcheck/) (optional EPUB file validator)





## The Brothers Karamazov


_The Brothers Karamazov_ is an example of a multi-part book. To generate the AsciiDoc source I downloaded the [Project Gutenberg](http://www.gutenberg.org) plain text source and edited it manually (this took around 15 minutes). To generate the brothers-karamazov.epub EPUB file run this command:


    a2x brothers-karamazov.txt





Brothers Karamazov source files and eBooks:

**EPUB**:
[brothers-karamazov.epub](http://www.methods.co.nz/misc/examples/books/brothers-karamazov.epub)

**PDF**:
[brothers-karamazov.pdf](http://www.methods.co.nz/misc/examples/books/brothers-karamazov.pdf)

**AsciiDoc source**:
[brothers-karamazov.zip](http://www.methods.co.nz/misc/examples/books/brothers-karamazov.zip)

**Project Gutenburg text**:
[http://www.gutenberg.org/etext/28054](http://www.gutenberg.org/etext/28054)



Here’s the start of the AsciiDoc source file showing the AsciiDoc specific meta-data:


    //
    // Text from Project Gutenburg http://www.gutenberg.org/etext/28054
    //
    // Formatted for AsciiDoc by Stuart Rackham.
    //
    // a2x default options.
    //    a2x: -f epub -d book --epubcheck
    // Suppress revision history in dblatex outputs.
    //    a2x: --dblatex-opts "-P latex.output.revhistory=0"
    // Suppress book part, chapter and section numbering in DocBook XSL outputs.
    //    a2x: --xsltproc-opts
    //    a2x: "--stringparam part.autolabel 0
    //    a2x: --stringparam chapter.autolabel 0
    //    a2x: --stringparam section.autolabel.max.depth 0"
    //

    = The Brothers Karamazov
    :author: Fyodor Dostoyevsky
    :encoding: iso-8859-1
    :plaintext:

    ..........................................................................
    Translated from the Russian of Fyodor Dostoyevsky by Constance Garnett
    The Lowell Press New York

     :
     :

    ***START OF THE PROJECT GUTENBERG EBOOK THE BROTHERS KARAMAZOV***
    ..........................................................................

    = PART I

    == The History Of A Family

    === Fyodor Pavlovitch Karamazov

    Alexey Fyodorovitch Karamazov was the third son of Fyodor Pavlovitch
    ...




  * The book, book part and chapter titles have been edited to conform to [AsciiDoc title conventions](http://www.methods.co.nz/asciidoc/userguide.html#X17).


  * Book part titles must be level zero titles:


    = Book title (level 0)
    = Part one title (level 0)
    == Chapter 1 title (level 1)
      :





  * Sub-chapter levels can be accommodated with ===, ==== and ===== title prefixes.


  * In this example the _Project Gutenberg_ front matter was put in the untitled preface inside an AsciiDoc literal block.


  * The comment lines starting with // a2x: contain _a2x_ command options for this document (it’s easier to put them in the document once than type them every time on the command-line).


  * A number of _xsltproc_ options are passed to _a2x_ to suppress book part, chapter and section numbering.


  * Setting the AsciiDoc _plaintext_ attribute suppresses most of [AsciiDoc’s text formatting](http://www.methods.co.nz/asciidoc/userguide.html#_text_formatting)and substitution conventions, this allows large amounts of text to be imported with little or no manual editing.

    * Once you have defined the AsciiDoc _plaintext_ attribute the only requisite manual editing will be to format the titles and rectify the odd paragraph being interpreted as some other AsciiDoc block element.

    * In the combined 49 thousand lines of imported _Sherlock Holmes_ and _Brothers Karamazov_ text I only encountered two misinterpreted list items, neither affected the rendered output or necessitated editing.

    * You can selectively enable and disable the _plaintext_ attribute throughout your document using AsciiDoc [attribute entries](http://www.methods.co.nz/asciidoc/userguide.html#X18).



## The Adventures of Sherlock Holmes


This book includes a front cover image and a customized page design. To generate the adventures-of-sherlock-holmes.epub EPUB file run this command:


    a2x adventures-of-sherlock-holmes.txt

**EPUB**:
[adventures-of-sherlock-holmes.epub](http://www.methods.co.nz/misc/examples/books/adventures-of-sherlock-holmes.epub)

**PDF**:
[adventures-of-sherlock-holmes.pdf](http://www.methods.co.nz/misc/examples/books/adventures-of-sherlock-holmes.pdf)

**AsciiDoc source**:
[adventures-of-sherlock-holmes.zip](http://www.methods.co.nz/misc/examples/books/adventures-of-sherlock-holmes.zip)

**Project Gutenburg text**:
[http://www.gutenberg.org/etext/1661](http://www.gutenberg.org/etext/1661)


Here’s a screenshot of the first page of the first chapter (rendered by the [Firefox EPUBReader addon](http://www.epubread.com/en/)):


![images/epub.png](/images/epub.png)


The [AsciiDoc source Zip file](http://www.methods.co.nz/misc/examples/books/adventures-of-sherlock-holmes.zip) contains the following files:



**`adventures-of-sherlock-holmes.txt`**<br>
    The AsciiDoc source (derived from the [Project Gutenberg plain text source](http://www.gutenberg.org/etext/1661)).

**`adventures-of-sherlock-holmes.jpg`**<br>
    The front cover image.

**`adventures-of-sherlock-holmes-docinfo.xml`**<br>
    A [docinfo](http://www.methods.co.nz/asciidoc/userguide.html#X87) file containing DocBook markup for the front cover image and the Project Gutenberg frontmatter. DocBook XSL Stylesheets identifies the book cover image by the role="cover" attribute in the DocBook mediaobject element.

**`adventures-of-sherlock-holmes.css`**<br>
    CSS rules for styling the page layout. The design is based on the [ePub Zen Garden](http://epubzengarden.com) _Gbs_ style. Because this file is not named docbook-xsl.css the name must be specified explicitly using the _a2x_ --stylesheet option.

**`underline.png`**<br>
    A title underline image that is used by the CSS stylesheet. This resource has to be explicitly passed to _a2x_ because _a2x_ only searches HTML files for resources.

Here’s the start of the AsciiDoc source file showing the AsciiDoc specific meta-data:


    //
    // Text from Project Gutenburg http://www.gutenberg.org/etext/1661
    //
    // Formatted for AsciiDoc by Stuart Rackham.
    //
    // a2x default options.
    //    a2x: -f epub -d book -a docinfo --epubcheck
    //    a2x: --stylesheet adventures-of-sherlock-holmes.css
    // Suppress revision history in dblatex outputs.
    //    a2x: --dblatex-opts "-P latex.output.revhistory=0"
    // Suppress book part, chapter and section numbering in DocBook XSL outputs.
    //    a2x: --xsltproc-opts
    //    a2x: "--stringparam part.autolabel 0
    //    a2x: --stringparam chapter.autolabel 0
    //    a2x: --stringparam section.autolabel.max.depth 0"
    // Additional resources.
    //    a2x: --resource underline.png
    //

    = The Adventures of Sherlock Holmes
    :author: Sir Arthur Conan Doyle
    :encoding: iso-8859-1
    :plaintext:

    == A Scandal in Bohemia

    To Sherlock Holmes she is always THE woman. I have seldom heard
    ...



The manual editing of imported plain text involves formatting the title and chapter names as [AsciiDoc titles](http://www.methods.co.nz/asciidoc/userguide.html#X17) (in this example we’ve used the _single line_ title format). Sherlock Holmes only has two title levels:


    = The Adventures of Sherlock Holmes
    == A Scandal in Bohemia
    == The Red-Headed League
    == A Case of Identity
    == The Boscombe Valley Mystery
    == The Five Orange Pips
    == The Man with the Twisted Lip
    == The Adventure of the Blue Carbuncle
    == The Adventure of the Speckled Band
    == The Adventure of the Engineer's Thumb
    == The Adventure of the Noble Bachelor
    == The Adventure of the Beryl Coronet
    == The Adventure of the Copper Beeches
    == Colophon


## Styling your books


You can customize the appearance of a document with CSS. CSS file. Either create your own or copy and edit the existing default docbook-xsl.css file (located in the AsciiDoc stylesheets configuration directory) then place it in the same directory as your AsciiDoc source file. Use the _a2x_ --stylesheet option if you want to use a different stylesheet file. Take a look at the adventures-of-sherlock-holmes.css CSS file.

There are some great examples of EPUB book styles at [ePub Zen Garden](http://epubzengarden.com/).

## Including embedded fonts


See [this FAQ](http://www.methods.co.nz/asciidoc/faq.html#X5).


## Reading EPUB documents


My current favorite software epub reader is the [Firefox EPUBReader addon](http://www.epubread.com/en/). EPUBReader honors the book’s CSS styling rules and renders the page as the author intended (many EPUB readers only process a sub-set of CSS styling rules).

Browsers are a natural fit for EPUB (EPUB is just a bunch of zipped XHTML files) — I’d love to see browsers support EPUB natively.

As of writing this article most eBook readers (with the notable exception of Amazon’s Kindle) support the EPUB format.


## Non-fiction Books and Manuals


AsciiDoc supports a rich set of markup conventions and can generate reference works and technical manuals complete with tables, illustrations, indexes, bibliographies and appendices. All the examples on the [AsciiDoc web site](http:///www.methods.co.nz/asciidoc/) can be formatted as EPUB eBooks.
