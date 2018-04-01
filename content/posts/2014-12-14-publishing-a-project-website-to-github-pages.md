---
date: 2014-12-14 02:10:13+00:00
slug: publishing-a-project-website-to-github-pages
title: Publishing a project website to Github Pages
categories:
- Github
---

I recently was faced with moving the website of one of my Github hosted projects from its current non-Github location to Github Pages.

<!--more-->

At first glance publishing a project website to [Github pages](https://pages.github.com/) appears fiddly and error prone because you have to bounce between normal code branches and the Github Pages  branch which have completely different files and directory structures. This is even trickier when your project's build workflow also builds your web pages (as mine does).

I initially tried `git-subtree` techniques for GitHub Pages deployment (see [here](http://stevenclontz.com/blog/2014/05/08/git-subtree-push-for-deployment/), [here](https://gist.github.com/cobyism/4730490) and [here](http://yeoman.io/learning/deployment.html)) but found them brittle and arcane. Then I came across [this Github Gist](https://gist.github.com/chrisjacob/825950) which neatly solved the problem viz.  keep your code branches in one local repository and the `gh-pages` branch in another. Locate the Github Pages repo on an ignored `gh-pages` sub-directory of the local code branches repository.

  * Both local repositories use the same remote Github repository: the local code repository contains code branches, the local website repository contains only the `gh-pages` branch. 
  * Typically the project build process generates the project website pages in HTML format which it copies to the local `gh-pages` sub-directory (along with any other generated webpage assets). 
  * To publish the Github Pages repo: 
    1. Change directory to the `gh-pages` sub-directory. 
    2. Commit the changes and push them to the `gh-pages` branch at Github. 
    3. Then cd back up to the project root and continue coding. 

The steps to achive this are outlined below and were based on this [Github Gist](https://gist.github.com/chrisjacob/825950) (the Gist assumes the `gh-pages` branch already exists in the Github repo whereas my example does not).

Before starting it is assumed that:

  * Your project code has already been published to Github. 
  * Your local project repository is up to date  with the remote Github repo. 
  * The `gh-pages` branch has not yet been created either locally or remotely. 

The following commands add a local repo in the `gh-pages` sub-directory and then creates a `gh-pages` branch which is pushed to Github (`<username>` and `<projectnames>` refer to your Github user name and project name respectively):
    
    # Go to local project code repository.
    $ cd myproject
     
    # Code repo ignores the documentation repo.
    $ echo gh-pages/ >> .gitignore
     
    # Make another repo in gh-pages sub-directory.
    # There is nothing magic about the sub-directory name, it can be anything you like.
    $ git clone https://github.com/<username>/<projectname>.git gh-pages
     
    # Create gh-pages branch and push it to Github.
    # See https://help.github.com/articles/creating-project-pages-manually/
    $ cd gh-pages
    $ git checkout --orphan gh-pages
    $ git rm -rf .
    $ echo "Nothing to see yet, move along..." > index.html
    $ git add index.html
    $ git commit -am "First pages commit"
    $ git push origin gh-pages
    $ git branch -u origin/gh-pages   # Track gh-pages branch on remote.
     
    $ git branch -D master  # We don't need code branches.
    $ cd ..                 # Return to code repo.

The documentation can be viewed at `http://<username>.github.io/<projectname>` (keep in mind that it can take up to 30 minutes for the web pages to appear at Github the first time after creating the `gh-pages` remote branch).

If your project already has an existing `gh-pages` branch the above can be reduced to:
    
    $ cd <projectname>
    $ echo gh-pages/ >> .gitignore
    $ git clone --branch gh-pages https://github.com/<username>/<projectname>.git gh-pages

From here on you treat the local Github Pages repo just like any other Github repository except that when you push it to Gitub you use the `gh-pages` branch name:
    
    $ git push origin gh-pages

Here's [an example bash script](https://github.com/srackham/flux-backbone-todo/blob/master/deploy-gh-pages.sh)  that I use to automate deployment of the `gh-pages` branch.

On a side-note, you can use a custom domain name for your project's Github Pages website by adding a `CNAME` file to the `gh-pages` branch -- see [the Github documentation](https://help.github.com/articles/adding-a-cname-file-to-your-repository/) for details.
