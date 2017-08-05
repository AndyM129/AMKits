Pod::Spec.new do |s|
  s.name             = 'AMKits'
  s.version          = '2.0.0'
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

  # AMKFoundationExtensions
  s.subspec 'AMKFoundationExtensions' do |foundationExtensions|
    foundationExtensions.frameworks = 'UIKit'
    foundationExtensions.source_files = 'AMKits/Classes/Extensions/Foundation/**/*.{h,m}'
    foundationExtensions.public_header_files = 'AMKits/Classes/Extension/Foundation/**/*.h'
  end

  # AMKUIKitExtensions
  s.subspec 'AMKUIKitExtensions' do |uiKitExtensions|
    uiKitExtensions.frameworks = 'UIKit'
    uiKitExtensions.source_files = 'AMKits/Classes/Extensions/UIKit/**/*.{h,m}'
    uiKitExtensions.public_header_files = 'AMKits/Classes/Extension/UIKit/**/*.h'
    uiKitExtensions.dependency 'AMKits/AMKFoundationExtensions'
  end

  # AMKEmojiHelper
  s.subspec 'AMKEmojiHelper' do |emojiHelper|
    emojiHelper.frameworks = 'UIKit'
    emojiHelper.libraries = "xml2"
    emojiHelper.source_files = 'AMKits/Classes/Libraries/AMKEmojiHelper/**/*.{h,m}'
    emojiHelper.public_header_files = 'AMKits/Classes/Libraries/AMKEmojiHelper/**/*.h'
    emojiHelper.resources = [
        "AMKits/Classes/Libraries/AMKEmojiHelper/AMKEmojiMapping.json",
    ]
    emojiHelper.dependency 'YYModel'
    emojiHelper.dependency 'TFHpple'

  end

end
