{
  'xcode_settings': {
    'SDKROOT': 'iphoneos',
  },
  'targets': [
    {
      'target_name': 'SDKDemos',
      'type': 'executable',
      'mac_bundle': 1,
      'mac_framework_dirs': [
        '$(SRCROOT)',
      ],
      'link_settings': {
        'mac_bundle_resources': [
          '<!@(find <(DEPTH)/SDKDemos/Resources -name "*.png")',
          '<!@(find <(DEPTH)/SDKDemos/Resources -name "*.jpg")',
          '<!@(find <(DEPTH)/SDKDemos/Resources -name "*.json")',
          '<!@(find <(DEPTH)/SDKDemos/Resources -name "*.xib")',
          '<(DEPTH)/GoogleMaps.framework/Resources/GoogleMaps.bundle',
        ],
        'libraries': [
          '<(DEPTH)/GoogleMaps.framework',
          '$(SDKROOT)/usr/lib/libobjc.dylib',
          '$(SDKROOT)/System/Library/Frameworks/CoreFoundation.framework',
          '$(SDKROOT)/System/Library/Frameworks/Foundation.framework',
          '$(SDKROOT)/System/Library/Frameworks/CoreGraphics.framework',
          '$(SDKROOT)/System/Library/Frameworks/UIKit.framework',
          '$(SDKROOT)/System/Library/Frameworks/AVFoundation.framework',
          '$(SDKROOT)/System/Library/Frameworks/CoreData.framework',
          '$(SDKROOT)/System/Library/Frameworks/CoreLocation.framework',
          '$(SDKROOT)/System/Library/Frameworks/CoreText.framework',
          '$(SDKROOT)/System/Library/Frameworks/GLKit.framework',
          '$(SDKROOT)/System/Library/Frameworks/ImageIO.framework',
          '$(SDKROOT)/System/Library/Frameworks/Security.framework',
          '$(SDKROOT)/System/Library/Frameworks/CoreBluetooth.framework',
          '$(SDKROOT)/System/Library/Frameworks/Accelerate.framework',
          '$(SDKROOT)/usr/lib/libc++.dylib',
          '$(SDKROOT)/usr/lib/libicucore.dylib',
          '$(SDKROOT)/usr/lib/libz.dylib',
          '$(SDKROOT)/System/Library/Frameworks/OpenGLES.framework',
          '$(SDKROOT)/System/Library/Frameworks/QuartzCore.framework',
          '$(SDKROOT)/System/Library/Frameworks/SystemConfiguration.framework',
        ],
      },
      'sources': [
        '<!@(find -E <(DEPTH) -name "*\.[hm]")',
      ],
      'xcode_settings': {
        'INFOPLIST_FILE': '<(DEPTH)/SDKDemos/SDKDemo-Info.plist',
        'TARGETED_DEVICE_FAMILY': '1,2',
        'IPHONEOS_DEPLOYMENT_TARGET': '7.0',
        'OTHER_LDFLAGS': '-ObjC',
        'USER_HEADER_SEARCH_PATHS': '$(SRCROOT)',
        'USE_HEADERMAP': 'NO',
        'CLANG_ENABLE_OBJC_ARC': 'YES',
      },
    },
  ],
}
