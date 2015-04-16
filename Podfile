# Your Podfile should contain the following:
source 'https://github.com/goinstant/pods-specs-public'
pod 'SOS', '0.11.0'

post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
    end
  end
end
