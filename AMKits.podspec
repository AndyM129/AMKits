Pod::Spec.new do |s|
  s.name             = 'AMKits'
  s.version          = '0.1.1'
  s.summary          = 'Summary of AMKits.'
  s.description      = <<-DESC
                        A description of AMKits.
                       DESC
  s.homepage         = 'https://github.com/AndyM129/AMKits'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andy Meng' => 'andy_m129@baidu.com' }
  s.source           = { :git => 'https://github.com/AndyM129/AMKits.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.jianshu.com/u/28d89b68984b'
  s.ios.deployment_target = '8.0'
  s.source_files = 'AMKits/Classes/**/*.{h,m}'
  s.resources = [
    "AMKits/Classes/**/*.{plist,jpg,png}"
  ]
  s.public_header_files = 'AMKits/Classes/**/*.h'
  s.frameworks = 'UIKit'
end