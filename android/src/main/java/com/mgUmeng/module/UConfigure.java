package com.mgUmeng.module;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.os.Build.VERSION_CODES;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.socialize.Config;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.UMShareAPI;
/**
 * uShare config
 */
public class UConfigure {

    public static String WX_APPID ;

    public static void onActivityResult(Context context,int requestCode, int resultCode, Intent data){
        UMShareAPI.get(context).onActivityResult(requestCode, resultCode, data);
    }

    public static void preInit(Context context, String appKey, String channel){

        UMConfigure.preInit(context,appKey,channel);
    }

    public static void init(Context context, String appKey, String channel, int type, String secret){
        initRN("react-native","2.0");
        Config.shareType = "react native";
        UMConfigure.init(context,appKey,channel,type,secret);
    }

    @TargetApi(VERSION_CODES.KITKAT)
    private static void initRN(String v, String t){
        Method method = null;
        try {
            Class<?> config = Class.forName("com.umeng.commonsdk.UMConfigure");
            method = config.getDeclaredMethod("setWraperType", String.class, String.class);
            method.setAccessible(true);
            method.invoke(null, v,t);
        } catch (NoSuchMethodException | InvocationTargetException | IllegalAccessException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static void  setLogEnabled(boolean flag){
        UMConfigure.setLogEnabled(flag);
    }

    public static void  setWeixin(String s1,String s2){
        WX_APPID = s1;
        PlatformConfig.setWeixin(s1, s2);
    }
    public static void  setQQZone(String s1,String s2){
        PlatformConfig.setQQZone(s1, s2);
    }
    public static void  setSinaWeibo(String s1,String s2,String s3){
        PlatformConfig.setSinaWeibo(s1, s2,s3);
    }

    public static void  setFileProvider(String s1){
        PlatformConfig.setWXFileProvider(s1);
        PlatformConfig.setQQFileProvider(s1);
        PlatformConfig.setSinaFileProvider(s1);
    }

    /**
     * 防止内存泄露
     * 在使用分享或者授权的Activity中，重写onDestory()方法：
     * @param context
     */
    public static void release(Context context){
        UMShareAPI.get(context).release();
    }

}
