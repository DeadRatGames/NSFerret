NSFerret
========

View Heirarchies can become quite complex in an app, once it's launched it becomes quite difficult to visualize the structure much less interrogate it.

NSFerret is a simple little class that pops-up a custom UI right on top of your App as it's running, and allows you to visually explore your heirarchy an get information on every single view in it.

![UI](http://www.deadratgames.com/kdwc/kdwc13/images/screen3.png)

Installing NSFerret
-------------------

In addition to the changes in the previous section, certain references are auto-linked:

* Grab the NSFerret.h and NSFerret.m files from this repo. 
* Add these two files to your project.
* That's it. NSFerret will automatically load itself on App launch and remain in the background.

Launching the Ferret UI in your App
-----------------------------------

**Hold your finger down on the screen for 7 seconds.** The Ferret UI will appear as a UIView added to the Root View of your Application and prevent further interaction with your App. Click "Shoo" to dismiss the Ferret UI.

You can also (immediately) launch the Ferret UI while you are at a breakpoint from the LLDB command line:

        (lldb) [NSFerret ferret]
        (lldb) continue

Navigating through your View Heirarchy
--------------------------------------

Every view has a superview, possibly some subviews and some peers. Just tap a Nav button to jump to another view.

Information Displayed
---------------------

Most basic UI Image properties:

* frame
* tag
* background color
* hidden
* alpha
* autoresizing (with a struts and bars representation)
* clipping of subviews
* UIImageView content mode

V2.0
====

Check back in the future, there may be some great improvements in fuctionality and content!

Enjoy!

 Christopher
