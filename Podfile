# Uncomment the next line to define a global platform for your project
  platform :ios, '9.0'
 
target 'DriverApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # use_frameworks!


  # Pods for DriverApp

  pod 'GoogleMaps'
  pod 'SDWebImage/GIF'
  pod 'GoogleSignIn'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Messaging'
  pod 'SinchRTC'
  pod 'CardIO'

  target 'DriverAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DriverAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['CLANG_WARN_UNGUARDED_AVAILABILITY'] = 'YES'
    puts "CLANG_WARN_UNGUARDED_AVAILABILITY was set to YES for all pods"
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
