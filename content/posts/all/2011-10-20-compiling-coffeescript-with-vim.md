---
date: 2011-10-20 00:06:02+00:00
slug: compiling-coffeescript-with-vim
title: Compiling CoffeeScript with Vim
tags:
- coffeescript
- Less
- Stylus
- Vim
---

You can configure Vim to automatically compile
[CoffeeScript](http://jashkenas.github.com/coffee-script/) files when you save
them from within Vim, it's easy, just add an _autocmd_ to run the CoffeeScript
compiler to your `~/.vimrc` file:

<!--more-->
    
    autocmd BufWritePost,FileWritePost *.coffee silent !coffee -c <afile>

I prefer this to the CoffeeScript compiler `--watch` option because you get to
see any compiler errors in the editor when you save the CoffeeScript source
file.

In a similar vein the following two Vim auto-commands will compile
[Less](http://lesscss.org/) and [Stylus](http://learnboost.github.com/stylus/)
files to CSS:
    
    autocmd BufWritePost,FileWritePost *.less silent !lessc <afile> <afile>:r.css
    autocmd BufWritePost,FileWritePost *.styl silent !stylus <afile> >/dev/null

**_Tip_**: Use _Ctrl+L_ to clear any compiler errors and redraw the screen or
delete the _silent_ option from the Vim _autocmd_.


This technique works, but what happens if you want to selectively include
CoffeeScript compiler options with some files and not others? I came up against
this problem writing [QUnit](http://docs.jquery.com/Qunit) tests using
CoffeeScript which must be compiled without the top-level function wrapper using
the `--bare` command-line option.

My solution was to take a cue from Vim's _mode line_ feature and write a
CoffeeScript compiler wrapper shell script which scans the end of the
CoffeeScript source file for a comment line starting with _# coffee:_, it then
passes the remainder of the line to the CoffeeScript compiler as command-line
options. Here's a basic CoffeeScript QUnit test file specifying the `--bare`
option in the trailing mode line:
    
``` coffee
module 'Test'

test 'addition', ->
    equals 1+1, 2, 'one and one is two'

# coffee: --bare
```

And here's the `coffee.sh` wrapper script:
    
``` sh
    #!/bin/sh
    #
    # 'Mode line' wrapper for CoffeeScript 'coffee' compiler command.
    #
    # Executes CoffeeScript compiler and includes compiler options from line at the
    # end of the CoffeeScript source file starting with '# coffee:' (c.f. Vim mode
    # lines).
    #
    
    # Last argument is the source file name.
    for srcfile; do true; done
    
    # Search the last 5 lines in the source for a mode line and extract the
    # trailing coffee command options.
    # Default to the --compile option.
    pat='^#\s*coffee:'
    opts=$(tail -n5 $srcfile | grep "$pat" | sed "/$pat/s/$pat//")
    opts=$(echo $opts | sed -r -e 's/^ *//' -e 's/ *$//')   # Trim spaces.
    if [ -z "$opts" ]; then
        opts="--compile"
    fi
    
    coffee $opts $@
```

You also need to change `coffee` to `coffee.sh` in your `~/.vimrc` _autocmd_
plus you need to ensure both `coffee` to `coffee.sh` are in your shell search
`PATH`:
    
    autocmd BufWritePost,FileWritePost *.coffee !coffee.sh -c <afile>

**_Tip_**: If you don't want to generate a compiled JavaScript file (for
example, Jake and Cake CoffeeScript files) use the `--lint` option:
    
    # coffee: --lint


 


