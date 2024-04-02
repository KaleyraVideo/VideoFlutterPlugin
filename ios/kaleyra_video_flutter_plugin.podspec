require 'yaml'

spec = YAML.load_file('../pubspec.yaml')

Pod::Spec.new do |s|
  s.name             = spec["name"]
  s.version          = spec["version"]
  s.summary          = spec["description"]
  s.description      = spec["description"]
  s.homepage         = spec["repository"]
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kaleyra' => 'support@kaleyra.com' }
  s.source           = { :path => '.' }

  s.source_files = "Classes/**/*.{h,m,mm,swift}", "native-bridge/iOS/Source/**/*.swift"

  s.dependency 'Flutter'
  s.dependency 'Bandyer', '~> 3.11.0'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
