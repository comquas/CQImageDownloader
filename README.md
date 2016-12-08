## With CocoaPod

add

```
pod "CQImageDownloader"
```

## Manual

copy to `CQImageDownloader/Classes/CQImageDownloader.swift` to your project.

## Usage

### Download and Show

```swift
imageView.setCQImage("https://unsplash.com/photos/BO5BswJwguI/download?force=true")
```

```swift
imageView.setCQImage("https://unsplash.com/photos/BO5BswJwguI/download?force=true", placeholder: placeholderImage)
```

### Downloading with progress

```swift
imageView.setCQImage("https://unsplash.com/photos/BO5BswJwguI/download?force=true", placeholder: nil, progress: { (value: Float) in

    //supporting progress        
    print(value)
            
})

```

### Downloading with completion

```swift
imageView.setCQImage("https://unsplash.com/photos/BO5BswJwguI/download?force=true", placeholder: nil, progress: nil, completion: { (image:UIImage?, success:Bool) in

    if (success) {

    }

})
```

### Clear Cache

```swift
CQImageDownloader.clearAllTheCachedImages()
```

```swift
var downloader = CQImageDownloader()
downloader.deleteCacheImage("file URL")
```