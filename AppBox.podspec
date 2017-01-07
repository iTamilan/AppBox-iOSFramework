Pod::Spec.new do |s|
  s.name          = 'AppBox'
  s.version       = '0.1.0'
  s.summary       = 'iOS framework to get automatic update for AppBox-iOSAppsWirelessInstallation.'
  s.homepage      = 'https://github.com/iTamilan/AppBox-iOSFramework'
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { 'Tamilarasu P' => 'tamilarasu.tp@gmail.com' }

  s.ios.deployment_target = '8.0'
  s.source        = { :git => 'https://github.com/iTamilan/AppBox-iOSFramework.git', :tag => s.version.to_s }
  s.source_files  = 'AppBox/*.{h,m,c}'
end
