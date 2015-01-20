//
//  FlickrHelper.swift
//  FlickrViewSwift
//
//  Created by KEEVIN MITCHELL on 10/19/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit
import Foundation
class FlickrHelper: NSObject {
    //Lets create a class function to access the flickr api
    
    
    
    
    
    //class function or type method
    /*
    Methods are functions that are associated with a particular type. Classes, structures, and enumerations can all define instance methods, which encapsulate specific tasks and functionality for working with an instance of a given type. Classes, structures, and enumerations can also define type methods, which are associated with the type itself. Type methods are similar to class methods in Objective-C.
    
    The fact that structures and enumerations can define methods in Swift is a major difference from C and Objective-C. In Objective-C, classes are the only types that can define methods. In Swift, you can choose whether to define a class, structure, or enumeration, and still have the flexibility to define methods on the type you create
    Instance Methods
    
    Instance methods are functions that belong to instances of a particular class, structure, or enumeration. They support the functionality of those instances, either by providing ways to access and modify instance properties, or by providing functionality related to the instance’s purpose. Instance methods have exactly the same syntax as functions, as described in Functions.
    
    You write an instance method within the opening and closing braces of the type it belongs to. An instance method has implicit access to all other instance methods and properties of that type. An instance method can be called only on a specific instance of the type it belongs to. It cannot be called in isolation without an existing instance.

*/
    
    class func URLForSearchString(searchString:String) ->String{
        let apiKey:String = "0b333e366cbf16c51ca4d6aa9f0ffa1c"
        let search:String = searchString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(search)&per_page=100&format=json&nojsoncallback=1"
        
    }
    class func URLForFlickrPhoto(photo:FlickrPhoto, size:String) ->String{
        var _size:String = size
        
        if _size .isEmpty{
           _size = "M"
            
        }
        return "http://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.photoID)_\(photo.secret)_\(_size).jpg"
        
    }
    
    
    
    
    
    //This is being called from gallery. its coming with the search string and waits for an answer
    
    func searchFlickrForString(searchStr:String, completion:(searchString:String!, flickerPhotos:NSMutableArray!, error:NSError!) ->()){
        //later we can just call completion and get that info
        //First we will need a search url for our photos. Because its a class function we can call this function even though we are in the class and pass in the search string
        
        let searchURL:String = FlickrHelper.URLForSearchString(searchStr) //calling the class method above to get the full url string
        
        //We cannot download all these pic on the main thread because it will freze theUI. so we call global queue and get it an identifier of.DISPATCH_QUEUE_PRIORITY_DEFAULT and a flag of 0
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        //Next dispatch asyncronously our que with the main thread
        dispatch_async(queue, {
            //Whatever in here is going to happen the same time(asyncronously) as the main thread
            
            var error:NSError? // this should be optional because we do not want an error. So we can check if its nil
            
         //  let searchResultString:String! = String.stringWithContentsOfURL(NSURL.URLWithString(searchURL), encoding: NSUTF8StringEncoding, error: &error)
            
            
            
            var e: NSError?
            let url: NSURL = NSURL(string:searchURL)!
            let searchResultString:String! = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &e)

            
            
            
            
            //Now we can check if the error is not equal to nil
            if error != nil{
               //We call our completion handler the first time
                //searchStr
                //No photos yet
                //the error we just got here
                
                completion(searchString: searchStr, flickerPhotos: nil, error: error)
                
            }else{
                //If there was no error
                //We will get a json response
                //Lets parse the json response here
                
                //First lets get data. unwrapped(!) because here there was no error so we must have data its not optional here. it was optional above because we didnt know if we wouild have an error
                
                let jsonData:NSData! = searchResultString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)//here we get a dictionary
                //Lets use the gictionary
                let resultsDictionary:NSDictionary! = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error)as NSDictionary
                
                //We could experience an error here so lets check for it
                 if error != nil{
                    //We call our completion handler the second call
                    completion(searchString: searchStr, flickerPhotos: nil, error: error)
                 } else {
                    //if there is no error we can continue
                    //First we want to check for the status that we COULD get from the flickr api
                    let status:String = resultsDictionary.objectForKey("stat") as String
                    
                   let resultsErrorDict:NSDictionary? = resultsDictionary.objectForKey("message") as? NSDictionary
                    
              // let resultsErrorDict:NSDictionary = resultsDictionary.objectForKey("message") as NSDictionary
                    
                    if status == "fail"{
                      //here we have to create an error ourself if stat says fail. Here error must be optional because we dont know if we will get one. Notice we create a dictionary for userInfo
                //       let error:NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultsDictionary.objectForKey("message")])
                        
                        let error:NSError? = NSError(domain: "FlickrSearch", code: 0, userInfo: resultsErrorDict)
                        
                        
                        //lets call our completion block for the third time and pass in our error
                        completion(searchString: searchStr, flickerPhotos: nil, error: error)
                    
                    } else {
                        //Here means that we have the json dict with all the keys and values downloaded. We are interested in the "photo" key
                        //so lets create a dictionary
                        
                        let photoArray:NSArray = resultsDictionary.objectForKey("photos")?.objectForKey("photo")! as NSArray
                        
                        //now lets create our first flickrPhoto
                        
                        let flickrPhotos:NSMutableArray! = NSMutableArray()
                        
                        //Now using a for loop
                        for aPhoto in photoArray{
                            //Lets create a dictionary tohold all key and values for a photo
                            let photoDictionary:NSDictionary = aPhoto as NSDictionary
                            
                      //      println(photoDictionary)
                            
                            
                            //now we create our flickrPhoto
                            var flickrPhoto:FlickrPhoto = FlickrPhoto()
                            flickrPhoto.farm = photoDictionary.objectForKey("farm") as Int
                            flickrPhoto.server = photoDictionary.objectForKey("server") as String
                            flickrPhoto.secret = photoDictionary.objectForKey("secret") as String
                            flickrPhoto.photoID = photoDictionary.objectForKey("id") as String
                            
                            
                            let searchURL:String = FlickrHelper.URLForFlickrPhoto(flickrPhoto, size: "m")
                            
                          // To make the app faster we only put the urls to the phoyos in the mutblearray
                            
                            /*
                            //Now Lets download the image. First create a nsdata object for the imageData
                            let imageData:NSData = NSData(contentsOfURL:NSURL.URLWithString(searchURL), options: nil, error: &error)
                            
                            //now lets create an image from this data. which is going to be intialized with data
                            
                            let image:UIImage = UIImage(data:imageData)//uiimage init with data
                            
                            // because we downloaded the medium sized image let put it in a thumbnail
                            flickrPhoto.thumbNail = image
                            
                            //now we can use our array flickrPhotos from above
*/
                            flickrPhotos.addObject(searchURL)
                            
                        }
                        //Now lets call our completion handler for the 4 th time. Now we have a nice nusmuttable arry to pass in. This time we have no error here
                        completion(searchString: searchStr, flickerPhotos: flickrPhotos, error: nil)
                        
                        
                        
                    }
                    
                    
                }
                
                
                
                
            }
            
            
            
        })
        
        
        
    }
   
}
