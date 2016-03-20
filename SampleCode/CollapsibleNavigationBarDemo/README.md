##Creating a Collapsible Navigation Bar

In this sample, we'll review one way to add a Collapsible Navigation Bar to your iOS App.

####What is a Collapsible Navigation Bar?

If you're a user of Instagram or Facebook, you'll notice that some of the screens hide the navigation bar while the user is scrolling through a list.  Here is an example ...

![Collapsible Naivgation](/SampleCode/imgs/navbar_collapse.gif)

Notice the following:

* As the user scrolls down the list (i.e. UITableView), the Navigation Bar is hidden (collapses upward).  This provides more screen real estate for the content in the list.
* As the user scrolls back to the top of the list, the Navigation Bar becomes visible.
* When a user taps the status bar, the list scrolls to the top - and the NavigationBar is made visible.
* Finally, as the Navigation Bar is collapsing/hiding, the view in the middle of the Navigation Bar (i.e. Title View) fades out.

####Step 1: Create a UITableViewController and Embed it in a NavigationController

Before we start working on our collapsible Navigation Bar, we'll first need a UITableViewController with enough items in it for us to scroll through.  For this post, we won't review how to do that - as we want to focus on the Navigation Bar bits.  However, feel free to use this <a src="https://github.com/ccabanero/ios-ui-patterns/SampleCode/collapsenav_Xcode_starter.zip">sample project</a> to get started and follow along.

