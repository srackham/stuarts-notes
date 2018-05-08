---
date: 2011-07-17 04:03:18+00:00
slug: keeping-a-lid-on-mobile-data
title: Keeping a lid on Mobile data
tags:
- Android
---

How to configure your Android phone to automatically turn off the mobile data connection once your mobile data limit is reached.

<!--more-->




### Why bother?

In New Zealand we have what amounts to a telecommunications duopoly with mobile data charges that make your eyes water -- Vodafone charges me $1 NZD (0.84 USD) for every megabyte over my capped limit of 10MB per day (yes you read correctly 10 megabytes!) with no facility to limit overruns.



### Here's how

  1. Go to the Android Market and install the [3G Watchdog](https://market.android.com/details?id=net.rgruet.android.g3watchdog&hl=en) and [APNdroid](https://market.android.com/details?id=com.google.code.apndroid&hl=en) applications (both are great apps). 
  2. Configure _3G Watchdog_ with your data limit and configure it to use _APNdroid_ to turn off. 

![3g-watchdog-config.png](/images/3g-watchdog-config.png)

_3G Watchdog_ will now use _APNdroid_ to automatically turn off your mobile data connection when the preset level is reached, What's nice is that it will automatically reenable data atically at your next data period.

I also set the _3G Watchdog_ update frequency to the shortest possible (30s) because in 30s you can consume a lot of data (relative to my measly limit).

Lastly, a word of warning: Android phones consume mobile data [even when you're not using them](http://androidforums.com/lg-thrive/330483-why-google-using-my-data.html) -- this is why I manually turn off mobile data (using _APNdroid_) when I'm not using it (most of the time I'm on WiFi so I don't need to have mobile data enabled).
