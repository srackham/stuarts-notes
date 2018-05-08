---
date: 2011-07-08 02:19:37+00:00
slug: coffeescript-for-command-line-apps
title: CoffeeScript for Command-line Apps
tags:
- clickatell
- coffeescript
- commandline
- nodejs
- sms
---

**Updated**: 2011-10-27: published the app to [github](https://github.com/srackham/clisms) and the [npm registry](http://search.npmjs.org/#/clisms).

This post details my learning experience porting a [command-line application](/posts/command-line-sms-script/) I previously wrote in Python to [CoffeeScript](http://jashkenas.github.com/coffee-script/).

<!--more-->

I won't describe how the SMS application works or how to use it, you can find this in a separate post describing the [Python version](/posts/command-line-sms-script/).

The clisms.coffee source code is [on github](https://github.com/srackham/clisms/blob/master/clisms.coffee), the shebang line allows it to be executed directly (provided you have the _coffee_ compiler installed), or you could compile it separately to JavaScript (using the cake build command). The program does the typical things most command-line apps do: process command-line args; read environment variables; read/write files; shell other apps.



## Learning and using CoffeeScript

CoffeeScript is surprisingly well documented for such a new language. If you know Python, Ruby and JavaScript you'll learn it in a couple of hours. Here are resources I found useful:

  * [CoffeeScript website](http://jashkenas.github.com/coffee-script/). 
  * Watch [this video](http://blip.tv/jsconf/jsconf2011-jeremy-ashkenas-5258082). 
  * Wikipedia: [http://en.wikipedia.org/wiki/CoffeeScript](http://en.wikipedia.org/wiki/CoffeeScript)
  * A list of [CoffeeScript resources](http://documentcloud.github.com/underscore/). 
  * [CoffeeScript wiki](https://github.com/jashkenas/coffee-script/wiki). 
  * [Smooth CoffeeScript](http://autotelicum.github.com/Smooth-CoffeeScript/) is a free CoffeeScript book. 
  * [CoffeeScript Cookbook](http://coffeescriptcookbook.com/). 
  * I also found the [CoffeeScript](http://pragprog.com/book/tbcoffee/coffeescript) book from the Pragmatic Bookshelf a good read. 

Libraries can make or break scripting languages.  CoffeeScript uses JavaScript libraries so you'll need to be familiar with JavaScript. The foremost client-side library is the [NodeJS](http://nodejs.org/) API. I was able to write clisms.coffee using just the NodeJS API. The NodeJS API is reasonably well documented though on occasion you may find it necessary to consult the NodeJS source.

  * [NodeJS wiki](https://github.com/joyent/node/wiki). 
  * [NodeJS API documentation](http://nodejs.org/docs/latest/api/). 
  * [NodeJS library source](https://github.com/joyent/node/tree/master/lib). 
  * The [npm registry](http://search.npmjs.org/) is a great source of other Node compatible JavaScript libraries. 

I found the hardest part was not CoffeeScript itself but getting used to the NodeJS asynchronous I/O paradigm -- once you've twigged it's not much harder to write or understand it's just different.



## Impressions of CoffeeScript

The port from Python went smoothly, much of the time being spent hunting around for equivalent JavaScript library functions.

I would characterise CoffeeScript as having borrowed the best features of Python and Ruby to synthesise an entirely new language that compiles to JavaScript and retains JavaScript semantics.

I'm quite smitten by CoffeeScript, it's incredibly expressive and has that ineffable "just right" feel about it, no rough edges, no surprises, everything just works -- hats off to Jeremy Ashkenas, CoffeeScript's creator.

Unlike JavaScript, which I've only ever coded out of necessity, writing in CoffeeScript is a pleasurable experience. Would I recommend CoffeeScript as a general purpose scripting language?  Absolutely, especially with the recent surge in development of JavaScript libraries.
