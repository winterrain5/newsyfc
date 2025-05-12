# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'syfc' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for syfc
#	pod 'FirebaseCore'
#	pod 'FirebaseAnalytics'
pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'FirebaseAnalytics'
pod 'ActivityIndicatorView'
	pod 'PromiseKit'
pod 'FSCalendar'
pod 'HandyJSON',git: 'https://github.com/alibaba/handyjson'
pod 'AlertToast'
end

post_install do |installer|
installer.pods_project.targets.each do |target|
 target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
   config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
 end
 if target.name == 'HandyJSON'
   target.build_configurations.each do |config|
   config.build_settings['SWIFT_COMPILATION_MODE'] = 'incremental'
   end
 end
 if target.name == 'BoringSSL-GRPC'
   target.source_build_phase.files.each do |file|
     if file.settings && file.settings['COMPILER_FLAGS']
       flags = file.settings['COMPILER_FLAGS'].split
       flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
       file.settings['COMPILER_FLAGS'] = flags.join(' ')
     end
   end
 end
end
end
