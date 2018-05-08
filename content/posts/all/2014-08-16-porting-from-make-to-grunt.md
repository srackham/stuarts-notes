---
date: 2014-08-16 03:14:00+00:00
slug: porting-from-make-to-grunt
title: Porting from Make to Grunt
tags:
- grunt
- JavaScript
- Make
---

This post documents my experience porting a [Makefile](https://github.com/srackham/rimu/blob/v3.0.7/Makefile) to a [Gruntfile](https://github.com/srackham/rimu/blob/c1e37b408e0a31d4051229654c2331c6cbc9a49b/Gruntfile.js) in my [Rimu Markup project](https://github.com/srackham/rimu).

**NOTE**: Since first writing this post I have [switched the same project from Grunt to Jake](/posts/switching-from-grunt-to-jake/).

<!--more-->

## Why Grunt

My reasons for porting were to:

  1. Learn about Grunt (it seems to be the de facto nodejs/JavaScript build tool). 
  2. Make the build process cross-platform. 
  3. End up with a build script that is more widely understood. 
  4. End up with a build script that is easier to write, maintain and test. 

## What differentiates Grunt from Make

  * [Grunt](http://gruntjs.com/) is similar to Make in that it provides a mechanism for running tasks (JavaScript functions) along with [helpers](http://gruntjs.com/api/grunt) that assist the definition and execution of tasks. 
  * Unlike Make, Grunt does not have built-in file dependency management and only rudimentary [task dependency management](https://github.com/gruntjs/grunt/issues/968) -- in short Grunt, on it's own, doesn't do a lot. 
  * Grunt files are cross-platform whereas Make files are only cross-platform across UNIX type systems (e.g. Linux, BSD, OSX).  GNU Make can be run under Cgywin on Windows but, in my opinion, it's not as good the real thing. 
  * Gruntfiles can be written in JavaScript or CoffeeScript -- for me this is the biggest advantage over Makefiles (which are an arcane mix of UNIX shell script and Makefile syntax). There's just no comparison between the two when it comes to writing non-trivial scripts especially when coupled with the huge ecosystem of nodejs libraries. 

## Use ShellJS instead of Grunt plugins

My first porting attempt was based on the de facto Grunt scripting model i.e.  _use [Grunt Plugins](http://gruntjs.com/plugins) to run development tools_. I soon became frustrated, for every build tool I wanted to run I had to:

  1. Find a corresponding Grunt plugin (often having to choose from competing plugins). 
  2. Install the plugin and add the `devDependencies` to the `package.json` file. 
  3. Learn the plugin's JSON configuration syntax and mentally map it onto the tool's command-line arguments. 
  4. Load the plugin in the Gruntfile. 
  5. Cross my fingers and hope that the plugin developers keep the plugin bug free and in sync with both new releases of the build tool and Grunt. 

For example, my Makefile's _lint_ target (task) runs a `jshint` command:
    
    lint:
            jshint test/spans.js test/blocks.js bin/rimuc.js


Aside from installing `jshint` that's it, it's that simple -- plus I know exactly what it does because I already know how to use the `jshint` command.

Now consider doing it with Grunt using the `grunt-contrib-jshint` plugin:
    
    grunt.initConfig({
      jshint: {
        files: ['test/spans.js', 'test/blocks.js', 'bin/rimuc.js'],
        options: {
          jshintrc: true
        }
      }
    });
    
    grunt.loadNpmTasks('grunt-contrib-jshint');


All this crazy extra work and stuff to learn for nothing! I was about to pack it in when I discovered [ShellJS](https://github.com/arturadib/shelljs), a great library that gives you cross-platform UNIX-like shell capabilities. The above plugin code can now be replaced by:
    
    grunt.registerTask('lint', 'Lint Javascript files', function() {
      shelljs.exec('jshint test/spans.js test/blocks.js bin/rimuc.js');
    });


No plugin, nothing new to learn, easy to read, easy to verify from command-line -- what's not to like!

See the full [Gruntfile.js](https://github.com/srackham/rimu/blob/c1e37b408e0a31d4051229654c2331c6cbc9a49b/Gruntfile.js) for more examples of the use of ShellJS functions.

## Lessons Learnt

  1. Do not use Grunt plugins that are just wrappers for existing command-line tools (I'm not the only one who thinks this way, see [here](http://blog.millermedeiros.com/node-js-ant-grunt-and-other-build-tools/) and [here](http://blog.keithcirkel.co.uk/why-we-should-stop-using-grunt/). 
  2. Be very selective of the plugins you do use -- weigh carefully plugins verses your own JavaScript code. 
  3. Use the _ShellJS_ library to leverage your existing knowledge and to make your Gruntfiles easily readable by users that are not Grunt experts. 
