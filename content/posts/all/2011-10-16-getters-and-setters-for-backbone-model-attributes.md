---
date: 2011-10-16 07:15:09+00:00
slug: getters-and-setters-for-backbone-model-attributes
title: Getters and Setters for Backbone Model attributes
tags:
- Backbone.js
- coffeescript
---

The [Backbone.js](http://documentcloud.github.com/backbone/) Model class provides _get_ and _set_ methods to read and write Model attributes which is not a concise or natural as object property access. But it's not difficult to add a class method to generate Model getter/setter properties so that you can do this in [CoffeeScript](http://jashkenas.github.com/coffee-script/):
    
    person.name = 'Joe Bloggs'
    ph = person.phone


 

instead of this:
    
    person.set {name: 'Joe Bloggs'}
    ph = person.get 'name'

<!--more-->

The [CoffeeScript](http://jashkenas.github.com/coffee-script/) example below shows how it's done using the [ECMAScript 5](http://www.ecma-international.org/publications/standards/Ecma-262.htm) _Object.defineProperty_ function to define a Model _attribute_ method. I've added the _attribute_ class method to a _BaseModel_ class which is inherited by application classes. To create a Model attribute property call the _attribute_ method and pass it the name of the property.

``` js    
    Backbone = require 'backbone'
    
    class BaseModel extends Backbone.Model
        # Create model attribute getter/setter property.
        @attribute = (attr) ->
            Object.defineProperty @prototype, attr,
                get: -> @get attr
                set: (value) ->
                    attrs = {}
                    attrs[attr] = value
                    @set attrs
    
    class Contact extends BaseModel
        @attribute 'name'
        @attribute 'phone'
    
    p = new Contact()
    p.name = 'Joe Bloggs'
    p.phone = '1234'
    console.log p.attributes    # { name: 'Joe Bloggs', phone: '1234' }
```

Being able to create custom getter/setter properties is a testament to the little known power of JavaScript.

**References**

  * [ECMAScript 5 Objects and Properties](http://ejohn.org/blog/ecmascript-5-objects-and-properties/)
  * [ECMAScript 5 Strict Mode, JSON, and More](http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/)
  * [ECMAScript 5 compatibility table](http://kangax.github.com/es5-compat-table/)