In the main storyboard, there is a single scene with a UITableViewController.  The TableView consists of static UITableView Cells each representing different Star Wars characters (shout out to [Filipe de Carvalho](https://www.behance.net/gallery/17998561/Star-Wars-Long-Shadow-Flat-Design-Icons) for the art work).  Click on the scene and choose __Editor (menu) -> Embed In -> Navigation Controller__.  Your storyboard should now resemble the following:

![screenshot](/SampleCode/imgs/collapsenav-navigationcontroller.png)

####Step 2: Customize the Navigation Bar

Now let's customize the Navigation Bar a bit.  We'll review how to change it's background color, add a logo to the center, and change the color of the status bar text.

######Change Color of Navigation Bar

To change the color of the NavigationBar, open the AppDelegate.swift class.  Add the following in the AppDelegate's application: didFinishLaunchingwithOptions method.  The Navigation Bar's appearance proxy is used to change the background color by setting the barTintColor property (see below).

````
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // For Setting the background color of the Navigation Bar
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor.blackColor()
        
        return true
    }
````

######Change Color of Status Bar Text

Now that the NavigationBar is black, the User will no longer be able to see the black text in the status bar.  Thus, lets make the text in the status bar white by updating your __Info.plist__ file in the following way:

* Add the __key__ View controller-based status bar appearance with a __value__ of No

* Add the __key__ Status bar style with a __value__ of UIStatusBarStyleLightContent

######Add Logo to Center of Navigation Bar

To add a logo to the NavigationBar, open the TableViewController.swift class.  Create a method that adds a logo to the center of the Navigation Bar by setting the titleView property of the navigation item (see below).

````
override func viewDidLoad() {
        super.viewDidLoad()
        addCenterImageToNavigationBar("starwars")
    }
    
    /**
     For adding an ImageView to the center of a navigation bar.
     - parameter imageName: The name of the image.
     - returns: void
     */
    func addCenterImageToNavigationBar(imageName: String) {
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        
        self.navigationItem.titleView = imageView
    }
````

Run your App. Your screen should now resemble the following:

![screenshot](/SampleCode/imgs/collapsenav-navbar.png)

####Step 3: Make your Navigation Bar Collapsible

In the TableViewController.swift class, add the following utility method to make the navigation bar collapsible and invoke this in the viewDidAppear method (see below).  Note, we will be adding more code to this method.

````
override func viewDidAppear(animated: Bool) {
        
        configureNavigationBarAsHideable()
    }
    
    /**
     For configuring the NavigationBar to show/hide when user swipes
     - returns: void
     */
    func configureNavigationBarAsHideable() {
        
        if let navigationController = self.navigationController {
            
            // respond to swipe and hide/show
            navigationController.hidesBarsOnSwipe = true
        }
    }
````

Run your App.  As you scroll down, the Navigation Bar now collapses.  As you scroll up, the Navigation Bar re-appears.  However, notice that the white status bar text now conflicts with the text in the TableViewCell.

![screenshot](/SampleCode/imgs/collapsenav-conflicttext.png)

Lets fix this.  In your __AppDelegate.swift__ class, update the  __application:didFinishLaunchingWithOptions__ so that we add a subview (the same color as the Navigation Bar) underneath the status bar text.  This way the status bar text doesn't conflict with any of the text in the UITableViewCells.  The application:didFinishLaunchingWithOptions should now resemble this:

````
override func viewDidAppear(animated: Bool) {
        
        configureNavigationBarAsHideable()
    }
    
    /**
     For configuring the NavigationBar to show/hide when user swipes
     - returns: void
     */
    func configureNavigationBarAsHideable() {
        
        if let navigationController = self.navigationController {
            
            // respond to swipe and hide/show
            navigationController.hidesBarsOnSwipe = true
        }
    }
````

Run your App.  Confirm that the status bar now has a solid background color in back of it when the Navigation Bar is collapsed.

![screenshot](/SampleCode/imgs/collapsenav-noconflict.png)

####Step 4: Show the Navigation Bar after Tapping the Status Bar

Run your App.  Scroll down to the bottom (the Navigation Bar will be hidden).  Tap on the status bar.  Notice that the content scrolls to the top.  Let's show the Navigation Bar when this happens.

In the __TableViewController.swift__ class, add a method that will add the Navigation Bar when scrolled to the top.  Invoke this method in an override of the UIScrollViewDelegate method named __scrollViewDidScrollToTop__ (see below).

````
/**
 For showing the NavigationBar when scrolled to the top
 - returns: void
 */
func showNavigationBarOnScrollToTop(scrollView: UIScrollView) {
    
    if scrollView.contentOffset.y < 0 {
        
        if let navigationController = self.navigationController {
            
            if navigationController.navigationBar.hidden {
                
                if let titleView = self.navigationItem.titleView {
                    
                    navigationController.navigationBarHidden = false
                    
                    titleView.alpha = 1
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate Method
override func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    showNavigationBarOnScrollToTop(scrollView)
}
````

####Step 5: Fade Out the Title View when Hiding

Wouldn't it be cool if the Navigation Bar logo (i.e. TitleView) started to fade out as it was transitioning out of view?  The UINavigationController actually gives us access to the UIPanGestureRecognizer that is used to trigger whether the NavigationBar is hidden or shown due to a swipe.   Let's add a fade out!

In the __TableViewController.swift__ class, we'll first update the implementation of the __configureNavigationBarAsHideable()__ method by getting a reference to the UIPanGestureRecognizer from the NavigationController.  Then we'll use the target-action pattern to execute a new method for fading out the Title View during a User's swipe gesture (see below).

````
/**
 For configuring the NavigationBar to show/hide when user swipes
 - returns: void
*/
func configureNavigationBarAsHideable() {
   
   if let navigationController = self.navigationController {
       
       // respond to swipe and hide/show
       navigationController.hidesBarsOnSwipe = true
       
       // get the pan gesture used to trigger hiding/showing the NavigationBar
       let panGestureRecognizer = navigationController.barHideOnSwipeGestureRecognizer
       
       // when the user pans, call action method to fade out title view
       panGestureRecognizer.addTarget(self, action:"fadeOutTitleView:")
   }
}

/**
 For fading out the title view 
 - parameter sender: The UIPanGestureRecognizer when user swipes (and hides/shows NavigationBar))
 - returns: void
*/
func fadeOutTitleView(sender: UIPanGestureRecognizer) {
   
   if let titleView = self.navigationItem.titleView {
   
       // fade out title view when swiping up
       let translation = sender.translationInView(self.view)
       
       if(translation.y < 0) {
           
           let alphaValue = 1 - abs(translation.y / titleView.frame.height)
           
           titleView.alpha = alphaValue
       }
       
       // clear transparency if the Navigation Bar is not hidden after swiping
       if let navigationController = self.navigationController {
           
           let navigationBar = navigationController.navigationBar
           
           if navigationBar.frame.origin.y > 0 {
               
               if let titleView = self.navigationItem.titleView {
                   
                   titleView.alpha = 1
               }
           }
       }
   }
}
````

####__Connect__

Twitter: [@clintcabanero](http://twitter.com/clintcabanero)

GitHub: [ccabanero](http://github.com/ccabanero)
