# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

def common_pods
	
  # API communication
  pod 'Alamofire', '~> 4.0'

end

target 'ExchangeRates' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ExchangeRates

  common_pods

  target 'ExchangeRatesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ExchangeRatesUITests' do
    # Pods for testing
  end

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
     target.build_configurations.each do |config|
	config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
     end
 end
end
