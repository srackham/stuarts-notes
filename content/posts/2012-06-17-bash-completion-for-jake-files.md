---
date: 2012-06-17 20:41:05+00:00
slug: bash-completion-for-jake-files
title: Bash completion for Jake files
categories:
- bash
- jake
---

To implement [bash(1) tab completion](http://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html#Programmable-Completion) for [Jakefile](https://github.com/mde/jake) task names all you need to do is add this completion function and command to your `~/.bashrc` file:

<!--more-->

See also my previous post [Bash completion for cake files](https://srackham.wordpress.com/2011/11/01/bash-completion-for-cake-files/).

    # Task name completion for Jake files.
    function _jake() {
        local cur tasks
        cur=${COMP_WORDS[COMP_CWORD]}
        # The sed command strips terminal escape sequences.
        tasks=$(jake -T \
              | sed -r 's/\x1b[[()=][;?0-9]*[0-9A-Za-z]?//g' \
              | awk '{print $2}')
        if [ $COMP_CWORD -eq 1 ]; then
            # Task name completion for first argument.
            COMPREPLY=( $(compgen -W "$tasks" $cur) )
        else
            # File name completion for other arguments.
            COMPREPLY=( $(compgen -f $cur) )
        fi
    }
    complete -o default -F _jake jake j


Now it you type `jake <Tab>` at the bash command prompt you will get a list of tasks from the current `Jakefile`.  As with all bash completions, if you start typing a name and press Tab then bash will complete the name for you.

To cut down key strokes I've also added a _j_ alias for _jake_ to `~/.bashrc`:

    alias j='jake'
