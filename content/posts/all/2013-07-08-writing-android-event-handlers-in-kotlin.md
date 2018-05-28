---
date: 2013-07-08 09:07:03+00:00
slug: writing-android-event-handlers-in-kotlin
title: Writing Android event handlers in Kotlin
tags:
- Android
- Kotlin
---

[Kotlin](http://kotlin.jetbrains.org/) is Jetbrains successor to Java, this brief post illustrates how Kotlin's [SAM conversions](http://blog.jetbrains.com/kotlin/2013/06/kotlin-m5-3-idea-13-delegated-properties-and-more/) can simplify Android event handlers.

<!--more-->

**Updated**: 2013-08-20: For Kotlin M6 compatibility.

Kotlin can synthesize anonymous SAM class instances, this removes all the redundant verbosity of Java-style handlers. All you need to provide is the event handler in the form of a function literal. For example, this Android _onClick_ handler written in Java:
    
``` java
button1.setOnClickListener(new OnClickListener() {
    public void onClick(View v) {
        // Handler code here.
        Toast.makeText(this.MainActivity, "Button 1",
                Toast.LENGTH_LONG).show();
    }
});
```

Translates literally to this Kotlin code:
    
``` kotlin
button1.setOnClickListener(object: View.OnClickListener {
    override fun onClick(view: View): Unit {
        // Handler code here.
        Toast.makeText(this@MainActivity, "Button 1",
                Toast.LENGTH_LONG).show()
    }
})
```

Which is equivalent (courtesy of an implicit SAM conversion) to this beautifully simple idiomatic Kotlin code:
    
``` kotlin
button1.setOnClickListener {
    // Handler code here.
    Toast.makeText(this, "Button 1",
            Toast.LENGTH_LONG).show()
}
```

  * It's not necessary to declare the single _view_ function parameter, use the implicitly declared _it_ parameter. 
  * Argument parentheses can be omitted from `View.setOnClickListener` because it is passed a single function literal argument. 
  * In the Java-style examples _this_ inside the handler refers to the anonymous class instance; in the final idiomatic Kotlin example _this_ refers to the instance lexically enclosing the handler not the anonymous class object (which makes a lot more sense). 

See also [First Steps in SAM Conversions](http://blog.jetbrains.com/kotlin/2013/06/kotlin-m5-3-idea-13-delegated-properties-and-more/).
