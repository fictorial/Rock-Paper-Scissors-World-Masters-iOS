Google Analytics iPhone SDK.

Copyright 2009 Google, Inc. All rights reserved.

================================================================================
DESCRIPTION:

This SDK enables developers to add Google Analytics tracking to applications.
The tracker code is packaged as a single header file and static library. Drag
the GANTracker.h and libGoogleAnalytics.a files into your XCode project. Include
the CFNetwork framework in your project and link against libsqlite3.dylib.
See the Examples/BasicExample application for an illustration of how to use
page tracking and event tracking.

You will need an Analytics Account ID to properly initialize the GANTracker
object. We recommend you create a new website profile, by clicking "+ Add new
profile" from the main Overview page in Google Analytics (google.com/analytics).
Select "new domain" in the wizard, and choose a descriptive but fake URL for
your app. The Web Property/Account ID will take the form "UA-0000000-1".

You must indicate to your users, either in the app itself or in your terms of
service, that you reserve the right to anonymously track and report a user's
activity inside of your app.

AdSense Reporting:

To report AdSense information when used in conjunction with the Google
Ads SDK (see http://www.google.com/ads/mobileapps/), you need to first
link your AdSense and Analytics accounts (see Google Analytics help
for more information). You must call startTrackerWithAccountID *before*
calling loadGoogleAd in the Ads SDK. In addition, you need to add the
linker option -ObjC to your project (in XCode, go to Project ->
Edit Project Settings -> Build -> Linking, and add -ObjC to
Other Linker Flags).

Implementation Details:

Pageviews and events are stored in an SQLite database and dispatched to the
Google Analytics servers either periodically at a rate determined by the
developer or manually. A battery efficient strategy may be to "piggy-back"
a dispatch just after the application needs to perform network activity. 
Dispatching happens by pipelining HTTP requests down a single connection
(one request per pageview/event with a maximum of 30 per dispatch).

Caveats:

Google Analytics currently does not honor timestamp information and hence
the time (day) of dispatch of the pageview/event is used instead.

================================================================================
BUILD REQUIREMENTS:

Mac OS X v10.6+, XCode 3.2.3+ (iOS 4.0 SDK), iPhone OS 3.0+

================================================================================
RUNTIME REQUIREMENTS:

Mac OS X v10.6+, iPhone OS 3.0+

================================================================================
PACKAGING LIST:

Library
  GANTracker.h
  libGoogleAnalytics.a

Examples/BasicExample
  BasicExample.xcodeproj
  BasicExampleDelegate.h
  BasicExampleDelegate.m
  info.plist
  main.m
  MainWindow.xib

================================================================================
