//
//  TableViewController.swift
//  CollapsibleNavigationBarDemo
//
//  Created by Clint Cabanero on 3/10/16.
//  Copyright © 2016 ClintCabanero. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addCenterImageToNavigationBar("starwars")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        configureNavigationBarAsHideable()
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
    
    /**
     For showing the NavigationBar when scrolled to the top
     - returns: void
     */
    func showNavigationBarOnScrollToTop(scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < 0) {
            
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
    
    // MARK: - UIScrollViewDelegate Methods
    override func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        showNavigationBarOnScrollToTop(scrollView)
    }
    
    // MARK: - UITableViewDelegate method
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // we do not want the uitableviewcell to highlight
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
}
