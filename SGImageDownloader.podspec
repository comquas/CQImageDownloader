#
# Be sure to run `pod lib lint SGImageDownloader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SGImageDownloader'
  s.version          = '0.1.1'
  s.summary          = 'Simple Async Image Downloader'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Simple Async Image Downloader using NSURLSession. Small library and easy to use.
                       DESC

  s.homepage         = 'https://github.com/saturngod/SGImageDownloader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Saturngod' => 'saturngod@gmail.com' }
  s.source           = { :git => 'https://github.com/saturngod/SGImageDownloader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SGImageDownloader/Classes/*.swift'
  
  # s.resource_bundles = {
  #   'SGImageDownloader' => ['SGImageDownloader/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
