# Your Podfile should contain the following:
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/goinstant/pods-specs-public'

target '1. Integrate SOS' do
  pod 'SOS', '2.0.1'
end

target '2. Customize (Basic)' do
  pod 'SOS', '2.0.1'
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
