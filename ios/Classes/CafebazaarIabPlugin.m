#import "CafebazaarIabPlugin.h"

@implementation FLTCafebazaarIabPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"cafebazaar_iab"
                                  binaryMessenger:[registrar messenger]];
  FLTCafebazaarIabPlugin* instance = [[FLTCafebazaarIabPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(FlutterMethodNotImplemented);
}

@end