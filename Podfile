# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'App.Demo.Techmaster' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for App.Demo.Techmaster
  pod 'ActiveLabel'
  pod 'Alamofire'
  pod 'SwiftHEXColors'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'ObjectMapper', '~> 3.5'

end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
