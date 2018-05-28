---
date: 2011-10-25 02:53:01+00:00
slug: testing-coffeescript-apps-with-selenium
title: Testing CoffeeScript apps with Selenium
tags:
- coffeescript
- Selenium
---

This blog entry describes how to write functional tests for CoffeeScript web apps using [Selenium](http://seleniumhq.org/). By way of example I'll describe how I added Selenium tests to the [Routeless Backbone Contacts](/posts/routeless-backbone-contacts-2-0/) tutorial app and automated it's execution with a [Cakefile](http://jashkenas.github.com/coffee-script/#cake).

<!--more-->

The source is [on Github](https://github.com/srackham/routeless-backbone-contacts), the tests described in this post are at the _3.0_ tag.

Unit testing frameworks such as [QUnit](http://docs.jquery.com/Qunit) work well for testing libraries, APIs and computational logic but fall short when it comes to testing user interface intensive browser applications, this is where [Selenium](http://seleniumhq.org/) comes in.  The Selenium IDE provides an easy way to functionally test an application user interface in a real browser with exactly the same mouse and keyboard input that a user would enter.

At it's core "Selenium automates browsers" with a macro-like scripting language called Selenese and a Firefox IDE for recording and playing Selenese scripts.  Selenium tests the actual user interface so you record your tests after the user interface has been implemented.

The primary purpose of functional user interface tests is to catch future user interface regressions. The likelihood of user interface regressions at each release increases with the size of the application.

**Selenese**

Selenese is the Selenium IDE scripting language, it is surprisingly powerful:

  * Variables can be stored and manipulated. 
  * You can run JavaScript snippets with the _runScript_ and _waitForCondition_ commands. 
  * The Selenese native format is an HTML table but it can also be exported to languages with Selenium binding (_Python_, _Java_, _C#_). 


## Requisites

To use the Selenium IDE you will need to install:

  * The [Firefox](http://www.mozilla.org/) web browser. 
  * The [Selenium
    IDE](http://seleniumhq.org/docs/02_selenium_ide.html#installing-the-ide).
    Once installed you open the IDE with the Firefox _Tools->Selenium IDE_ menu
    command. 
  * I also installed the [Highlight
    Elements](https://addons.mozilla.org/en-US/firefox/addon/highlight-elements-selenium-id/)
    IDE plugin. 

This post is based on Firefox 7.0.1 (Ubuntu) with Selenium IDE 1.3.0.


## Creating a test

Creating a Selenese test script is a two step process:

  1. [Record](http://seleniumhq.org/docs/02_selenium_ide.html#recording) a
     sequence of user interface interactions (mouse and keyboard inputs). 
  2. Add [asserts and
     verifications](http://seleniumhq.org/docs/02_selenium_ide.html#adding-verifications-and-asserts-with-the-context-menu)
     to the test sequence. This is the step that transforms the browser
     automation sequence into a test. 

The Selenium IDE documentation also explains how to [run](http://seleniumhq.org/docs/02_selenium_ide.html#running-test-cases), [save](http://seleniumhq.org/docs/02_selenium_ide.html#opening-and-saving-a-test-case) and [edit](http://seleniumhq.org/docs/02_selenium_ide.html#editing) tests.

[Here's the test](https://github.com/srackham/routeless-backbone-contacts/blob/3.0/test/test.html) for the tutorial application.

**_Note_**:
To run the tests you will need to open the application in a web server (file based URLs won't work). I use the [Mongoose](http://code.google.com/p/mongoose/) web server for app testing.


### Mongoose web server

The [Mongoose](http://code.google.com/p/mongoose/) web server is a neat little configurationless cross-platform web server that's ideal for testing web apps.

To install Mongoose on Linux:

  1. Unpack and make the source distribution:
    
        tar -xzf mongoose-3.0.tgz
        cd mongoose
        make linux
 
  2. Copy the _mongoose_ executable to somewhere in your _PATH_. 

To use:

  1. Change to your app directory. 
  2. Run mongoose:
    
        mongoose [-i <index-files>]
 
  3. Open your browser at localhost:8080, if an index file exists it will be
     displayed else you'll be presented with a file browser interface. 




## Running tests from the command-line

There's no easy way to open the Selenium IDE and get it to execute a test from
the command-line (at least I couldn't find one), but you can export the tests to
Python (or Java or C#) and then run them from the command-line. Apparently a
JavaScript driver is in the works but not here yet, so I opted for Python.

I like being able to run Python tests from the command-line but I prefer
developing the tests using the IDE. Keeping both in sync can be a challenge but
being able to copy commands from the Selenium IDE to the Python source is a real
help (set the IDE _Options->Clipboard Format->Python 2 (WebDriver)_ option and
you will be able to copy-and-paste IDE commands as Python code).

  1. In addition to the Selenium IDE you will need to install the Python
     bindings for Selenium:
    
     sudo pip install selenium
 
  2. Now export the test from the Selenium IDE to a Python test file using the
     IDE _File->Export Test Case As->Python 2 (WebDriver)_ menu command. 

The exported Python scripts make use of the Python [unit testing framework](http://docs.python.org/library/unittest.html).

### Export anomalies and omissions

The export of Selenese to Python is not perfect, here are some of the manual edits I had to do:

  * Replace:  `# ERROR: Caught exception [ERROR: Unsupported command
    [getConfirmation]]`     with this: `driver.switch_to_alert().accept()`.
    See also the [Selenium
    FAQ](http://code.google.com/p/selenium/wiki/FrequentlyAskedQuestions#Q:_Does_WebDriver_support_Javascript_alerts_and_prompts?).

  * Moved the focus from the search box to fire the search box _change_ event
    (used _click_ command as _focus_ is not supported by Python WebDriver API):
    
        driver.find_element_by_css_selector("input.search").send_keys("sm")
        driver.find_element_by_name("name").click()   # Fire search 'change' event.

See Dynamic UI controls below.

[Here's the Python test](https://github.com/srackham/routeless-backbone-contacts/blob/3.0/test/test.py) for the tutorial.

### Dynamic user interface controls
Incremental search boxes and auto-completing drop-down lists typically emit
keystroke events (up/down/press) to dynamically update other elements in
response to user keyboard entry. The Selenese _type_ command will not work in
this situation.

  * The _typeKeys_ command is designed for these situations but I was unable to
    get it to work. 
  * Nor did the _fireEvent_ command on _keyup_ work. 

The only reliable work-around I could find for testing the incremental _Search_
was to add the _change_ event to the search box and use:
    
    driver.find_element_by_css_selector("input.search").send_keys("sm")
    driver.find_element_by_name("name").click()

The _click_ command moves the focus from the search box to trigger a search box DOM _change_ event.


## Setup and Teardown
At the start of testing you will typically create test fixtures to put the
application in a known state. For data oriented apps this means means populating
the database with fixed data, the [Routeless Backbone
Contacts](/posts/routeless-backbone-contacts-2-0/) application has built-in
_Clear All_ and _Import Data_ commands that serve this purpose.

Built-in _data fixture_ commands are not normally part of an application but
there's no reason not to implement _hidden_ or _debug only_ fixture commands.
Alternatively, if you have moved exclusively to Python scripts for Selenium
testing then, you could setup and teardown fixtures in the traditional fashion
using Python [unittest class and module
fixtures](http://docs.python.org/library/unittest.html#class-and-module-fixtures).


## Cakefile automation
The [Routeless Backbone Contacts](/posts/routeless-backbone-contacts-2-0/)
application is written in
[CoffeeScript](http://jashkenas.github.com/coffee-script/) so it made sense to
automate the tests with a
[Cakefile](http://jashkenas.github.com/coffee-script/#cake). Because _cake_ runs
under [Node.js](http://nodejs.org/) you have a [wealth of
modules](http://search.npmjs.org/) available.

The tutorial
[Cakefile](https://github.com/srackham/routeless-backbone-contacts/blob/3.0/Cakefile)
implements two tasks:

    cake server
         Start the Mongoose server.
    cake test
         Run the Python Selenium test.

**Cakefile**
``` coffee
{exec,spawn} = require 'child_process'

task 'server', 'Start mongoose server', ->
    console.log 'starting mongoose web server...'
    server = spawn 'mongoose', [],
        customFds: [process.stdin, process.stdout, process.stderr]
    process.exit()

task 'test', 'Run tests', ->
    console.log 'starting mongoose web server...'
    server = spawn 'mongoose'
    console.log 'starting tests...'
    exec 'python test/test.py', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        server.kill()   # and exit cake.
```