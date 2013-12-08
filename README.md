NSFerret
========

View hierarchies can become complex in an app, once it's launched it becomes quite difficult to visualize the structure much less interrogate it.

NSFerret installs a **very** long press gesture recognizer that pops-up a custom UI right on top of your App as it's running, allowing you to visually explore your app and get key information on every single view in it.

![UI](http://www.deadratgames.com/kdwc/kdwc13/images/screen5.jpg)

Installing NSFerret
-------------------

* Download the **NSFerret.h** and **NSFerret.m** files from this repo. 
* Add these two files to your XCode project.
* That's it. NSFerret will automatically load itself on App launch and wait to be summoned.

Launching the Ferret UI in your App
-----------------------------------

**Hold your finger down on the screen for 4 seconds.** The Ferret UI will appear as a UIView added to the Root View of your Application and prevent further interaction with your App. Click "Shoo" to dismiss the Ferret UI.

You can also (immediately) launch the Ferret UI while you are at a breakpoint from the LLDB command line:

        (lldb) [NSFerret ferret]

Navigating through your View Hierarchy
--------------------------------------

Every view has a superview, possibly some subviews and some peers. Just tap a Nav button to jump to another view.
The PICK mode allows you to drag your finger across the UI to select a View.

Information Displayed
---------------------

Most of the fundamental UIView properties:

* Frame
* Tag
* Background color
* Hidden property
* Alpha
* Autoresizing (with a struts and bars representation)
* Clipping of subviews
* UIImageView content mode
* Detects views partially off screen of entirely off screen
* User Interaction Disabled
* UIControls that won't respond to touches are highlighted in ORANGE

* NEW V2.1.0: The View Controller who ‘owns’ the view is now indicated  

Check back in the future, there may be some great improvements in functionality and content!

Enjoy!

 Christopher

V2.1.0
