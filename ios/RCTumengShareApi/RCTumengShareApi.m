//
//  RCTumengShareApi.m
//  RCTumengShareApi


#import "RCTumengShareApi.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "RCTConvert.h"
#import "RCTImageLoader.h"
#import "RCTImageSource.h"
#import "RCTConvert.h"
#import "WXApi.h"

static RCTumengShareApi *_instance = nil;

@interface RCTumengShareApi ()<UMSocialUIDelegate>
@property (weak,nonatomic) UIViewController* rootViewController;
@property (strong,nonatomic) NSString* umengAppKey;
@end

@implementation RCTumengShareApi
@synthesize bridge = _bridge;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [super allocWithZone:zone];
            //            [_instance setupUMessage];
        }
    });
    return _instance;
}

+(void)setRootController:(UIViewController *)rootController
{
    [RCTumengShareApi sharedInstance].rootViewController = rootController;
}
RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(setAppKey:(NSString*)appKey)
{
    self.umengAppKey = appKey;
    [UMSocialData setAppKey:appKey];
}

RCT_EXPORT_METHOD(setWXAppId:(NSString*)appId appSecret:(NSString*)appSecret url:(NSString*)url)
{
    [UMSocialWechatHandler setWXAppId:appId appSecret:appSecret url:url];
}

RCT_EXPORT_METHOD(setQQWithAppId:(NSString*)appId appKey:(NSString*)appKey url:(NSString*)url supportWebView:(BOOL)supportWebView)
{
    [UMSocialQQHandler setQQWithAppId:appId appKey:appKey url:url];
    [UMSocialQQHandler setSupportWebView:supportWebView];
}

RCT_EXPORT_METHOD(openNewSinaSSOWithAppKey:(NSString*)appKey secret:(NSString*)secret RedirectURL:(NSString*)url)
{
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:appKey
                                              secret:secret
                                         RedirectURL:url];
}

RCT_EXPORT_METHOD(openNewSinaSSOWithRedirectURL:(NSString*)redirectUrl)
{
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:redirectUrl];
}

RCT_EXPORT_METHOD(hiddenNotInstallPlatforms)
{
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没安装微信");
        //ShareToWechatFavorite需要单独判断，不然总是会隐藏
        [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatFavorite]];
    }
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina]];
}

RCT_EXPORT_METHOD(setQQData:(NSDictionary*)dic)
{

    RCTImageSource* source = [RCTConvert RCTImageSource:[dic objectForKey:@"imageSource"]];
    __weak RCTumengShareApi *weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:source.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                if(image == nil)
                                                {
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialData defaultData].extConfig.qqData.url= [[dic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                    [UMSocialData defaultData].extConfig.qqData.title= [dic objectForKey:@"title"];
                                                    [UMSocialData defaultData].extConfig.qqData.shareText= [dic objectForKey:@"content"];
                                                    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                                                    if(error == nil)
                                                    {
                                                        [UMSocialData defaultData].extConfig.qqData.shareImage = image;
                                                    }
                                                });

                                            }];

}

RCT_EXPORT_METHOD(setQzoneData:(NSDictionary*)dic)
{
    RCTImageSource* source = [RCTConvert RCTImageSource:[dic objectForKey:@"imageSource"]];
    __weak RCTumengShareApi *weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:source.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                if(image == nil)
                                                {
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialData defaultData].extConfig.qzoneData.url= [[dic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                    [UMSocialData defaultData].extConfig.qzoneData.title= [dic objectForKey:@"title"];
                                                    [UMSocialData defaultData].extConfig.qzoneData.shareText= [dic objectForKey:@"content"];
                                                    if(error == nil)
                                                    {
                                                        [UMSocialData defaultData].extConfig.qzoneData.shareImage = image;
                                                    }
                                                });

                                            }];
}

RCT_EXPORT_METHOD(setWechatSessionData:(NSDictionary*)dic)
{
    RCTImageSource* source = [RCTConvert RCTImageSource:[dic objectForKey:@"imageSource"]];
    __weak RCTumengShareApi *weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:source.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                if(image == nil)
                                                {
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialData defaultData].extConfig.wechatSessionData.url= [[dic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                    [UMSocialData defaultData].extConfig.wechatSessionData.title= [dic objectForKey:@"title"];
                                                    [UMSocialData defaultData].extConfig.wechatSessionData.shareText= [dic objectForKey:@"content"];
                                                    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
                                                    if(error == nil)
                                                    {
                                                        [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = image;
                                                    }
                                                });

                                            }];
}

RCT_EXPORT_METHOD(setWechatTimelineData:(NSDictionary*)dic)
{
    RCTImageSource* source = [RCTConvert RCTImageSource:[dic objectForKey:@"imageSource"]];
    __weak RCTumengShareApi *weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:source.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                if(image == nil)
                                                {
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialData defaultData].extConfig.wechatTimelineData.url= [[dic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                    [UMSocialData defaultData].extConfig.wechatTimelineData.title= [dic objectForKey:@"title"];
                                                    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText= [dic objectForKey:@"content"];
                                                    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
                                                    if(error == nil)
                                                    {
                                                        [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = image;
                                                    }
                                                });

                                            }];
}

RCT_EXPORT_METHOD(setWechatFavoriteData:(NSDictionary*)dic)
{
    RCTImageSource* source = [RCTConvert RCTImageSource:[dic objectForKey:@"imageSource"]];
    __weak RCTumengShareApi *weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:source.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                if(image == nil)
                                                {
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialData defaultData].extConfig.wechatFavoriteData.url= [[dic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                    [UMSocialData defaultData].extConfig.wechatFavoriteData.title= [dic objectForKey:@"title"];
                                                    [UMSocialData defaultData].extConfig.wechatFavoriteData.shareText= [dic objectForKey:@"content"];
                                                    [UMSocialData defaultData].extConfig.wechatFavoriteData.wxMessageType = UMSocialWXMessageTypeWeb;
                                                    if(error == nil)
                                                    {
                                                        [UMSocialData defaultData].extConfig.wechatFavoriteData.shareImage = image;
                                                    }
                                                });

                                            }];
}

RCT_EXPORT_METHOD(setSinaData:(NSDictionary*)dic)
{
    RCTImageSource* source = [RCTConvert RCTImageSource:[dic objectForKey:@"imageSource"]];
    __weak RCTumengShareApi *weakSelf = self;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:source.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                if(image == nil)
                                                {
                                                    return;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialData defaultData].extConfig.sinaData.shareText= [NSString stringWithFormat:@"%@ %@ %@",[dic objectForKey:@"title"],[dic objectForKey:@"content"],[dic objectForKey:@"url"]];
                                                    if(error == nil)
                                                    {
                                                        [UMSocialData defaultData].extConfig.sinaData.shareImage = image;
                                                    }
                                                });

                                            }];
}

RCT_EXPORT_METHOD(presentSnsIconSheetView:(NSString*)content imageSource:(RCTImageSource*)imageSource)
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageSource.imageURL.absoluteString]];
    [self.bridge.imageLoader loadImageWithURLRequest:urlRequest
                                            callback:^(NSError *error, UIImage *image) {
                                                UIImage* tempImage = image;
                                                if(error)
                                                {
                                                    tempImage = nil;
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [UMSocialSnsService presentSnsIconSheetView:self.rootViewController
                                                                                         appKey:self.umengAppKey
                                                                                      shareText:content
                                                                                     shareImage:tempImage
                                                                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToEmail,UMShareToSms]
                                                                                       delegate:nil];
                                                });

                                            }];

}
@end
