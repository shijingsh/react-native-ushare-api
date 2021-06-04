package com.mgUmeng.module;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.tencent.mm.opensdk.modelbiz.WXLaunchMiniProgram;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;
import com.mgUmeng.module.utils.BitMapUtil;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMAuthListener;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.UMShareListener;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;
import com.umeng.socialize.media.UMWeb;

import java.util.Map;

import com.alipay.sdk.app.PayTask;
import com.alipay.sdk.app.EnvUtils;

import com.tencent.mm.opensdk.modelpay.PayReq;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Arguments;


public class UShareModule extends ReactContextBaseJavaModule implements ActivityEventListener {

    private Context context;
    private static Activity mActivity;
    private static Handler mHandler = new Handler(Looper.getMainLooper());

    public static void initActivity(Activity activity) {
        mActivity = activity;
    }

    public UShareModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
    }

    private static void runOnMainThread(Runnable task) {
        mHandler.post(task);
    }

    @Override
    public String getName() {
        return "umengShareApi";
    }

    @ReactMethod
    public void setAppKey(String appkey) {

    }

    @ReactMethod
    public void setWXAppId(String appid, String secret) {
        PlatformConfig.setWeixin(appid, secret);
    }

    @ReactMethod
    public void setQQZone(String appid, String secret) {
        PlatformConfig.setQQZone(appid, secret);
    }

    @ReactMethod
    public void setSinaWeibo(String appkey, String secret,String s3) {
        PlatformConfig.setSinaWeibo(appkey, secret,s3);
    }
    /**
     * 分享手机本地图片
     */
    @ReactMethod
    public void shareImg(String imgPath, final int platform, final Callback resultCallback) {

        final SHARE_MEDIA sharePlatform = getSharePlatform(platform);
        if(UMShareAPI.get(mActivity).isInstall(mActivity, sharePlatform)) {
            UMImage image = null;
            if(!imgPath.startsWith("http")){
                Bitmap img = BitmapFactory.decodeFile(BitMapUtil.getImageAbsolutePath(mActivity, Uri.parse(imgPath)));
                image =  new UMImage(mActivity, BitMapUtil.ImageCompress(img));
            }else{
                image = new UMImage(mActivity, imgPath);
            }
            new ShareAction(mActivity)
                    .setPlatform(sharePlatform)
                    .withMedia(image)
                    .setCallback(new UMShareListener() {
                        @Override
                        public void onStart(SHARE_MEDIA share_media) {
                            //分享开始的回调
                        }

                        @Override
                        public void onResult(SHARE_MEDIA share_media) {
                            resultCallback.invoke("分享成功");
                        }

                        @Override
                        public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                            resultCallback.invoke("分享失败：" + throwable.getMessage());
                        }

                        @Override
                        public void onCancel(SHARE_MEDIA share_media) {
                            resultCallback.invoke("取消分享");
                        }
                    })
                    .share();
        }
    }

    /**
     * 分享文本
     */
    @ReactMethod
    public void shareText(String text, final int platform, final Callback resultCallback) {

        final SHARE_MEDIA sharePlatform = getSharePlatform(platform);
        if(UMShareAPI.get(mActivity).isInstall(mActivity, sharePlatform)) {

            if(platform==0){
                //qq 不支持存文本
                UMImage image = new UMImage(mActivity, "https://www.xiushangsh.com/logo.png");
                new ShareAction(mActivity)
                        .setPlatform(sharePlatform)
                        .withText(text)
                        .withMedia(image)
                        .setCallback(new UMShareListener() {
                            @Override
                            public void onStart(SHARE_MEDIA share_media) {
                                //分享开始的回调
                            }

                            @Override
                            public void onResult(SHARE_MEDIA share_media) {
                                resultCallback.invoke("分享成功");
                            }

                            @Override
                            public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                                resultCallback.invoke("分享失败：" + throwable.getMessage());
                            }

                            @Override
                            public void onCancel(SHARE_MEDIA share_media) {
                                resultCallback.invoke("取消分享");
                            }
                        })
                        .share();
            }else{
                new ShareAction(mActivity)
                        .setPlatform(sharePlatform)
                        .withText(text)
                        .setCallback(new UMShareListener() {
                            @Override
                            public void onStart(SHARE_MEDIA share_media) {
                                //分享开始的回调
                            }

                            @Override
                            public void onResult(SHARE_MEDIA share_media) {
                                resultCallback.invoke("分享成功");
                            }

                            @Override
                            public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                                resultCallback.invoke("分享失败：" + throwable.getMessage());
                            }

                            @Override
                            public void onCancel(SHARE_MEDIA share_media) {
                                resultCallback.invoke("取消分享");
                            }
                        })
                        .share();
            }

        }
    }

    /**
     * 分享链接
     * @param title
     * @param description
     * @param contentUrl
     * @param imgUrl
     * @param platform
     * @param resultCallback
     */
    @ReactMethod
    public void share(String title, String description, String contentUrl,
                      String imgUrl, final int platform, final Callback resultCallback) {
        final SHARE_MEDIA sharePlatform = getSharePlatform(platform);
        if(UMShareAPI.get(mActivity).isInstall(mActivity, sharePlatform)) {
            final UMWeb web = new UMWeb(contentUrl);
            web.setTitle(title); //标题
            web.setThumb(new UMImage(context, imgUrl));  //缩略图
            web.setDescription(description); //描述
            new ShareAction(mActivity)
                    .setPlatform(sharePlatform)
                    .withMedia(web) // 分享链接
                    .setCallback(new UMShareListener() {
                        @Override
                        public void onStart(SHARE_MEDIA share_media) {
                            //分享开始的回调
                        }

                        @Override
                        public void onResult(SHARE_MEDIA share_media) {
                            resultCallback.invoke("分享成功");
                        }

                        @Override
                        public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                            resultCallback.invoke("分享失败：" + throwable.getMessage());
                        }

                        @Override
                        public void onCancel(SHARE_MEDIA share_media) {
                            resultCallback.invoke("取消分享");
                        }
                    })
                    .share();
        } else {
            resultCallback.invoke("未安装该软件");
        }
    }
    @ReactMethod
    public void openWeiapp(String appId, String path, String userName ,int miniprogramType , final Callback resultCallback){

        IWXAPI api = WXAPIFactory.createWXAPI(context, appId);

        try{
            WXLaunchMiniProgram.Req req = new WXLaunchMiniProgram.Req();
            req.userName = userName; // 填小程序原始id
            req.path = path;                  ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
            req.miniprogramType = miniprogramType;// 可选打开 开发版，体验版和正式版
            api.sendReq(req);

            resultCallback.invoke("分享成功");
        }catch (Exception ex){
            resultCallback.invoke("分享失败：" + ex.getMessage());
        }

    }

    @ReactMethod
    public void shareWeiapp(String title, String description, String contentUrl,
                            String imgUrl, final int platform,String path,String user_name, final Callback resultCallback){

        final SHARE_MEDIA sharePlatform = getSharePlatform(platform);

        UMMin umMin = new UMMin(contentUrl);
        umMin.setThumb(new UMImage(context, imgUrl));
        umMin.setTitle(title);
        umMin.setDescription(description);
        umMin.setPath(path);
        umMin.setUserName(user_name);
        new ShareAction(mActivity)
                .withMedia(umMin)
                .setPlatform(sharePlatform)
                .setCallback(new UMShareListener() {
                    @Override
                    public void onStart(SHARE_MEDIA share_media) {
                        //分享开始的回调
                    }

                    @Override
                    public void onResult(SHARE_MEDIA share_media) {
                        resultCallback.invoke("分享成功");
                    }

                    @Override
                    public void onError(SHARE_MEDIA share_media, Throwable throwable) {
                        resultCallback.invoke("分享失败：" + throwable.getMessage());
                    }

                    @Override
                    public void onCancel(SHARE_MEDIA share_media) {
                        resultCallback.invoke("取消分享");
                    }
                }).share();

    }

    /**
     * 获取用户授权资料
     * 推荐直接使用该方式实现，因为本质上三方登录最终都需要拉取三方平台的用户资料，
     * 从这点来说，直接调用SDK和通过后台服务器请求，安全性是一样的
     */
    @ReactMethod
    public void authLogin(int platform, final Callback resultCallback) {

        final WritableMap result = new WritableNativeMap();
        final SHARE_MEDIA sharePlatform = getSharePlatform(platform);

        if(UMShareAPI.get(mActivity).isInstall(mActivity, sharePlatform)) {
            UMShareAPI.get(mActivity).getPlatformInfo(mActivity, sharePlatform, new UMAuthListener() {
                @Override
                public void onStart(SHARE_MEDIA share_media) {
                }

                @Override
                public void onComplete(SHARE_MEDIA share_media, int i, Map<String, String> map) {
                    /**
                     *
                     uid   用户唯一标识
                     name	 用户昵称
                     gender	 用户性别	该字段会直接返回男/女
                     iconurl 用户头像
                     */
                    result.putInt("code", 0);
                    result.putString("userId", map.get("uid"));
                    result.putString("openid", map.get("openid"));
                    result.putString("unionid", map.get("unionid"));
                    result.putString("accessToken", map.get("accesstoken"));
                    result.putString("userName", map.get("name"));
                    result.putString("userGender", map.get("gender"));
                    result.putString("userAvatar", map.get("iconurl"));
                    resultCallback.invoke(result);
                }

                @Override
                public void onError(SHARE_MEDIA share_media, int i, Throwable throwable) {
                    result.putInt("code", 1);
                    resultCallback.invoke(result);
                    Log.e("--react-native-share--","授权登录失败: " + throwable.getMessage());
                }

                @Override
                public void onCancel(SHARE_MEDIA share_media, int i) {
                    result.putInt("code", 2);
                    resultCallback.invoke(result);
                    Log.e("--react-native-share--","取消授权登录: " + i);
                }
            });
        } else {
            Log.e("--react-native-share--","设备未安装App软件" );
        }

    }


    @ReactMethod
    public void setAlipaySandbox(Boolean isSandbox) {
        if(isSandbox){
            EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX);
        }else {
            EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE);
        }
    }

    @ReactMethod
    public void alipay(final String orderInfo, final Callback promise) {
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                PayTask alipay = new PayTask(getCurrentActivity());
                Map<String, String> result = alipay.payV2(orderInfo, true);
                WritableMap map = Arguments.createMap();
                map.putString("memo", result.get("memo"));
                map.putString("result", result.get("result"));
                map.putString("resultStatus", result.get("resultStatus"));
                promise.invoke(map);
            }
        };
        // 必须异步调用
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    @ReactMethod
    public void wxPay(ReadableMap params, final Callback callback) {
        IWXAPI api = WXAPIFactory.createWXAPI(getCurrentActivity(), UConfigure.WX_APPID);
        //data  根据服务器返回的json数据创建的实体类对象
        PayReq req = new PayReq();
        req.appId = UConfigure.WX_APPID;
        req.partnerId = params.getString("partnerId");
        req.prepayId = params.getString("prepayId");
        req.packageValue = params.getString("packageValue");
        req.nonceStr = params.getString("nonceStr");
        req.timeStamp = params.getString("timeStamp");
        req.sign = params.getString("sign");
        api.registerApp(UConfigure.WX_APPID);
        XWXPayEntryActivity.callback = new WXPayCallBack() {
            @Override
            public void callBack(WritableMap result) {
                callback.invoke(result);
            }
        };
        //发起请求
        api.sendReq(req);
    }

    /**
     * 分享或登录处理后的回调
     * @param activity
     * @param requestCode
     * @param resultCode
     * @param data
     */
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        UMShareAPI.get(mActivity).onActivityResult(requestCode, resultCode, data);
    }

    public void onNewIntent(Intent intent) {
    }

    /**
     * 平台对应编号
     * @param platform
     * @return
     */
    private SHARE_MEDIA getSharePlatform(int platform){
        switch (platform) {
            case 0:
                return SHARE_MEDIA.QQ;
            case 1:
                return SHARE_MEDIA.SINA;
            case 2:
                return SHARE_MEDIA.WEIXIN;
            case 3:
                return SHARE_MEDIA.WEIXIN_CIRCLE;
            case 4:
                return SHARE_MEDIA.QZONE;
            case 5:
                return SHARE_MEDIA.FACEBOOK;
            default:
                return null;
        }
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        UMShareAPI.get(mActivity).onActivityResult(requestCode, resultCode, data);
    }
}
