

Pod::Spec.new do |s|
  s.name             = 'CQImageDownloader'
  s.version          = '0.5.4'
  s.summary          = 'Simple Async Image Downloader with progress'


  s.description      = <<-DESC
Simple Async Image Downloader using NSURLSession. Small library and easy to use. Supporting progress to use with progress view
                       DESC

  s.homepage         = 'https://github.com/comquas/CQImageDownloader'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Saturngod' => 'saturngod@gmail.com' }
  s.source           = { :git => 'https://github.com/comquas/CQImageDownloader.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CQImageDownloader/Classes/*.swift'
  
end
