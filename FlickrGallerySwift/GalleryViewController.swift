//
//  GalleryViewController.swift
//  FlickrGallerySwift
//
//  Created by KEEVIN MITCHELL on 10/21/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved
import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    //UISrollViewDelegate to acheive the parralax effect
    
    
    
    @IBOutlet weak var flickrCollectionView: UICollectionView!
    
    //We net an array for the data we get from flickr
    
    var flickrResultsArray:NSMutableArray! = NSMutableArray()
    
    var searchTerm:String! // this is the property that we access from the previous viewcontroller

    override func viewDidLoad() {
        super.viewDidLoad()
flickrCollectionView.delegate = self
        flickrCollectionView.dataSource = self
        
        loadPhotos()
        
        
    }
    
    func loadPhotos(){
        //First we create a flickr helper from our flickr helper class
        let flickrHelper:FlickrHelper = FlickrHelper()
        //Then we call its searFor string method
        flickrHelper.searchFlickrForString(searchTerm, completion: { (searchString:String!, flickerPhotos:NSMutableArray!, error:NSError!) -> () in
            
            if error == nil{
                
                //because the user interface runs on the main thread we have to dispatchasync. Because everything in helper happens off the main thread. Here we are dealing with the UI
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // In this clousure we do
                self.flickrResultsArray = flickerPhotos// This we got from the completion handler.
                    // Next let reload our collectionview
                    self.flickrCollectionView.reloadData()
                    
                    // To make a fast APP we are only storing the URL pointing to the photos and not the photos itself
                    
                    
                    
                    
                })

            
                
            }
            
            
            
        })
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//Collectionview datasource and delegate methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Here we want to return as much cells as we have results
        return flickrResultsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //Now its time to create our cells which are very similar to uitableViewCell.
        let cell:FlickrCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCell", forIndexPath:indexPath) as FlickrCollectionViewCell
        
        //We got the cell so let first set the image to be nil
        cell.image = nil //This is going to save a lot of memory
        
        //Next lets create a queue
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        // we dispatch async with our que and a block
        dispatch_async(queue, { () -> Void in
            // in this block first we create an error. Our error object will be optional
            var error:NSError?
            
            //Next lets create a search url which is just a string. This is a url that points to a photo stored in flickr. Check the flickerhelper class
            
            let searchURL:String = self.flickrResultsArray.objectAtIndex(indexPath.item) as String
            
            
            //Now we can download the data at this url
            let imageData:NSData = NSData(contentsOfURL: NSURL(string:searchURL)!, options: nil, error: &error)! //We dont use the options but we need the error
            
            //If there was no error we can assign the image we get at the URL to our cell
            //So first lets create an image
            
            let image:UIImage = UIImage(data: imageData)!
            
            
            
            //so now we need to get the main queue
            
            dispatch_async(dispatch_get_main_queue(), { 
                //Next lets add the image to athe cell but on the main thread not asychronously because our main UI liers on the main thread
                
                
                cell.image = image
                
                
                //Next we have to set the offset for thje paralax effect to work
                let yOffset:CGFloat = ((collectionView.contentOffset.y - cell.frame.origin.y) / 200) * 25
                
                cell.imageOffset = CGPointMake(0, yOffset)
                
                
                
                
            })
            
            
            
            
            
            
            
            
        })
        
       return cell
    }
    
    //WE need this scrollview delegate method for the cell parallax
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // here we got through all the views in the collect and set the offset
        for view in flickrCollectionView.visibleCells(){
            //next we say that each view is a collectionView cell
            var view:FlickrCollectionViewCell = view as FlickrCollectionViewCell
            
            // next we set the y offset. yje collection view content offset in the y direction minus view . fram.origin in the Y direction divided by the height of the imageview minus 25
            
            
            var yOffset:CGFloat = ((flickrCollectionView.contentOffset.y - view.frame.origin.y) / 200) * 25
            view.setImageOffset(CGPointMake(0, yOffset))
            
            
            
        }
        
        
    }
    
    
}
