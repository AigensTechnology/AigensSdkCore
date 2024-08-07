#
# Be sure to run `pod lib lint AigensSdkCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AigensSdkCore'
  s.version          = '0.1.0'
  s.summary          = 'AigensSdkCore'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Aigens SDK for embedding web based UX.
                       DESC

  s.homepage         = 'https://github.com/AigensTechnology/AigensSdkCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Peter Liu' => 'peter.liu@aigens.com' }
  s.source           = { :git => 'https://github.com/AigensTechnology/AigensSdkCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '4.2'

  s.source_files = 'AigensSdkCore/Classes/**/*'
  
  s.dependency 'Capacitor', '~> 3.5.1'
  s.dependency 'CapacitorApp', '~> 1.1.1'
  s.dependency 'CapacitorBrowser', '~> 1.0.7'
  s.dependency 'CapacitorCamera', '~> 1.3.1'
  s.dependency 'CapacitorDevice', '~> 1.1.2'
  s.dependency 'CapacitorGeolocation', '~> 1.3.1'
  s.dependency 'CapacitorKeyboard', '~> 1.2.2'
  s.dependency 'CapacitorNetwork', '~> 1.0.7'
  # s.dependency 'CapacitorPushNotifications', '~> 1.0.9'
  s.dependency 'CapacitorShare', '~> 1.1.2'
  s.dependency 'CapacitorStorage', '~> 1.2.5'
  # s.dependency 'CapacitorToast', '~> 1.0.8'
  s.resources = "AigensSdkCore/Assets/*.{json}"
  
  # s.resource_bundles = {
  #   'AigensSdkCore' => ['AigensSdkCore/Assets/*.{json}']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
