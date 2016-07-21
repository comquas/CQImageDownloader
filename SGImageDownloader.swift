
//
//  SGImageDownloader.swift
//
//
//  Created by Saturngod
//

import UIKit


extension UIImageView {
    
    func downloadImage(url: String) {
        
        let downloader = SGImageDownloader()

        downloader.downloadImage(url) { (image, success) in

            if (success) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.image = image
                })
            }
            
        }
    }
    
}

class SGImageDownloader : NSObject , NSURLSessionDelegate {
 
    func downloadImage(url: String, completion:((image: UIImage?,success: Bool) -> Void)?) {
    
        if url == "" {
            if let callback = completion {
                callback(image: nil, success: false)
            }
            return
        }
        
        if let cacheImage = self.getImageWithURL(url) {
            
            if let callback = completion {
                callback(image: cacheImage, success: true)
            }
            
            return
        }
        
        if let imageURL = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            imgURL = NSURL(string:imageURL)
        {
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: self, delegateQueue:NSOperationQueue.mainQueue())
            
            let task = session.dataTaskWithRequest(NSURLRequest(URL: imgURL), completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in

                
                if let er = error {
                    print(er.localizedDescription)
                    if let callback = completion {
                        callback(image: nil, success: false)
                    }
                    return
                }
                
                guard let imageData = data else {
                    print("No image data")
                    if let callback = completion {
                        callback(image: nil, success: false)
                    }
                    return
                }
                
                self.saveImage(imageData, name: url)
                
                if let callback = completion {
                    callback(image: UIImage(data: imageData), success: true)
                }
                
            })
            
            task.resume()

        }
 
 
 
 
    }
    func deleteCacheImage(url: String) {
 
        if let path = self.imagePathAtURL(url) {
        let fManager = NSFileManager.defaultManager()
        if fManager.fileExistsAtPath(path) {
            do {
                try fManager.removeItemAtPath(path)
            }
            catch {
                print ("delete image error")
            }
        }
        }
        
    }
    func saveImage(data: NSData, name: String) {
        if let file = self.imagePathAtURL(name) {
        
            do {
                try data.writeToFile(file, options: .AtomicWrite)
                
            }
            catch {
                print ("Saving Error")
            }
        }
    }
    
    func getImageWithURL(url: String) -> UIImage? {
        
        if let filepath = self.imagePathAtURL(url) {
            
            
            
            if let imageData = NSData(contentsOfFile: filepath) {
                
                return UIImage(data: imageData)
            }
        }
        
        return nil
    }
    
    func imagePathAtURL(url: String) -> String? {
        
        var cacheFolder: NSString = ""
        if let documentDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] {
            cacheFolder = documentDir.stringByAppendingPathComponent("cached")
            var directory: ObjCBool = false
            if(!NSFileManager.defaultManager().fileExistsAtPath(cacheFolder as String, isDirectory: &directory)) {
                if (!directory) {
                    do {
                    try NSFileManager.defaultManager().createDirectoryAtPath(cacheFolder as String, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch {
                        print("folder create error")
                        return nil
                    }
                }
            }
        }
        
        return cacheFolder.stringByAppendingPathComponent("\(url.md5()).jpg")

    }
    
    func clearAllTheCachedImages() {
        
        let documentDir: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let cachedFolder = documentDir.stringByAppendingPathComponent("cached")
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(cachedFolder)
        }
        catch {
            print ("cannot delete")
        }
        
    }
    
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void)
    {
        
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
        
    }
}