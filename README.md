# react-native-ushare-api

iOS/Android umeng share api

## Result


## Usage

<a href="https://nodei.co/npm/react-native-ushare-api/">
  <img src="https://nodei.co/npm/react-native-ushare-api.svg?downloads=true&downloadRank=true&stars=true">
</a>
<p>
  <a href="https://badge.fury.io/js/react-native-ushare-api">
    <img src="https://badge.fury.io/js/react-native-ushare-api.svg" alt="npm version" height="18">
  </a>
  <a href="https://npmjs.org/react-native-ushare-api">
    <img src="https://img.shields.io/npm/dm/react-native-ushare-api.svg" alt="npm downloads" height="18">
  </a>
  <a href="https://travis-ci.org/aws/react-native-ushare-api">
    <img src="https://travis-ci.org/aws/react-native-ushare-api.svg?branch=master" alt="build:started">
  </a>
  <a href="https://codecov.io/gh/aws/react-native-ushare-api">
    <img src="https://codecov.io/gh/aws/react-native-ushare-api/branch/master/graph/badge.svg" />
  </a>
</p>

## Install

```
npm i react-native-ushare-api --save
yarn add react-native-ushare-api
```


### Import library

```javascript
import UShare from "react-native-ushare-api";
```

### Call share

//初始化sdk,用于延长初始化，需在用户同意隐私协议后调用。
```javascript
        UShare.initSDK("5fe93e0544bb94418a66cc9f", "umeng", 1, "",function (data) {

        });
``` 

```javascript
const SharePlatform = {
    QQ: 0,
    SINA: 1,
    WECHAT: 2,
    WECHATMOMENT: 3,
    QQZONE: 4
}
```

#### share link
```javascript
        UShare.share("title",
            "data.description",
            "webPageUrl",
            "thumbImageUrl",
            SharePlatform.WECHAT, //platform
            (code, message) => {
                //分享成功
               
            });
```
#### share text
```javascript
        UShare.shareText("title",
            SharePlatform.WECHAT, //platform
            (code, message) => {
                //分享成功
               
            });
```

#### share image
```javascript
        UShare.shareImg("url",
            SharePlatform.WECHAT, //platform
            (code, message) => {
                //分享成功
               
            });
```

#### share weiapp 拉起微信小程序
```javascript
        UShare.openWeiapp("wx37508906e9cb2cda", //微信开放平台AppID
            "",
            userName,//原始ID
            0,
            (code, message) => {
              
            });
 ```       

#### 微信授权信息
```javascript
         UShare.authLogin(SharePlatform.WECHAT, (result) => {
             // code: 0成功
             if(result.code === 0) {
                 
             }
         });
 ```      
    

### android

#### app build.gradle add
```
allprojects {
    repositories {
        ...
        mavenCentral()
        maven { url  'https://repo1.maven.org/maven2/'}
        flatDir {
            dirs project(':react-native-ushare-api').file('libs'), 'libs'
        }
    }
}
```

#### app build.gradle defaultConfig add
```
manifestPlaceholders = [UmengAppKey: "\\09636538",QQAppId: "tencent11023232",qqappid:"tencent11023232"]
```

```
import com.umeng.socialize.weixin.view.WXCallbackActivity;

public class WXEntryActivity extends WXCallbackActivity {

}
```


#### add action in AndroidManifest.xml

```
  <queries>
        <package android:name="com.tencent.mm" />
        <package android:name="com.tencent.mobileqq" />
        <package android:name="com.tencent.wework" />
        <package android:name="com.qzone" />
        <package android:name="com.sina.weibo" />
        <package android:name="com.alibaba.android.rimet" />
        <package android:name="com.eg.android.AlipayGphone" />
    </queries>

    <application
      android:name=".MainApplication"
      android:label="@string/app_name"
      android:icon="@mipmap/ic_launcher"
      android:roundIcon="@mipmap/ic_launcher_round"
      android:allowBackup="false"
      android:theme="@style/AppTheme">
        <activity
            android:name=".wxapi.WXEntryActivity"
            android:configChanges="keyboardHidden|orientation|screenSize"
            android:exported="true"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />

        ...
    </application>
```

#### add init in activity
```
  public void onCreate(Bundle savedInstanceState) {

    super.onCreate(savedInstanceState);
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    UConfigure.onActivityResult(this,requestCode, resultCode, data);
  }

  @Override
  protected void onDestroy(){
    super.onDestroy();
    //防止内存泄露
    UConfigure.release(this);
  }
```

