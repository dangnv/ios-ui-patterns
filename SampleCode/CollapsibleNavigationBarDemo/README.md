##Creating a Collapsible Navigation Bar

In this sample, we'll review one way to add a Collapsible Navigation Bar to your iOS App.

####What is a Collapsible Navigation Bar?

If you're a user of Instagram or Facebook, you'll notice that some of the screens hide the navigation bar while the user is scrolling through a list.  Here is an example ...

![Collapsible Naivgation ](SampleCode/imgs/navbar_collapse.gif)

Notice the following:

* As the user scrolls down the list (i.e. UITableView), the Navigation Bar is hidden (collapses upward).  This provides more screen real estate for the content in the list.
* As the user scrolls back to the top of the list, the Navigation Bar becomes visible.
* When a user taps the status bar, the list scrolls to the top - and the NavigationBar is made visible.
* Finally, as the Navigation Bar is collapsing/hiding, the view in the middle of the Navigation Bar (i.e. Title View) fades out.

####Step 1: Create a UITableViewController and Embed it in a NavigationController

Before we start working on our collapsible Navigation Bar, we'll first need a UITableViewController with enough items in it for us to scroll through.  For this post, we won't review how to do that - as we want to focus on the Navigation Bar bits.  However, feel free to use this <a src="collapsenav_Xcode_starter" sample project to get started and follow along.

In the main storyboard, there is a single scene with a UITableViewController.  The TableView consists of static UITableView Cells each representing different Star Wars characters (shout out to Filipe de Carvalho for the art work).  Click on the scene and choose Editor (menu) -> Embed In -> Navigation Controller.  Your storyboard should now resemble the following:

screenshot

Step 2: Customize the Navigation Bar

Now let's customize the Navigation Bar a bit.  We'll review how to change it's background color, add a logo to the center, and change the color of the status bar text.

Change Color of Navigation Bar

To change the color of the NavigationBar, open the AppDelegate.swift class.  Add the following in the AppDelegate's application: didFinishLaunchingwithOptions method.  The Navigation Bar's appearance proxy is used to change the background color by setting the barTintColor property (see below).
https://gist.github.com/ccabanero/ae370f8b3c0b7e5fb0e0

Change Color of Status Bar Text

Now that the NavigationBar is black, the User will no longer be able to see the black text in the status bar.  Thus, lets make the text in the status bar white by updating your Info.plist file in the following way:

Add the key View controller-based status bar appearance with a value of No
Add the key Status bar style with a value of UIStatusBarStyleLightContent
Add Logo to Center of Navigation Bar

To add a logo to the NavigationBar, open the TableViewController.swift class.  Create a method that adds a logo to the center of the Navigation Bar by setting the titleView property of the navigation item (see below).
https://gist.github.com/ccabanero/4135930195ee48c64405

Run your App. Your screen should now resemble the following:

screenshot

Step 3: Make your Navigation Bar Collapsible

In the TableViewController.swift class, add the following utility method to make the navigation bar collapsible and invoke this in the viewDidAppear method (see below).  Note, we will be adding more code to this method.
https://gist.github.com/ccabanero/ba1a7e67c3983cd05256

Run your App.  As you scroll down, the Navigation Bar now collapses.  As you scroll up, the Navigation Bar re-appears.  However, notice that the white status bar text now conflicts with the text in the TableViewCell.

screenshot

Lets fix this.  In your AppDelegate.swift class, update the  application:didFinishLaunchingWithOptions so that we add a subview (the same color as the Navigation Bar) underneath the status bar text.  This way the status bar text doesn't conflict with any of the text in the UITableViewCells.  The application:didFinishLaunchingWithOptions should now resemble this:
https://gist.github.com/ccabanero/debb980fc19d3769d5fb

Run your App.  Confirm that the status bar now has a solid background color in back of it when the Navigation Bar is collapsed.

screenshot

Step 4: Show the Navigation Bar after Tapping the Status Bar

Run your App.  Scroll down to the bottom (the Navigation Bar will be hidden).  Tap on the status bar.  Notice that the content scrolls to the top.  Let's show the Navigation Bar when this happens.

In the TableViewController.swift class, add a method that will add the Navigation Bar when scrolled to the top.  Invoke this method in an override of the UIScrollViewDelegate method named scrollViewDidScrollToTop (see below).
https://gist.github.com/ccabanero/e73f55a5c1ec695b19f1

Step 5: Fade Out the Title View when Hiding

Wouldn't it be cool if the Navigation Bar logo (i.e. TitleView) started to fade out as it was transitioning out of view?  The UINavigationController actually gives us access to the UIPanGestureRecognizer that is used to trigger whether the NavigationBar is hidden or shown due to a swipe.   Let's add a fade out!

In the TableViewController.swift class, we'll first update the implementation of the configureNavigationBarAsHideable() method by getting a reference to the UIPanGestureRecognizer from the NavigationController.  Then we'll use the target-action pattern to execute a new method for fading out the Title View during a User's swipe gesture (see below).
https://gist.github.com/ccabanero/7c47bcb06573a17f9858