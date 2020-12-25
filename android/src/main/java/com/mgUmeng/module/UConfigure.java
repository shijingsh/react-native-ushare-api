package com.mgUmeng.module;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build.VERSION_CODES;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.socialize.Config;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.UMShareAPI;
/**
 * uShare config
 */
public class UConfigure {

    public static UMShareAPI get(Context context){
        return UMShareAPI.get(context);
    }

    public static void init(Context context, String appkey, String channel, int type, String secret){
        initRN("react-native","2.0");
        Config.shareType = "react native";
        UMConfigure.init(context,appkey,channel,type,secret);
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

    public static void  setWeixin(String s1,String s2){
        PlatformConfig.setWeixin(s1, s2);
    }
    public static void  setQQZone(String s1,String s2){
        PlatformConfig.setQQZone(s1, s2);
    }
    public static void  setSinaWeibo(String s1,String s2,String s3){
        PlatformConfig.setSinaWeibo(s1, s2,s3);
    }
}
