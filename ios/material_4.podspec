#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint material_4.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'material_4'
  s.version          = '0.0.1'
  s.summary          = 'Reads the geometry UIKit reserves for system elements.'
  s.description      = <<-DESC
Reads the regions UIKit reserves for system elements, such as iPhone Duo's
status cluster, for the material_4 package (liquid glass).
                       DESC
  s.homepage         = 'https://github.com/sdegenaar/liquid_glass_widgets'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sebastian Degenaar' => 'https://github.com/sdegenaar' }
  s.source           = { :path => '.' }
  s.source_files = 'material_4/Sources/material_4/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
