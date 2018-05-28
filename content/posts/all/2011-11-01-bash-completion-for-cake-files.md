---
date: 2011-11-01 02:37:46+00:00
slug: bash-completion-for-cake-files
title: Bash completion for cake files
tags:
- bash
- cake
- coffeescript
---

To implement [bash(1) tab completion](http://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html#Programmable-Completion) for [Cakefile](http://jashkenas.github.com/coffee-script/#cake) task names all you need to do is add this completion function and command to your `~/.bashrc` file:

<!--more-->



``` js  
# Task name completion for cake files.
function _cake() {
    local cur tasks
    cur="${COMP_WORDS[COMP_CWORD]}"
    tasks=$(cake 2>/dev/null | awk '{print $2}')
    if [ $COMP_CWORD -eq 1 ]; then
        # Task name completion for first argument.
        COMPREPLY=( $(compgen -W "$tasks" $cur) )
    else
        # File name completion for other arguments.
        COMPREPLY=( $(compgen -f $cur) )
    fi
}
complete -o default -F _cake cake c
```

Now it you type `cake <Tab>` at the bash command prompt you will get a list of tasks from the current `Cakefile`.  As with all bash completions, if you start typing a name and press Tab then bash will complete the name for you.

To cut down key strokes I've also added a _c_ alias for _cake_ to `~/.bashrc`:
    
    alias c='cake'

This recipe was taken from [An introduction to bash completion: part 2](http://www.debian-administration.org/article/An_introduction_to_bash_completion_part_2) and modified for _cake_.

See also my subsequent post [Bash completion for Jake files](https://srackham.wordpress.com/2012/06/17/bash-completion-for-jake-files/).
