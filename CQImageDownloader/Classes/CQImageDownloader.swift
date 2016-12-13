
//
//  CQImageDownloader.swift
//
//
//  Created by COMQUAS
//

import UIKit

extension UIImageView {
    
    /**
     set image url and it will download automatically
     
     - parameters:
        - url: Download Image URL
     - returns:
     `CQImageDownloader` for pause,cancel the download
     */
    public func setCQImage(_ url:String) -> CQImageDownloader {
        return self.setCQImage(url, placeholder: nil, progress: nil, completion: nil)
    }
    
    /**
     set image url and it will download automatically
     - parameters:
        - url: Download Image URL
        - placeholder: Before downloading image , showing the placeholder
     - returns:
     `CQImageDownloader` for pause,cancel the download
     */
    
    public func setCQImage(_ url:String, placeholder: UIImage?) -> CQImageDownloader {
       return self.setCQImage(url, placeholder: placeholder, progress: nil, completion: nil)
    }
    
    /**
     set image url and it will download automatically
     - parameters:
        - url: Download Image URL
        - progress: Callback function for progress. It will include Float value 0 to 1.
     - returns:
     `CQImageDownloader` for pause,cancel the download
     */
    
    public func setCQImage(_ url: String, progress:((_ value: Float) -> Void)?) -> CQImageDownloader {
        return self.setCQImage(url, placeholder: nil, progress: progress, completion: nil)
    }
    
    /**
     set image url and it will download automatically
     - parameters:
        - url: Download Image URL
        - placeholder: Before downloading image , showing the placeholder
        - progress: Callback function for progress. It will include Float value 0 to 1.
     - returns:
     `CQImageDownloader` for pause,cancel the download
     */
    
    public func setCQImage(_ url:String, placeholder: UIImage?, progress:((_ value: Float) -> Void)?) -> CQImageDownloader {
        return self.setCQImage(url, placeholder: placeholder, progress: progress, completion: nil)
    }
    
    /**
     set image url and it will download automatically
     - parameters:
        - url: Download Image URL
        - placeholder: Before downloading image , showing the placeholder
        - progress: Callback function for progress. It will include Float value 0 to 1.
     - returns:
     `CQImageDownloader` for pause,cancel the download
     */
    
    public func setCQImage(_ url: String, progress:((_ value: Float) -> Void)?,completion:((UIImage?,Bool) -> Void)?) -> CQImageDownloader {
        
        return self.setCQImage(url, placeholder: nil, progress: progress, completion: completion)
        
    }
    
    /**
     set image url and it will download automatically
     - parameters:
        - url: Download Image URL
        - placeholder: Before downloading image , showing the placeholder
        - progress: Callback function for progress. It will include Float value 0 to 1.
        - completion: Callback function , it will call when download finish. Value will include image:UIImage? and success:Bool
     - returns:
     `CQImageDownloader` for pause,cancel the download
     */
    
    public func setCQImage(_ url: String, placeholder: UIImage?, progress:((_ value: Float) -> Void)?,completion:((_ image: UIImage?,_ success: Bool) -> Void)?) -> CQImageDownloader {
        
        
        
        self.image = placeholder
        
        
        let downloader = CQImageDownloader()
        
        
        downloader.downloadImageWithProgress(url, progress: progress, completion: {
            (image,success) in
            
            
            DispatchQueue.main.async {
                self.image = image
                if let callback = completion {
                    callback(image,success)
                }
            }
            
            
        })
        
        return downloader
        
    }
    
}

public class CQImageDownloader: NSObject {
    
    
    var downloadTask: URLSessionDownloadTask?
    var downloadImageURL: String = ""
    var backgroundSession: URLSession!
    
    var completionCallback: ((UIImage?,Bool) -> Void)?
    var progressCallback: ((Float) -> Void)?
    
