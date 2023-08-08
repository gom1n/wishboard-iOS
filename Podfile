# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Wishboard' do
  use_frameworks!

  # Pods for Wishboard
	pod 'Alamofire'
	pod 'Kingfisher', '~> 7.6.1'
	pod 'SnapKit', '~> 5.6.0'
	
	pod 'Then'
	pod 'RxSwift'
  	pod 'RxCocoa'
	pod 'FSCalendar'
	pod 'MaterialComponents/BottomSheet'

	pod 'Firebase/Analytics'
	pod 'Firebase/Messaging'
	pod 'Firebase/Crashlytics'

	pod 'Moya'
	pod 'Moya/RxSwift'
	pod 'Moya/ReactiveSwift'
	pod 'Moya/Combine'

	pod 'lottie-ios'
  target 'WishboardTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'WishboardUITests' do
    # Pods for testing
  end

  target 'Share Extension' do
    # Pods for testing
	pod 'Then'
	pod 'SnapKit', '~> 5.6.0'
	pod 'MaterialComponents/BottomSheet'

	pod 'Moya'
        pod 'Moya/RxSwift'
        pod 'Moya/ReactiveSwift'
        pod 'Moya/Combine'
  end
end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
