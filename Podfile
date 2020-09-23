# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Lavoro' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lavoro
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  pod 'KVKCalendar'
  pod 'SnapKit', '~> 5.0.0'
  pod 'MaterialComponents/BottomSheet'
  pod 'ApplozicSwift', :git=> 'https://github.com/manish-cs/ApplozicSwift.git'
  pod 'Alamofire', '~> 5.2'
  pod 'SwiftMessages'
  pod 'NVActivityIndicatorView'
  pod 'FBSDKLoginKit'
  pod 'SDWebImage', '~> 5.0'
  pod 'InputBarAccessoryView'
  pod 'GooglePlaces'
  pod 'QRCodeReader.swift', '~> 10.1.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
