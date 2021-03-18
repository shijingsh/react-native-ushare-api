//
//  ShareModule.h
//  UMComponent
//
//  Created by wyq.Cloudayc on 11/09/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "RCTumengShareApi.h"
#import <UMShare/UMShare.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>

#import <UMShare/WXApi.h>
@implementation RCTumengShareApi

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

- (UMSocialPlatformType)platformType:(NSInteger)platform
{
  switch (platform) {
    case 0: // QQ
      return UMSocialPlatformType_QQ;
    case 1: // Sina
      return UMSocialPlatformType_Sina;
    case 2: // wechat
      return UMSocialPlatformType_WechatSession;
    case 3:
      return UMSocialPlatformType_WechatTimeLine;
    case 4:
      return UMSocialPlatformType_Qzone;
    case 5:
      return UMSocialPlatformType_Email;
    case 6:
      return UMSocialPlatformType_Sms;
    case 7:
      return UMSocialPlatformType_Facebook;
    case 8:
      return UMSocialPlatformType_Twitter;
    case 9:
      return UMSocialPlatformType_WechatFavorite;
    case 10:
      return UMSocialPlatformType_GooglePlus;
    case 11:
      return UMSocialPlatformType_Renren;
    case 12:
      return UMSocialPlatformType_TencentWb;
    case 13:
      return UMSocialPlatformType_Douban;
    case 14:
      return UMSocialPlatformType_FaceBookMessenger;
    case 15:
      return UMSocialPlatformType_YixinSession;
    case 16:
      return UMSocialPlatformType_YixinTimeLine;
    case 17:
      return UMSocialPlatformType_Instagram;
    case 18:
      return UMSocialPlatformType_Pinterest;
    case 19:
      return UMSocialPlatformType_EverNote;
    case 20:
      return UMSocialPlatformType_Pocket;
    case 21:
      return UMSocialPlatformType_Linkedin;
    case 22:
      return UMSocialPlatformType_UnKnown; // foursquare on android
    case 23:
      return UMSocialPlatformType_YouDaoNote;
    case 24:
      return UMSocialPlatformType_Whatsapp;
    case 25:
      return UMSocialPlatformType_Line;
    case 26:
      return UMSocialPlatformType_Flickr;
    case 27:
      return UMSocialPlatformType_Tumblr;
    //case 28:
    //  return UMSocialPlatformType_AlipaySession;
    case 29:
      return UMSocialPlatformType_KakaoTalk;
    case 30:
      return UMSocialPlatformType_DropBox;
    case 31:
      return UMSocialPlatformType_VKontakte;
    case 32:
      return UMSocialPlatformType_DingDing;
    case 33:
      return UMSocialPlatformType_UnKnown; // more
    default:
      return UMSocialPlatformType_QQ;
  }
}

- (void)shareWithText:(NSString *)text descr:(NSString *)descr icon:(NSString *)icon link:(NSString *)link platform:(NSInteger)platform completion:(UMSocialRequestCompletionHandler)completion
{
  UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

  if (link.length > 0) {
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:text descr:descr thumImage:icon];
    shareObject.webpageUrl = link;

    messageObject.shareObject = shareObject;
  } else if (icon.length > 0) {
    id img = nil;
    if ([icon hasPrefix:@"http"]) {
      img = icon;
    } else {
      if ([icon hasPrefix:@"/"]) {
        img = [UIImage imageWithContentsOfFile:icon];
      } else {
        img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:icon ofType:nil]];
      }
    }
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    shareObject.thumbImage = img;
    shareObject.shareImage = img;
    shareObject.descr = descr;
    messageObject.shareObject = shareObject;

    messageObject.text = text;
  } else if (text.length > 0) {
    messageObject.text = text;
  } else {
    if (completion) {
      completion(nil, [NSError errorWithDomain:@"UShare" code:-3 userInfo:@{@"message": @"invalid parameter"}]);
      return;
    }
  }

  [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:completion];

}

RCT_EXPORT_METHOD(shareText:(NSString *)text  platform:(NSInteger)platform completion:(RCTResponseSenderBlock)completion)
{
  UMSocialPlatformType plf = [self platformType:platform];
  if (plf == UMSocialPlatformType_UnKnown) {
    if (completion) {
      completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
      return;
    }
  }

    [self shareWithText:text descr:nil icon:nil link:nil platform:plf completion:^(id result, NSError *error) {
    if (completion) {
      if (error) {
        NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
        if (!msg) {
          msg = error.userInfo[@"message"];
        }if (!msg) {
          msg = @"share failed";
        }
        NSInteger stcode =error.code;
        if(stcode == 2009){
         stcode = -1;
        }
        completion(@[msg]);
      } else {
        completion(@[@"share success"]);
      }
    }
  }];

}


