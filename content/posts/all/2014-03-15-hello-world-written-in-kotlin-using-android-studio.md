---
date: 2014-03-15 09:28:53+00:00
slug: hello-world-written-in-kotlin-using-android-studio
title: Hello World written in Kotlin using Android Studio
tags:
- Android
- Kotlin
---

[Kotlin](http://kotlin.jetbrains.org/) is Jetbrains successor to Java, it's evolving rapidly and what documentation there is for writing Android apps is pretty soon out of date to the point where even getting the canonical _Hello World_ up and running can be a frustrating experience.

<!--more-->

Here's how to get a Kotlin version _Hello World_ running on Android using Android Studio 0.5.1.

**IMPORTANT**: This is based on Android Studio 0.5.1 and Kotlin 0.7.115 (the latest versions when I wrote this post) -- it will probably be broken on other versions Studio/Kotlin.

Assuming you have already installed [Android Studio](https://developer.android.com/sdk/installing/studio.html), Follow these instructions:

  1. Install the nightly build of the Kotlin plugin in Android Studio (I had to add the Kotlin plugin repository manually because it was not in the list of JetBrains plugins, though it will probably reappear once Android Studio and Kotlin begin to stabilize): 
    1. Open the _Settings_ dialog and go to the _Plugins_ section. 
    2. Click _Browse Repositories…_
    3. Click _Manage Repositories…_
    4. Add the following [IDEA 13 EAP repository](http://confluence.jetbrains.com/display/Kotlin/Getting+Started) URL `http://teamcity.jetbrains.com/guestAuth/repository/download/bt345/.lastSuccessful/updatePlugins.xml`
    5. Search for the `kotlin-plugin` in the _Browse Repositories_ dialog; right-click on it and select _Download and install_. 
  2. Create a Java version of _Hello World_: From the Android Studio _File_ menu select _New Project…_ and set the _Application name_ to _HelloKotlin_ (or whatever takes you fancy) and accept all the remaining _New Project Wizard_ settings. 
  3. Rename the `app/src/main/java` directory to `app/src/main/kotlin` (right-click on the `app/src/main/kotlin` directory in the _Project Tool_ window and select the _Refactor->Rename…_ menu command). 
  4. Open the `app/src/main/kotlin/MainActivity.java` file in the editor and run the _Code->Kotlin->Convert Java File to Kotlin File_ menu command (no need to save a backup). 
  5. Run the _Tools->Kotlin->Configure Kotlin in Project_ menu command -- this will update the project's `build.gradle` file with Kotlin libraries, plugins and other Kotlin specific configuration requirements. 
  6. Now compile and build the project using the _Build->Make Project_ menu command. 

Because the Java to Kotlin converter does not differentiate between nullable and non-nulable Java method arguments you will get compilation errors and you need to manually modify the converted Kotlin source code. The error messages are not always self explanatory e.g.  this error `'onCreate' overrides nothing` in this line:
    
``` kotlin
override fun onCreate(savedInstanceState: Bundle) {
```

Is resolved by making the `savedInstanceState` argument nullable:
    
``` kotlin
override fun onCreate(savedInstanceState: Bundle?) {
```

This error `Only safe (?.) or non-null asserted (!!.) calls are allowed on a nullable receiver` in this line:
    
``` kotlin
val id = item.getItemId()
```

Is because the `item` method argument has been made nullable, it can be resolved using the [safe call](http://confluence.jetbrains.com/display/Kotlin/Null-safety) operator:
    
``` kotlin
val id = item?.getItemId()
```


Here's the resulting `app/src/main/kotlin/MainActivity.kt` file:
    
``` kotlin
package com.example.hellokotlin.app

import android.support.v7.app.ActionBarActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem


public class MainActivity() : ActionBarActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }


    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem?): Boolean {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        val id = item!!.getItemId()
        if (id == R.id.action_settings) {
            return true
        }
        return super.onOptionsItemSelected(item)
    }

}
```

Here's the Gradle build file (`app/build.gradle`) which required no manual editing -- it was created by the _New Project_ wizard and updated by the Kotlin plugin _Tools->Kotlin->Configure Kotlin in Project_ menu command:
    
``` groovy
apply plugin: 'android'
apply plugin: 'kotlin-android'

android {
    compileSdkVersion 19
    buildToolsVersion "19.0.1"

    defaultConfig {
        minSdkVersion 8
        targetSdkVersion 19
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            runProguard false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.txt'
        }
    }
    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }
}

dependencies {
    compile 'com.android.support:appcompat-v7:+'
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile "org.jetbrains.kotlin:kotlin-stdlib:$ext.kotlin_version"
}
buildscript {
    ext.kotlin_version = '0.7.115'
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$ext.kotlin_version"
    }
}
repositories {
    mavenCentral()
}
```