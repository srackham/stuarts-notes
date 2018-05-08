---
date: 2011-04-28 22:59:05+00:00
slug: w3c-command-line-validator
title: W3C Command-line Validator
tags:
- python
- validator
- W3C
---

A command-line script (written in Python) for validating HTML and CSS files and URLs using the WC3 validators.

<!--more-->

The w3c-validator.py script uses the curl(1) command to submit HTML files and URLs to the [W3C Markup Validation Service](http://validator.w3.org/) and CSS files and URLs to the [W3C CSS Validation Service](http://jigsaw.w3.org/css-validator/).  The script parses and reports the JSON results returned by the validators.




**_Note_**:
Currently the CSS validator's JSON output option is experimental and not formally documented.


You can find the source on GitHub at [https://github.com/srackham/w3c-validator](https://github.com/srackham/w3c-validator)



## Usage

The script command syntax is:
    
    python w3c-validator.py [--verbose] FILE|URL...


 

  * The optional --verbose option will print information about what is going on internally. 
  * Names with a .css extension are treated as CSS, all other names are assumed to contain HTML. 
  * Names starting with http:// are assumed to be publically accessible URLs, all other names are assumed to be local file names. 
  * Any mix of one or more local files or HTTP URLs can be specified. 
  * If one or more files fail validation then the exit status will be 1, if no errors occurs the exits status will be zero. 

Examples (w3c-validator is just a convenient symbolic link in the shell _PATH_ to the executable w3c-validator.py script):



    
    $ w3c-validator tests/data/testcases-html5.html
    validating: tests/data/testcases-html5.html ...
    error: line 822: The tt element is obsolete. Use CSS instead.
    error: line 829: The tt element is obsolete. Use CSS instead.
    error: line 838: The tt element is obsolete. Use CSS instead.

    $ w3c-validator http://www.methods.co.nz/asciidoc/layout1.css
    validating: http://www.methods.co.nz/asciidoc/layout1.css ...


 




## Resources

  * [User's guide for the W3C Markup Validator](http://validator.w3.org/docs/users.html). 
  * [CSS Validator User's Manual](http://jigsaw.w3.org/css-validator/manual.html). 



## Prerequisites

  * Python. 
  * Curl (the curl(1) command must be in the shell _PATH_). 
  * An Internet connection. 

Written and tested on Xubuntu 10.04 with Python 2.6.5, should work on other Python platforms.
