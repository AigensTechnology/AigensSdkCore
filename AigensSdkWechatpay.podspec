
Pod::Spec.new do |s|
  s.name = 'AigensSdkWechatpay'
  s.version = '0.0.1'
  s.summary = 'AigensSdkWechatpay'
  s.description      = <<-DESC
  Aigens SDK Wechat pay.
                         DESC
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/AigensTechnology/AigensSdkCore'
  s.author = { 'Peter Liu' => 'peter.liu@aigens.com' }
  s.source = { :git => 'https://github.com/AigensTechnology/AigensSdkCore.git', :tag => "#{s.version}wechatpay" }
  # s.source = { :git => 'https://github.com/AigensTechnology/AigensSdkCore.git', :tag => s.version.to_s }
  s.source_files = 'aigens-sdk-wechatpay/Classes/**/*.{swift,h,m,c,cc,mm,cpp}'
  s.ios.deployment_target  = '12.0'
  s.dependency 'Capacitor', '~> 3.5.1'
  s.swift_version = '5.0'
end

# tag format:  x.x.xwechatpay , e.g.:  0.0.1wechatpay
