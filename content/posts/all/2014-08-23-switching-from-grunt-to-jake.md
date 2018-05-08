---
date: 2014-08-23 01:48:19+00:00
slug: switching-from-grunt-to-jake
title: Switching from Grunt to Jake
tags:
- grunt
- jake
- JavaScript
- Make
---

This post discusses why I switched my Rimu Markup project's build tool to [Jake](http://jakejs.com/), having previously [ported the same project from Make to Grunt](/posts/porting-from-make-to-grunt/).

<!--more-->

**NOTE**: This post has been revised since original publication to more clearly explain Jake synchronicity and to show how I now process task shell commands in parallel.


## Why Jake instead of Grunt

Jake (like Grunt) is a JavaScript application for building JavaScript projects. Jake is modeled after [Rake](https://github.com/jimweirich/rake) (a Make-like program implemented in Ruby). If you know Rake or Make you'll be right at home with Jake.

Grunt is currently the most popular JavaScript build tool and this is one of the reasons I first ported my project to Grunt, but at the end of the day Grunt's limitations and its philosophical bent pushed me to Jake.

Here's why I switched to Jake:

  * Grunt is plugin-centric -- its default usage paradigm is _plugins and configuration over scripting_ -- this is one of those things that sounds good in theory but is not so good in practice (see my [previous post](/posts/porting-from-make-to-grunt/)). 
  * Jake files are JavaScript code which is more readable and (crucially) more flexible than Grunt's JSON configuration file format. 
  * Grunt does not have built-in file dependency management and only rudimentary [task dependency management](https://github.com/gruntjs/grunt/issues/968) -- dependency management is what build tools should be all about and these are real deficiencies (especially if you come from Make, Rake or Jake). 

So why isn't Jake more popular? The [herd mentality](http://en.wikipedia.org/wiki/Herd_mentality) aside, I think part of the answer is that Jake is not as immediately accessible as Grunt -- the Grunt website does an excellent job of introducing Grunt and getting users started. Another reason may be that the command-line is not the primary UI for many Windows developers.

Here's the full [Jakefile.js](https://github.com/srackham/rimu/blob/v3.0.10/Jakefile.js) and here's the legacy [Gruntfile.js](https://github.com/srackham/rimu/blob/c1e37b408e0a31d4051229654c2331c6cbc9a49b/Gruntfile.js).

## Task synchronicity

**Tasks should execute serially, but shell commands within a task should be run in parallel**.

Shell commands executed with `jake.exec` (or Node's `child_process.exec`) are synchronous i.e. they return immediately after starting the command -- command completion is handled with callbacks. This can be good because it allows you to execute multiple shell commands in parallel, but it can also be bad because the next task will start before the current task has completed.  Task dependencies become impossible to manage unless tasks execute sequentially.

Jake has a [clever technique](http://jakejs.com/docs#tasks) for ensuring that tasks with asynchronous code execute sequentially (i.e. the next task is not started until the current task has finished)): Set the task's `async` option to `true` and then call `complete()` once all task processing has finished (this signals Jake that the task is done and the next task can be started). Making all tasks execute sequentially also ensures task dependencies are run in declaration order.

I wrote the following `exec` wrapper task to execute multiple shell commands in parallel:
    
    /*
      Execute shell commands in parallel then run the callback when they have all finished.
      `callback` defaults to the Jake async `complete` function.
      Abort if an error occurs.
      Write command output to the inherited stdout (unless the Jake --quiet option is set).
      Print a status message when each command starts and finishes (unless the Jake --quiet option is set).
    
      NOTE: This function is similar to the built-in jake.exec function
      but is twice as fast.
    */
    function exec(commands, callback) {
      if (typeof commands === 'string') {
        commands = [commands];
      }
      callback = callback || complete;
      var remaining = commands.length;
      commands.forEach(function(command) {
        jake.logger.log('Starting: ' + command);
        child_process.exec(command, function (error, stdout, stderr) {
            jake.logger.log('Finished: ' + command);
            if (!jake.program.opts.quiet) {
              process.stdout.write(stdout);
            }
            if (error !== null) {
              fail(error, error.code);
            }
            remaining--;
            if (remaining === 0) {
              callback();
            }
          });
        });
    }


 

Here's an example of its use (`SOURCE` is an array of TypeScript source file names):
    
    desc('Lint TypeScript source files.');
    task('tslint', {async: true}, function() {
      var commands = SOURCE.map(function(file) { return 'tslint -f ' + file; });
      exec(commands);
    });


 

By default `exec` executes the Jake `complete` function once all shell commands have finished. The above example runs over seven times faster than it would if the `tslint` commands were run sequentially.

## Use jake.exec to run interactive tasks

For example if you want your Git commit task to solicit your commit message using the editor:
    
    jake.exec('git commit -a', {interactive: true}, complete);


## Use file tasks to suppress unnecessary commands

Use Jake [file tasks](http://jakejs.com/docs#tasks_file-tasks) to avoid rerunning commands whose prerequisite files have not changed -- typically doing things like compiling and documention generation. For example the Rimu project build command executes up to twice as fast using file tasks (the Jake `-B` option forces unconditional task execution):
    
    $ time jake build -B -q
    
    real    0m17.280s
    user    0m8.909s
    sys     0m7.580s
    
    $ time jake build -q
    
    real    0m7.939s
    user    0m4.112s
    sys     0m5.204s


## Use shell commands not plugins

Use the _ShellJS_ library to leverage your existing knowledge and to make your Jakefiles easier to read.  Plugins are a systemic problem and I avoid them like the plague -- see [Use ShellJS instead of Grunt plugins](/posts/porting-from-make-to-grunt/).

## What about Gulp?

Gulp is the new kid on the block and is kind of interesting:

  * Gulp configuration files are JavaScript code (a Node.js application). 
  * Gulp tasks are composed using Node.js streams which is quite different to Grunt's sequential task-by-task execution. 

I ported my Rimu Jake file to Gulp but abandoned the effort because of plugin problems.

## References

  * [Intro to Jake](http://howtonode.org/intro-to-jake). 
  * [Jake website](http://jakejs.com/). 
  * [Introducing Jake](http://www.cappuccino-project.org/blog/2010/04/introducing-jake-a-build-tool-for-javascript.html). 
