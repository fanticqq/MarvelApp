platform :ios, '14.0'

target 'MarvelApp' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'SwiftGen', '~> 6.0'
  pod 'SwiftLint', '~> 0.47'
  pod 'Kingfisher', '~> 7.2'

  target 'MarvelAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MarvelAppUITests' do
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
