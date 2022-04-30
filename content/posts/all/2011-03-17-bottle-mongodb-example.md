---
date: 2011-03-17 10:45:54+00:00
slug: bottle-mongodb-example
title: Bottle + MongoDB Example
tags:
- Bottle
- MongoDB
- python
---

A didactic Web application written in Python to illustrate how to use the [Bottle](http://bottlepy.org/) web-framework with the [MongoDB](http://www.mongodb.org) database.

It's a port I made of Mike Dirolf's [DjanMon](https://github.com/mdirolf/djanMon) application (how to use Django with MongoDB).

<!--more-->

[Bottle](http://bottlepy.org/) is a wonderful micro web-framework, it's beautifully written and documented and has that "just right" feel about it.  Bottle has support for multiple webservers and template engines -- I'm really enjoying it after working with Django.

[MongoDB](http://www.mongodb.org) is a schemaless document-oriented database designed for the Web.  For me, working with MongoDB has been a revelation. Database creation, administration and migration (long the bane of database developers) is trivial in comparison with traditional SQL databases.  Document storage management is baked into MongoDB and is used in many web applications (document storage has always been awkward and slow with relational databases).

You can find the source on [GitHub](https://github.com/srackham/bottle-mongodb-example).

Here's a screenshot:

![bottle-mongodb-example.png](/images/bottle-mongodb-example.png)

To run the application install the prerequisite packages then:
    
    git clone https://github.com/srackham/bottle-mongodb-example.git
    cd bottle-mongodb-example
    python bottle-mongodb-example.py


 

The application creates and displays a paged list of user created messages which are stored in a MongoDB database along with uploaded images (no file system management required it's all in the database) -- not bad for 93 lines of Python code and a 79 line HTML template.  The really neat thing is that you don't have to create the database, tables or schema -- it all happens automatically.



## Prerequisites

  * Python. 
  * MongoDB (see the [MongoDB](http://www.mongodb.org/) website for install instructions). 
  * PyMongo, the Python MongoDB driver:
    
        sudo easy_install pymongo


 
  * The Bottle web-framework:
    
        git clone https://github.com/defnull/bottle.git
        cd bottle
        python setup.py install


 

I'm running in this environment -- it works for me but your mileage may vary:

  * Xubuntu 10.04 
  * Bottle 0.9dev 
  * Python 2.6.5 
  * MongoDB 1.6.5 
  * PyMongo 1.9 
