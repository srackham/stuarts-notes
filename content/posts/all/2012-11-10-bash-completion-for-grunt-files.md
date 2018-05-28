---
date: 2012-11-10 21:46:17+00:00
slug: bash-completion-for-grunt-files
title: Bash completion for Grunt files
tags:
- bash
- grunt
---

I modified my [cake bash completion script](https://srackham.wordpress.com/2011/11/01/bash-completion-for-cake-files/) for [Grunt](http://gruntjs.com/).

<!--more-->

All you need to do is add this completion function and command to your `~/.bashrc` file:

``` bash
# Task name completion for grunt files.
function _grunt() {
    local cur tasks
    cur=${COMP_WORDS[COMP_CWORD]}
    # Extract list of task names from help text.
    tasks="$(grunt --help --no-color | awk 'task==1 {print $1} /Available tasks/ {task=1} /^$/ {task=0}')"
    if [ $COMP_CWORD -eq 1 ]; then
        # Task name completion for first argument.
        COMPREPLY=( $(compgen -W "$tasks" $cur) )
    else
        # File name completion for other arguments.
        COMPREPLY=( $(compgen -f $cur) )
    fi
}
complete -o default -F _grunt grunt g
```

Now it you type `grunt <Tab>` at the bash command prompt you will get a list of tasks from the current Grunt file.  As with all bash completions, if you start typing a name and press Tab then bash will complete the name for you.

To cut down key strokes I've also added a _g_ alias for _grunt_ to `~/.bashrc`:

    alias g='grunt'

