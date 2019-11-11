#import "CafebazarIabPlugin.h"

@implementation FLTCafebazarIabPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"cafebazar_iab"
                                  binaryMessenger:[registrar messenger]];
  FLTCafebazarIabPlugin* instance = [[FLTCafebazarIabPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  result(FlutterMethodNotImplemented);
}

@end