//
//  ViewController.swift
//  FlickrGallerySwift
//
//  Created by KEEVIN MITCHELL on 10/21/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var flickrImageView: UIImageView!
    
    var step:Int = 0 // for the animations
    @IBOutlet weak var shadowImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()//Bring up the keyboard on launch
        searchBar.delegate = self
        shadowImageView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowImageView.layer.shadowOpacity = 1.0
        shadowImageView.layer.shadowRadius = 2.0
        shadowImageView.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        
        let imageRect = CGRectMake(0, 0, 52, 50)
        // to make rendering quicker
        shadowImageView.layer.shadowPath = CGPathCreateWithRect(imageRect, nil)
        
        }
    
    //first lets add one of those search bar delegate methods
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let typeanimationDuration : NSTimeInterval = 0.4
        let delay :NSTimeInterval = 0
        let damping : CGFloat = 0.3
        let textAnimationVelocity : CGFloat = 0.5
        
        
        UIView.animateWithDuration(typeanimationDuration,
            delay: 0.0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: textAnimationVelocity,
            options: .CurveEaseInOut,
            animations: {
           //if step = 0 we wanmt to transform the imageview
                if self.step == 0{
               //transform the imageView
                    self.flickrImageView.transform = CGAffineTransformMakeScale(1.09, 1.09)
                    self.step = 1
                    
                } else{
                    //Transform it to the standard size
                     self.flickrImageView.transform = CGAffineTransformIdentity
                    
                    self.step = 0
                    
                    
                }
                
            
            
            },
            completion: nil)
        
        
        /*
        //Lets do an animation when text is entered invented in ios7
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: UIViewAnimationCurve.EaseOut, animations: { () -> Void in
            //we want the animation to happen everytime the user types
            
            
        }, completion: nil)
*/
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    /*
       override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
    }
*/
    
    
     //This is how we will get to the next viewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Because we bhave only one segue we dont need to check for the identifier
        //First we create a destination viewcontrioller
        
        let destinationViewController:GalleryViewController = segue.destinationViewController as GalleryViewController
        //2nd make sure you have a property in the next view controller
        //If there is text in the search bar
        
        if !searchBar.text.isEmpty{
            //here we set the property of the next viewcontroller
        destinationViewController.searchTerm = searchBar.text
        } else{
          //show an alert
            let alert:UIAlertController = UIAlertController(title: "Oooops", message: "Please enter a search term", preferredStyle: UIAlertControllerStyle.Alert)
            
            //lets give this aler 1 action
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            
           self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
        
        
        
    }
    

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

