//
//  FlickrCollectionViewCell.swift
//  FlickrGallerySwift
//
//  Created by KEEVIN MITCHELL on 10/21/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit

class FlickrCollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    
    //We add a getter and setter to the nimage because we want special things to occur
    var image:UIImage!{
        get{
          return self.image
            
        }
        set{
            
           //if self.imageView != nil{
            
            //First sets the image to its new value
            self.imageView.image = newValue
            
         //   }
            //net we set the initial offset
            if imageOffset != nil{
                //Set the image offset from the function beloww
                setImageOffset(imageOffset)
                
            } else
            {// set the image ofset to (0,0)
               setImageOffset(CGPointMake(0, 0))
                
            }
            
        }
        
        
        
    }
    //We will also need an ofset to create the parallel effect
    var imageOffset:CGPoint!
    
    //now lets create some initializers
    override init(frame:CGRect){
        super.init(frame:frame)
        //Here you call all the setup functions
        setUpImageView()
        
        
        
          }
    //Next we need to overide init with coder

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //We need to do this to do our thing
        
        setUpImageView()
        
    }
    func setUpImageView(){
        //Here lets do some adjustments to the image View
        self.clipsToBounds = true //so that we still see the parallel effect even if the content is larger
        //Next create our imageView
     //   imageView = UIImageView(frame:CGRectMake(self.bounds.origin.x,  self.bounds.origin.y, 320, 200))
        
        //iphone 6 = 375
        
                imageView = UIImageView(frame:CGRectMake(self.bounds.origin.x,  self.bounds.origin.y, 375, 200))
        
        
        //next so that the imageview do not get distorted contentmode
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = false
        self.addSubview(imageView)
        
    }
    
    //here we set the image offset. we need an image offset to set
    func setImageOffset(imageOffset:CGPoint){
        //Lets store this offset in our class itself
        self.imageOffset = imageOffset
        
        
        
        if imageView != nil{
        //next we need to grow the imageview itself to acheive parralax effect
        //First lets save the current frame
        let frame:CGRect = imageView.bounds //the frame of the imageview itself
            
        
        //Next let create an offset frame
        let offset:CGRect = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        imageView.frame = offset
        }
        
        
    }
    
    
}
