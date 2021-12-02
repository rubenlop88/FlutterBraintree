#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_braintree'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for Braintree'
  s.description      = <<-DESC
  A Flutter plugin that wraps the native Braintree Drop-In UI SDKs.
                       DESC
  s.homepage         = 'https://github.com/Pikaju/FlutterBraintree'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Julien Scholz' => '' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  
  s.dependency 'Flutter'
  s.dependency 'BraintreeDropIn', '8.1.4'
  s.dependency 'Braintree/PayPal', '~> 4.37.0'
  s.dependency 'Braintree/Apple-Pay', '~> 4.37.0'
  s.dependency 'Braintree/PaymentFlow', '~> 4.37.0'
  s.dependency 'Braintree/DataCollector', '~> 4.37.0'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
