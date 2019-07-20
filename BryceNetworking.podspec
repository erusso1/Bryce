#
# Be sure to run `pod lib lint Bryce.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BryceNetworking'
  s.version          = '1.4.0'
  s.summary          = 'Bryce is a simplified URLSession wrapper designed to make HTTP networking easy.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Bryce makes HTTP networking easy by providing a single-layer wrapper around URLSession, and provides a seamless interface to help construct your REST API client.'

  s.homepage         = 'https://github.com/erusso1/Bryce'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'erusso1' => 'ephraim.s.russo@gmail.com' }
  s.source           = { :git => 'https://github.com/erusso1/Bryce.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.watchos.deployment_target = '4.0'
  s.default_subspec = 'HTTP'
  s.swift_version = '5.0'

  s.subspec 'Core' do |core|
      
      core.ios.deployment_target = '10.0'
      core.watchos.deployment_target = '4.0'
      core.dependency 'KeychainAccess'
      core.dependency 'Alamofire'
      core.dependency 'AlamofireNetworkActivityLogger'
      core.dependency 'CodableAlamofire'
      core.source_files = 'Bryce/Classes/Core/*.{swift}'

  end
  
  s.subspec 'HTTP' do |http|
      
      http.ios.deployment_target = '10.0'
      http.watchos.deployment_target = '4.0'
      http.source_files = 'Bryce/Classes/HTTP/*.{swift}'
      http.dependency 'BryceNetworking/Core'
  end
  
  s.subspec 'Promises' do |promises|
      
      promises.ios.deployment_target = '10.0'
      promises.watchos.deployment_target = '4.0'
      promises.source_files = 'Bryce/Classes/Promises/*.{swift}'
      promises.dependency 'BryceNetworking/Core'
      promises.dependency 'PromiseKit/Alamofire'
  end
  
  # s.resource_bundles = {
  #   'Bryce' => ['Bryce/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
