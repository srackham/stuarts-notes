---
draft: false
date: 2015-02-10T10:49:00+13:00
title: Building Apps with Riot, ES6 and Webpack
slug: riot-es6-webpack-apps
categories:
- 6to5
- ES6
- Flux
- Riot
- Riotjs
- Webpack

---

I arrived at [Riot](https://muut.com/riotjs/)  after reading the Muut [Frameworkless JavaScript](https://muut.com/blog/technology/frameworkless-javascript.html) blog post -- read this first!  The Muut programmers have put their money where their mouths are and built Riot, a minimalist [Reactjs-like library](https://muut.com/blog/technology/riot-2.0/) called [Riot](https://muut.com/riotjs/) for building reactive UI components.

Reading the Riot documentation the thing that struck me was how easy Riot is to understand -- there are very few new terms and concepts to learn compared to React (which, to be fair, is also straight-forward compared to e.g. Polymer and Angular).

To help me learn Riot I ported my React [Flux Backbone Todos Example](https://github.com/srackham/flux-backbone-todo) to a [Riot Todo app](https://github.com/srackham/riot-todo). This post is a compilation of notes I made documenting the experience.

<!--more-->

The [tl;dr](http://en.wikipedia.org/wiki/Wikipedia:Too_long;_didn%27t_read) answers are:

1. Riot really does live up to its minimalist motto. The (unminified) Riot version of the Todo weighs in at a tiny 32KB compared to 964KB for the React version (600KB after subtracting Backbone and JQuery which are not used in the Riot version). However you look at it that's a huge difference.

2. Riot has that rare Goldilocks "just right" feel about it and is a joy to use.

3. Riot is a relatively new project, I was unable to find statistics on how it scales performance-wise in larger projects. How it fares alongside the Rect juggernaut is an open question -- I hope it does well.

If you're not familiar with Riot take a look at the [Riot website](https://muut.com/riotjs/) -- the documentation is first class. So rather than discussing how Riot works I'll just list things I've learnt that may not be obvious reading the documentation.


## Using ES6 with Riot
The [example app](https://github.com/srackham/riot-todo) is written in ES6, I use the [6to5](http://6to5.org/) transpiler to convert it to ES5 and [Webpack](http://webpack.github.io/) to bundle the compiled code along with required libraries. This approach necessitates combining JavaScript modules -- working in ES6 is particularly nice as you get to take advantage of the new ES6 import and export statements (see [this example](https://github.com/srackham/riot-todo/blob/master/src/index.js)).

Webpack [is configured](https://github.com/srackham/riot-todo/blob/master/webpack.config.js) to use the `6to5-loader` which automatically converts ES6 source to CommonJS formatted ES5 modules that are then bundled into the single `bundle.js` distributable file.


## Why I don't use Riot .tag files
Riot tag files are HTML templates containing HTML markup along with JavaScript UI logic.
If you've looked at the [Todo app](https://github.com/srackham/riot-todo) app you are probably wondering where the tag files are -- the answer is that I no longer use them, preferring JavaScript instead. By eliminating `.tag` files I've simplified my coding, tooling and workflow. For me, tag file complexity and limitations outweigh any perceived benefits.

This is not a criticism of Riot, the neat thing about tag files is that they're entirely optional and I'm documenting why I don't use them.

When you examine the compiled JavaScript you see that Riot tag files are a thin layer of syntactic sugar.

- They add an additional conceptual layer -- new(ish) syntax and semantics have to be learned.

- They add an additional compilation step.

- The tag file compiler dictates the languages and templates you can use (CoffeeScript, ES6, Jade) contradicting the "Use your favorite tools" mantra.

- The tag constructor-body logic is out of context:

    * It is not amenable to editor/IDE linting and other tooling.
    * Referencing `this` out of context means the code is not legal JavaScript and generates errors in editors/IDEs.

- There is currently no support for module formats (CommonJS, AMD) -- tag files compile to plain JavaScript .

- Tag files require tag loaders to be used directly in build tools such as Webpack and Browserify.

- The "ES6-like" constructor methods are nice but they are not legal JavaScript and are likely to always be a source of ongoing confusion (syntax and semantics). You can use _ES6 arrow functions_ to achieve the same semantics (lexically bound `this`) with almost the same brevity, for example:

```
this.add = (e) => {
  var input = e.target[0]
  this.items.push(input.value)
  input.value = ''
};
```

Here's [an example of an ES6 JavaScript tags file](https://github.com/srackham/riot-todo/blob/0.1.1/src/tags.js) using ES6 template strings and arrow functions.

ES6 Template Strings aid the readability of tag HTML templates. Similarly, if you are using CoffeeScript you can use CoffeeScript Block Strings. [JSX](http://facebook.github.io/jsx/) is another possibility -- React's JSX transformer could be modified to emit a string literal and you could then take advantage of existing JSX tooling support.


## The fundamental difference between Riot and React
The most significant difference lies in how the UI markup templates are declared:

- In React the UI template markup is baked in your JavaScript source (using the JSX language extension).
- Riot inverts the React model by putting the markup and logic in an HTML (tag) file.

The upshot of this inversion is that the React template DSL language is JavaScript whereas Riot relies on a custom template DSL (implemented with custom tags). Here are two simplified examples that generate a list from an array of todo items: the first is React JavaScript the second is the equivalent Riot tag markup:

```
<ul>
  todos.map(todo =>
    <li><TodoItemComponent todo={todo} /></li>)
</ul>
```

```
<ul>
  <li each="{todo in todos}">
    <todo-item todo="{todo}">
  </li>
</ul>
```

The first example uses JavaScript's `map` function to generate a list of `<li>` elements; the second uses Riot's custom `each` template attribute.

Steve Luscher explains why he thinks JavaScript is better than custom template DSLs [towards the end of this video](https://www.youtube.com/watch?v=rI0GQc__0SM#t=1325) -- not only do you have to learn a custom DSL you are also constrained by the features the DSL offers. For small common use-case examples like ones above there is little to choose between the two approaches, but when it comes to larger highly dynamic UI compositions the power and flexibility of React's JavaScript approach is clearly superior.


## Tips

### Avoid self-closing XHTML style tags
Do not close tags with `/>` as it does not always immediately close the tag.  When dealing with HTML5 elements `<foo />` means `<foo>` (whereas in XHTML `<foo />` means `<foo></foo>`) i.e. HTML5 ignores the `/` character. See this [Stackoverflow post](http://stackoverflow.com/a/9845124/1136455) on the subject. See also:

  * [Closing HTML5 tags with /> can produce unexpected results](https://muut.com/riotjs/forum/#!/using:closing-html5-tags-with-).

  * [Misplaced form end-tags](https://muut.com/riotjs/forum/#!/using:misplaced-form-end-tag).

### Bind tag event handlers to this
Bind tag event handlers to `this` to ensure they are always fired with the tag context (alternatively use the `var self = this` idiom). For example:

    this.clear = function(e) {
      dispatcher.trigger(dispatcher.CLEAR_TODOS);
    }.bind(this);

With ES6 you can achieve the same thing with lexically bound ES6 _arrow functions_:

    this.clear = (e) => {
      dispatcher.trigger(dispatcher.CLEAR_TODOS);
    };

### Referencing Loop items
Use the `each="{item in items}"` construct to pass the current looped item to a child custom tag. In the following example the code in the custom `todo-item` tag can refer to the current todo item with `opts.todo`:

    <ul>
     <li each="{todo in opts.store.todos}">
       <todo-item store="{parent.opts.store}" todo="{todo}">
     </li>
    </ul>


### Namespace event names
Use the colon namespacing convention to group application event names e.g. `admin:edit`, `admin:delete`, `admin:new`.

### You can use custom tag names in CSS files
Custom tags are rendered into the DOM and so they can be used for CSS selection and DOM interrogation, here's [an example](https://github.com/srackham/riot-todo/blob/master/dist/index.css).


## Debugging
When bundling with Webpack you need to use the [devtool source-map configuration option](https://github.com/srackham/riot-todo/blob/master/webpack.config.js) to produce a [source map](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/) file for you bundled app. This allows you to debug from the ES6 source code files.

To browse and debug the source code open your browser's _Sources window_ and navigate to the folder `webpack:///.`:

- In Firefox: open the Debugger (Ctrl+Shift+S).
- In Google Chrome: open the Console (Ctrl+Shift+J) then click on the _Sources_ tab to view the Sources panel.

I'm not big on debuggers and break points -- most of the time I just put strategically placed temporary `console.log()` statements in the code.


## The Big Picture
Riot (like React) is a UI library, not a framework. This is good (I prefer a small set of focused libraries to an all encompassing framework) but non-trivial applications need a coherent high-level structure (an architecture) to ease scalability, evolution and maintainability. [Flux](https://www.npmjs.com/package/flux) is increasing the architecture of choice for React-like apps. I like Flux because it's easy to understand and because it makes intuitive sense (not out of any theoretical conviction). The [Riot Todo app](https://github.com/srackham/riot-todo) uses the [RiotControl](https://github.com/jimsparkman/RiotControl) flux-style dispatcher (slightly modified) to implement the Flux architecture.
