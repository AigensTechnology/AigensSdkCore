#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aigens_sdk_core.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
    s.name             = 'aigens_sdk_core'
    s.version          = '0.1.0'
    s.summary          = 'Flutter plugin for Aigens SDK'
    s.description      = <<-DESC
  Flutter plugin for Aigens SDK - enables native iOS/Android apps to embed Aigens universal UX.
                         DESC
    s.homepage         = 'https://github.com/AigensTechnology/AigensSdkCore'
    s.license          = { :type => 'MIT', :file => '../../../LICENSE' }
    s.author           = { 'Peter Liu' => 'peter.liu@aigens.com' }
    s.source           = { :git => 'https://github.com/AigensTechnology/AigensSdkCore.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '12.0'
    s.swift_version = '5.0'
  
    s.source_files = 'Classes/**/*'
    
    s.dependency 'AigensSdkCore', '0.1.3'
    s.dependency 'AigensSdkApplepay', '0.0.8'
    
    s.dependency 'Flutter'
  end