#import "CafebazarIabPlugin.h"
#import <cafebazar_iab/cafebazar_iab-Swift.h>

@implementation CafebazarIabPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCafebazarIabPlugin registerWithRegistrar:registrar];
}
@end
