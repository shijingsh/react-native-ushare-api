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


#### Import library

```javascript
import umengShareApi from "react-native-ushare-api";
```

#### Select from gallery

Call single image picker

```javascript
umengShareApi.shareImg({}).then(image => {
  console.log(image);
});
```

## Install

```
npm i react-native-ushare-api --save
yarn add react-native-ushare-api
```

#### android
```
import com.mgUmeng.module.wxapi.WXEntryUShareActivity;

public class WXEntryActivity extends WXEntryUShareActivity {
}
```


#### add action in AndroidManifest.xml

```
        <activity
            android:name=".wxapi.WXEntryActivity"
            android:configChanges="keyboardHidden|orientation|screenSize"
            android:exported="true"
            android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```

#### add init in activity
```
  public void onCreate(Bundle savedInstanceState) {

    super.onCreate(savedInstanceState);

    UShareModule.initActivity(this);
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    UConfigure.onActivityResult(this,requestCode, resultCode, data);
  }
```

```
 public void onCreate() {
        super.onCreate();
        SoLoader.init(this, /* native exopackage */ false);
        initializeFlipper(this, getReactNativeHost().getReactInstanceManager());

        //Config.shareType = "react native";
        // 初始化Umeng分享
        UConfigure.init(this, "9636538", "umeng", 1, "");
    }

    {
        UConfigure.setWeixin("", "");
        UConfigure.setQQZone("", "");
        UConfigure.setSinaWeibo("", "", "www.baidu.com");
    }
```
### iOS



#### info.plist add the following to the file

```
	<key>NSCameraUsageDescription</key>
	<string>1</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string></string>
	<key>NSPhotoLibraryAddUsageDescription</key>
	<string>1</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>1</string>
```
auto linked

#### pod install 
cd ios and run
```bash
pod install
```

## License

_MIT_