    /**
     Download Image with async
     - parameters:
         - url: Download Image URL
         - placeholder: Before downloading image , showing the placeholder
         - progress: Callback function for progress. It will include Float value 0 to 1.
         - completion: Callback function , it will call when download finish. Value will include image:UIImage? and success:Bool
     */
    public func downloadImageWithProgress(_ url: String,  progress:((Float) -> Void)?, completion:((UIImage?,Bool) -> Void)?) {
        
        
        if url == "" {
            if let callback = completion {
                callback(nil, false)
            }
            return
        }
        
        if let cacheImage = self.getImageWithURL(url) {
            
            if let callback = completion {
                callback(cacheImage, true)
            }
            
            return
        }
        
        self.progressCallback = progress
        self.completionCallback = completion
        
        
        if let imgURL = URL(string:url)
        {
            
            let identifier = "\(self.urlHash(url))\(self.randomString(length: 4))"
            
            let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: identifier)
            
            backgroundSession = URLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
            
            downloadImageURL = url
            downloadTask = backgroundSession.downloadTask(with: imgURL)
            downloadTask?.resume()
        }
    }
    
    /**
     Delete image in cached folder
     - parameters:
        - url: Downloaded Image URL
     */
    public func deleteCacheImage(_ url: String) {
        
        if let path = self.imagePathAtURL(url) {
            let fManager = FileManager.default
            if fManager.fileExists(atPath: path) {
                do {
                    try fManager.removeItem(atPath: path)
                }
                catch {
                    print ("delete image error")
                }
            }
        }
        
    }
    
    func saveImage(_ data: Data, name: String) {
        if let file = self.imagePathAtURL(name) {
            
            do {
                try data.write(to: URL(fileURLWithPath: file), options: .atomicWrite)
                
            }
            catch {
                print ("Saving Error")
            }
        }
    }
    
    func getImageWithURL(_ url: String) -> UIImage? {
        
        if let filepath = self.imagePathAtURL(url) {
            
            
            
            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: filepath)) {
                
                return UIImage(data: imageData)
            }
        }
        
        return nil
    }
    
    func urlHash(_ url: String) -> String {
        
        var hash = url.hashValue
        
        if hash < 0 {
            hash = hash * -1;
        }
        return "\(hash)"
    }
    func imagePathAtURL(_ url: String) -> String? {
        
        var cacheFolder: NSString = ""
        if let documentDir: NSString = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString? {
            cacheFolder = documentDir.appendingPathComponent("cached") as NSString
            var directory: ObjCBool = false
            
            if(!FileManager.default.fileExists(atPath: cacheFolder as String, isDirectory: &directory)) {
                if (!directory.boolValue) {
                    do {
                        try FileManager.default.createDirectory(atPath: cacheFolder as String, withIntermediateDirectories: true, attributes: nil)
                    }
                    catch {
                        print("folder create error")
                        return nil
                    }
                }
            }
        }
        
        let imageURL = self.urlHash(url)
        
        return cacheFolder.appendingPathComponent("\(imageURL).cqc")
        
    }
    
    
    /**
     Clear all image in cached folder of application support directory
     */
    
    public static func clearAllTheCachedImages() {
        
        let documentDir: NSString = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString
        let cachedFolder = documentDir.appendingPathComponent("cached")
        
        do {
            try FileManager.default.removeItem(atPath: cachedFolder)
        }
        catch {
            print ("cannot delete")
        }
        
    }
    
    
    /**
     Cancel the image download
     */
    
    public func cancelDownload() {
        
        self.downloadTask?.cancel()
    }
    
    /**
     Pause the image download
     */
    
    public func pauseDownload() {
        
        self.downloadTask?.suspend()
        
    }
    
    /**
     Resume the image download if suspend
     */
    
    public func resumeDownload() {
        self.downloadTask?.resume()
    }
    
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}


extension CQImageDownloader: URLSessionDelegate {
    
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        
        completionHandler(Foundation.URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        
    }
    
    
}

extension CQImageDownloader: URLSessionDownloadDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let err = error, let callback = completionCallback {
            print(err.localizedDescription)
            callback(nil,false)
        }
    }
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let file = self.imagePathAtURL(self.downloadImageURL) {
            
            let destURL = URL(fileURLWithPath: file)
            
            
            if let callback = self.completionCallback {
                do {
                    let d = try Data(contentsOf: location)
                    if d.count <= 0 {
                        callback(nil,false)
                        return
                    }
                    
                    
                    try d.write(to: destURL, options: .atomic)
                    
                    let img = self.getImageWithURL(self.downloadImageURL)
                    callback(img, true)
                    return
                }
                catch {
                    callback(nil, false)
                }
            }
        }
        
        
        
    }
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        if let callback = self.progressCallback {
            callback(progress)
        }
    }
}