RCT_EXPORT_METHOD(share:(NSString *)text descr:(NSString *)descr   link:(NSString *)link icon:(NSString *)icon platform:(NSInteger)platform completion:(RCTResponseSenderBlock)completion)
{
  UMSocialPlatformType plf = [self platformType:platform];
  if (plf == UMSocialPlatformType_UnKnown) {
    if (completion) {
      completion(@[ @"invalid platform"]);
      return;
    }
  }

    [self shareWithText:text descr:descr icon:icon link:link platform:plf completion:^(id result, NSError *error) {
    if (completion) {
      if (error) {
        NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
        if (!msg) {
          msg = error.userInfo[@"message"];
        }if (!msg) {
          msg = @"share failed";
        }
        NSInteger stcode =error.code;
        if(stcode == 2009){
         stcode = -1;
        }
        completion(@[ msg]);
      } else {
        completion(@[@"share success"]);
      }
    }
  }];

}


RCT_EXPORT_METHOD(openWeiapp:(NSString *)appId path:(NSString *)path userName:(NSString *)userName  platform:(NSInteger)miniProgramType completion:(RCTResponseSenderBlock)completion)
{

  WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
  launchMiniProgramReq.userName = userName;  //拉起的小程序的username
  launchMiniProgramReq.path = path;    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
  launchMiniProgramReq.miniProgramType = miniProgramType; //拉起小程序的类型
    return  [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success)  {
        if (completion) {
            completion(@[@"share success"]);
        }
    }];
}


RCT_EXPORT_METHOD(authLogin:(NSInteger)platform completion:(RCTResponseSenderBlock)completion)
{
  UMSocialPlatformType plf = [self platformType:platform];
  if (plf == UMSocialPlatformType_UnKnown) {
    if (completion) {
      completion(@[ @"invalid platform"]);
      return;
    }
  }

  [[UMSocialManager defaultManager] getUserInfoWithPlatform:plf currentViewController:nil completion:^(id result, NSError *error) {
    if (completion) {
      if (error) {
        NSString *msg = error.userInfo[@"NSLocalizedFailureReason"];
        if (!msg) {
          msg = error.userInfo[@"message"];
        }if (!msg) {
          msg = @"share failed";
        }
        NSInteger stCode = error.code;
        if(stCode == 2009){
          stCode = -1;
        }
        completion(@[msg]);
      } else {
        UMSocialUserInfoResponse *authInfo = result;

        NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:8];
          retDict[@"code"] = @(0);
          retDict[@"userId"] = authInfo.uid;
          retDict[@"openid"] = authInfo.openid;
          retDict[@"unionid"] = authInfo.unionId;
          retDict[@"accessToken"] = authInfo.accessToken;
          retDict[@"refreshToken"] = authInfo.refreshToken;
          retDict[@"expiration"] = authInfo.expiration;

          retDict[@"userName"] = authInfo.name;
          retDict[@"userAvatar"] = authInfo.iconurl;
          retDict[@"userGender"] = authInfo.unionGender;

        NSDictionary *originInfo = authInfo.originalResponse;
        retDict[@"city"] = originInfo[@"city"];
        retDict[@"province"] = originInfo[@"province"];
        retDict[@"country"] = originInfo[@"country"];

        completion(@[retDict]);
      }
    }
  }];



}


//分享小程序
RCT_EXPORT_METHOD(shareWeiapp:(NSString *)title descr:(NSString *)descr
                  link:(NSString *)link icon:(NSString *)icon
                  platform:(NSInteger)platform
                  userName:(NSString *)userName path:(NSString *)path
                   completion:(RCTResponseSenderBlock)completion)
{
    UMSocialPlatformType plf = [self platformType:platform];
    if (plf == UMSocialPlatformType_UnKnown) {
      if (completion) {
        completion(@[@(UMSocialPlatformType_UnKnown), @"invalid platform"]);
        return;
      }
    }
    NSData * dataImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:icon]];
    UIImage * resultImage =  [UIImage imageWithData:dataImage];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:descr thumImage:resultImage];
    shareObject.webpageUrl = link;
    shareObject.userName = userName;
    shareObject.path = path;
    shareObject.hdImageData = dataImage;
    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease;
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:plf messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {

       
    }];
}

    
RCT_EXPORT_METHOD(shareImageToPlatformType:(UMSocialPlatformType)platformType withThumb:(id)thumb image:(id)image)
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage = thumb;

    [shareObject setShareImage:image];

    // 设置Pinterest参数
    if (platformType == UMSocialPlatformType_Pinterest) {
       // messageObj.moreInfo = @{@"source_url": @"http://www.umeng.com",
       //                         @"app_name": @"U-Share",
       //                         @"suggested_board_name": @"UShareProduce",
       //                         @"description": @"U-Share: best social bridge"};
    }


    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {

       
    }];
}


@end
