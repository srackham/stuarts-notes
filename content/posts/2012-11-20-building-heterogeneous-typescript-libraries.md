---
date: 2012-11-20 23:19:15+00:00
slug: building-heterogeneous-typescript-libraries
title: Building heterogeneous TypeScript libraries
categories:
- TypeScript
---

A technique for compiling one or more TypeScript source files to a single JavaScript library file that can be used in both the browser and by Node.js applications.

<!--more-->

## By way of example

Our library source consists of a single TypeScript module called _Lib_ spread across multiple source files (`lib1.ts` and `lib2.ts`) that exports a public API:

#### lib1.ts
    
    module Lib {
      export function f() {}
    }
    
    declare var exports: any;
    if (typeof exports != 'undefined') {
      exports.f = Lib.f;
    }


 

#### lib2.ts
    
    module Lib {
      export var v = {foo: 42};
    }
    
    declare var exports: any;
    if (typeof exports != 'undefined') {
      exports.v = Lib.v;
    }


 

The source file are compiled to a single JavaScript library `lib.js` using the TypeScript compiler:
    
    tsc --out lib.js lib1.ts lib2.ts


 

#### lib.js
    
    var Lib;
    (function (Lib) {
        function f() {
        }
        Lib.f = f;
    })(Lib || (Lib = {}));
    if(typeof exports != 'undefined') {
        exports.f = Lib.f;
    }
    var Lib;
    (function (Lib) {
        Lib.v = {
            foo: 42
        };
    })(Lib || (Lib = {}));
    if(typeof exports != 'undefined') {
        exports.v = Lib.v;
    }


 

`lib.js` file now can be included on an HTML page with:
    
    <script type="text/javascript" src="lib.js"></script>


 

Or in a Node.js application with:
    
    var Lib = require('./lib.js');


 

The APIs are accessed via the module name e.g. `Lib.f()`, `Lib.v`.

## Explanatory notes

The key to being able to import the code into Node.js with `require('./lib.js')` is conditionally assigning public API objects to properties of the global `exports` object e.g.
    
    declare var exports: any;
    if (typeof exports != 'undefined') {
      exports.f = Lib.f;
    }


 

  * `exports` is a global object defined by CommonJS compatible loaders such as Node's. 
  * This code must be placed at the end of the source file outside the module declaration. 
  * `exports` will not be assigned in the browser (or any non-CommonJS environment where _exports_ is not defined). 
  * To minimize browser global namespace pollution all source is enveloped in a single open module (_Lib_) -- this is not necessary in a module loader environment (e.g. Node.js). 
  * Multi-file "open" modules are not truly open -- you must export any module objects that need to be accessed across file boundaries. 
  * TypeScript can emit CommonJS modules directly by prefixing _module_ with the _export_ keyword and using the compiler `--module commonjs` option, but there are two problems with this approach: 
    1. The generated code can only be loaded with a module loader and cannot be used in a browser unless you also depoly a suitable browser module loader. 
    2. External modules must reside in a single source file (they are not open). 

## Scoping function wrapper

A variation of the above technique is to wrap the combined compiled file with a _scoping function_. This will ensure non-exported top level objects do not pollute the browser global namespace:
    
    (function() {
      :
    })();


 

The browser API is hoisted to the global namespace by assignment to the browser `window` object. The previous example becomes:
    
    declare var exports: any;
    if (typeof exports != 'undefined') {
      exports.f = Lib.f;
    }
    else if (typeof window !== 'undefined') {
      window['f'] = Lib.f;
    }


 

## References

  * [Authoring CommonJS modules](http://know.cujojs.com/tutorials/modules/authoring-cjs-modules). 
  * [TypeScript Handbook](http://www.typescriptlang.org/Handbook#modules). 
  * [Modules in TypeScript](http://typescript.codeplex.com/wikipage?title=Modules%20in%20TypeScript). 
  * [Writing for node and the browser](http://caolanmcmahon.com/posts/writing_for_node_and_the_browser/). 
  * [JS require() for browsers – better, faster, stronger](http://pixelsvsbytes.com/blog/2013/02/js-require-for-browsers-better-faster-stronger/). 
  * [Node.js modules documentation](http://nodejs.org/api/modules.html). 
  * [RequireJS](http://requirejs.org/). 
