---
date: "2014-12-30T19:31:33+13:00"
slug: porting-my-blog-with-hugo
title: "Porting my blog with Hugo"
categories:
- "Hugo"
- "Github"
- "Jekyll"
---

I've just ported [my Wordpress blog](http://srackham.wordpress.com/) to [Github Pages](https://pages.github.com/) using [Hugo](http://gohugo.io/).

<!--more-->

## Why not use Jekyll?
[Jekyll](http://jekyllrb.com/) is currently the de facto choice for
building Github hosted static websites, I choose Hugo (after first
trying Jekyll) primarily because, for me,  Hugo has an ineffable
_Goldilocks_ quality.  Post facto rationale:

- Hugo is [much
  faster](http://fredrikloch.me/post/2014-08-12-Jekyll-and-its-alternatives-from-a-site-generation-point-of-view/)
  than Jekyll.
- Hugo has a really useful `--watch` option.
- With Jekyll you have to install and maintain the Ruby/Rake/Gems ecosystem -- Hugo is just a single executable with no dependencies.


## Choosing a theme
My objective requirements were:

1. Phone and tablet friendly.
2. Minimal customization required (I find HTML/CSS twiddling such a
   time sink).
3. Straight-forward and uncluttered appearance.

The hard part is largely subjective: finding a look and feel that you
actually like (look and feel is notoriously subtle and personal).
After lots of trawling the Web I stumbled on a [Hugo
port](http://sglyon.com/hugo_gh_blog/) of the [Jekyll Lanyon
theme](http://lanyon.getpoole.com/) -- it is really nice and by happy
coincidence is the basis for the excellent Hugo tutorial [Hosting on
GitHub Pages](http://gohugo.io/tutorials/github_pages_blog/) by
[Spencer Lyon](http://sglyon.com/). The example repo is [on
Github](https://github.com/spencerlyon2/hugo_gh_blog).

My blog's Github repository can be found [here](https://github.com/srackham/stuarts-notes).


## Implementation and Deployment
Couldn't be easier: All you have to do is read and follow the [Hosting
on GitHub Pages](http://gohugo.io/tutorials/github_pages_blog/)
tutorial.

### Additional notes
- Edit URLs in `config.yaml` and `deploy.sh` to reflect those of your Github repository.

- After cloning the [example repo](https://github.com/spencerlyon2/hugo_gh_blog) you can start from scratch with:

        rm -rf .git
        git init
        git add --all
        git commit -am "Initial commit of pristine https://github.com/spencerlyon2/hugo_gh_blog master."

- After creating an empty repo on Github push your local repo master to Github with (use your own Git URL though):

        git remote add origin git@github.com:srackham/stuarts-notes.git
        git push -u origin master

- I got errors trying to set up the `gh-pages` subtree branch using steps outlined in the [Hosting on GitHub Pages](http://gohugo.io/tutorials/github_pages_blog/) tutorial. A much easier solution is given [here](https://gist.github.com/cobyism/4730490) -- just push the `public` subtree to `gh-pages`, when you do this for the first time local and remote `gh-pages` branches are created automatically
(i.e. there's no need to explicitly setup the `gh-pages` branch, just run the `deploy.sh` script):

        git subtree push --prefix public origin gh-pages

- Before running `deploy.sh` make sure any files you not want in your repository are excluded by your `.gitignore` file

- I configured a custom domain name (`http://blog.srackham.com/`) for my blog's Github Pages website by adding a `CNAME` file to the `static` directory -- see [the Github documentation](https://help.github.com/articles/adding-a-cname-file-to-your-repository/) for details.

- There are [Hugo instruction](http://gohugo.io/templates/404/) and [Github instructions](https://help.github.com/articles/custom-404-pages/) explaining how to create a custom 404 (page not found) page.

### Customization
Rather than change existing CSS files I customize the look of the site with a separate (`./static/css/custom.css`) file. Don't forget to add a `link` tag to the new CSS file in the `./layouts/chrome/head_includes.html` template.

I did have to make one change to [poole.css from the example repo](https://github.com/spencerlyon2/hugo_gh_blog/blob/master/static/css/poole.css): For some reason lists were styled to render like paragraphs -- fixed by deleting from `poole.css`:

    /* Lists */
    ul, ol, dl {
      margin-top: 0;
      padding-left: 0;
      margin-bottom: 1rem;
      list-style-type: none;
    }

### Importing posts from WordPress
I used [Exitwp](https://github.com/thomasf/exitwp) to import the exported WordPress posts to Hugo -- it worked like a charm and saved me hours of drudgery.

1. Export all WordPress data to an XML file -- see the [WordPress support](http://en.support.wordpress.com/export/) pages for instructions.

2. Convert to Jekyll format following the  [Exitwp](https://github.com/thomasf/exitwp) instructions.

3. Copy the posts from (in `./build/jekyll/<wordpress-site>/_posts/`) to Hugo's `./content/posts/` directory.

You will probably need to tweak the imported Markdown files:

- I had to drop the `layout` parameter from the front matter header because it was set to `post` (my posts layout is in `posts`). This can be automated using [command-line Perl](http://www.perl.com/pub/2004/08/09/commandline.html) e.g. this deletes lines containing _author_, _comments_, _layout_ and _wordpress_id_ front matter parameters from all Markdown files and renames the original files with a `.BAK` extension:

        perl -i.BAK -ne "print unless /^(author|comments|layout|wordpress_id): /" *.md

- Image URLs were pointing back to the WordPress site, to make them
  local I copied the images to `./satic/images/` and adjusted the
  links in the Markdown source to `/images/<image-file-name>`.

## Things I've learnt
- If you are deploying to a [non-root base URL](http://ifyoucodeittheywill.com/2009/03/absolute-relative-and-root-relative-urls/) (e.g. `http://srackham.github.io/stuarts-notes/`) you will need to add `canonifyurls: true` to your `config.yaml` file. If you don't, the root-relative URLs (for example, in the CSS file links) will not work. For the same reason, you will also have this problem If you run the `hugo server` command and view the site locally. I no longer have this issue because my base URL is a root URL (`http://blog.srackham.com/`).

- I commit the changes outside the `public` directory separately prior to running `deploy.sh`, this keeps content and configuration changes separate from the website files and makes tracking content changes easier.

- Hugo strips HTML comments from templates when building -- nice!

- The `hugo server` command builds the site with base URL set to the local server root, this means you must make sure you rebuild with the `hugo` command before deployment.

- Using Hugo's server command `--watch` option in conjunction with the browser make writing and proofing much more dynamic.

- Static assets (CSS, images, icons) go in `./static/`, Hugo copies them to `./public/` when it builds the site (`./public/` is a transient website staging directory).

- Using Hugo, Git and Github Pages makes for a much easier workflow than I had previously.

As a side note, I like the [Blog like there's nobody
reading](https://lauris.github.io/2014/08/14/blog-like-theres-nobody-reading/)
philosopy, but it has it's limits. There's a lot more work goes into a readable and useful blog post than just throwing on-the-fly notes over the wall. On the plus side, putting my notes into a blog ensures that I understand them more then six months later.


## Todo list
1. Enable blog comments [using Disqus](http://gohugo.io/extras/comments/) -- maybe.

2. Enable syntax [highlighting](http://gohugo.io/extras/highlighting/).