```
 public void onCreate() {
        super.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
        initializeFlipper(this, getReactNativeHost().getReactInstanceManager());

      // 日志
      UConfigure.setLogEnabled(true);
      // 初始化Umeng分享
      UConfigure.init(getApplicationContext(), "5fe93e0544bb94418a66cc9f", "umeng", 1, "");
      // 延长初始化Umeng分享
      //UConfigure.preInit(this, "5fe93e0544bb94418a66cc9f", "umeng");
      

      UConfigure.setWeixin("wx37508906e9cb2cda", "e53dcbd6ab70402b757a59d4b7a10c83");
      UConfigure.setQQZone("1106747599", "ihDC3Ox2y64EWteF");
      UConfigure.setSinaWeibo("652858587", "fd9b6e1035d2a865e624257cfebce847", "www.baidu.com");
      UConfigure.setFileProvider("com.xiushangapp.fileprovider");
    }
```

### iOS



#### info.plist add the following to the file

```xml
<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>wechat</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>wb3921700954</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleIdentifier</key>
			<string></string>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>weixin</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>wx37508906e9cb2cda</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>QQ</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>tencent11023232</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>www.xiushangsh.com/xiushangApp/</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>https</string>
			</array>
		</dict>
	</array>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>wechat</string>
		<string>weixin</string>
		<string>weixinULAPI</string>
		<string>sinaweibohd</string>
		<string>sinaweibo</string>
		<string>sinaweibosso</string>
		<string>weibosdk</string>
		<string>weibosdk2.5</string>
		<string>mqqapi</string>
		<string>mqq</string>
		<string>mqqOpensdkSSoLogin</string>
		<string>mqqconnect</string>
		<string>mqqopensdkdataline</string>
		<string>mqqopensdkgrouptribeshare</string>
		<string>mqqopensdkfriend</string>
		<string>mqqopensdkapi</string>
		<string>mqqopensdkapiV2</string>
		<string>mqqopensdkapiV3</string>
		<string>mqqopensdkapiV4</string>
		<string>mqzoneopensdk</string>
		<string>wtloginmqq</string>
		<string>wtloginmqq2</string>
		<string>mqqwpa</string>
		<string>mqzone</string>
		<string>mqzonev2</string>
		<string>mqzoneshare</string>
		<string>wtloginqzone</string>
		<string>mqzonewx</string>
		<string>mqzoneopensdkapiV2</string>
		<string>mqzoneopensdkapi19</string>
		<string>mqzoneopensdkapi</string>
		<string>mqqbrowser</string>
		<string>mttbrowser</string>
		<string>TencentWeibo</string>
		<string>tencentweiboSdkv2</string>
		<string>fbapi</string>
		<string>fb-messenger-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
```

#### AppDelegate.m
```
#import <UMShare/UMShare.h>
#import <UMShare/UMSocialManager.h>
#import <UMShare/WXApi.h>
#import <UMCommon/UMCommon.h>
...

/* Umeng init  in didFinishLaunchingWithOptions */
  [UMConfigure initWithAppkey:@"xxxxxxxxx" channel:@"App Store" ];

  //配置微信平台的Universal Links
  //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
  [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://www.xiushangsh.com/xiushangApp/",
                                                      @(UMSocialPlatformType_QQ):@"https://www.xiushangsh.com/xiushangApp/"
                                                      };
  /* Share init */


  /* 微信聊天 */
  [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"xxxxxxxxx" appSecret:@"xxxxxxxxx" redirectURL:nil];

  /*QQ*/
  [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"xxxxxxxxx"  appSecret:@"xxxxxxxxx" redirectURL:nil];

  /* 新浪 */
  [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"xxxxxxxxx"  appSecret:@"fd9b6e1035d2a865e624257cfebce847" redirectURL:nil];

...

//设置系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
//UniversalLink 回调
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler
{
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    return YES;
}

```

#### pod install 
cd ios and run
```bash
pod install
```

#### UniversalLink

Universal links失效，可能原因：


1）工程配置associated domain未打开或未添加Universal links域名
2）配置文件未上线或未按苹果要求放在服务器指定的路径下(root/.well-known/apple-app-site-association)
3）配置文件的Universal links的path末尾没有加通配符*
4）配置文件的appID（teamID+bundleID）与实际代码包不匹配

注意必须.well-known目录下
https:///.well-known/apple-app-site-association
并且域名不能重定向
You must host the file using https:// with a valid certificate and with no redirects.
https://developer.apple.com/documentation/safariservices/supporting_associated_domains

2.在ios13之前的设备可以通过universal link打开app，但是ios14不能打开了

原因是在ios13访问apple-app-site-association文件是通过设备去访问的，ios14之后是由apple的服务器区去访问。我们的问题是设备在本地网络下能访问到apple-app-site-association文件，但是苹果服务器访问走的是海外网络，ssl证书有问题导致不能访问到apple-app-site-association文件。修改这个问题之后就能顺利的打开app了。
```json
{
    "applinks": {
        "apps": [],
        "details": [
            {
                "appID": "DHJ4UU24CJ.com.xxxx.test.xiushangApp", 
                "paths": ["/xiushangApp/*"]
            },
             {
                            "appID": "DHJ4UU24CJ.com.xxx.xiushangApp",
                            "paths": ["/xiushangApp/*"]
             }
        ]
    }
}
```
## License

_MIT_
