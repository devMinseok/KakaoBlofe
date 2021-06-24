platform :ios, '11.0'
inhibit_all_warnings!

target 'KakaoBlofe' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'
  
  # UI
  pod 'SnapKit'
  pod 'DropDown'
  
  # Rx
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxViewController'
  pod 'RxOptional'
  pod 'RxGesture'
  pod 'RxFlow'
  
  # Network
  pod 'Moya/RxSwift'
  pod 'Kingfisher'
  
  # Tool
  pod 'Then'
  pod 'ReusableKit/RxSwift'

  target 'KakaoBlofeTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'Stubber'
  end

  target 'KakaoBlofeUITests' do

  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
