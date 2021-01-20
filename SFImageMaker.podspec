#
Pod::Spec.new do |spec|

  spec.name         = "SFImageMaker"
  spec.version      = "1.0.3"
  spec.summary      = "Use CoreGraphics to control the direction of Rect Corner、Shadow 、Border"
  spec.homepage     = "https://github.com/SilverFruity/UICornerShadowView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Jiang" => "15328044115@163.com" }
  spec.source       = { :git => "https://github.com/SilverFruity/UICornerShadowView.git", :tag => "#{spec.version}" }
  spec.source_files  = "SFImageMaker/SFImageMaker/*.{h,m}","SFImageMaker/SFImageMaker/**/*.{h,m}"
  spec.public_header_files = "SFImageMaker/SFImageMaker/*.h"
  spec.ios.deployment_target = '8.0'
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end

