//
//  RCTumengShareApi.h
//  RCTumengShareApi


#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import <UIKit/UIKit.h>


@interface RCTumengShareApi : NSObject <RCTBridgeModule>
+(void) setRootController:(UIViewController*)rootController;
@end
