# SNSConnect

## 初衷

一直以来，第三方登录，社交分享，第三方支付都是应用开发绕不过的坎。而这些第三方的平台提供的 OpenSDK，又以接口丑陋、难用、过时的 API 风格让人更加痛苦。Apple 这些年更新很快，`Swift` / `SPM` / `arm64-sim` / `xcframework`，逐渐被开发者接受，而这些大厂却原地踏步，明为兼容，实则摆烂。

为此，社区也有优秀的解决方案，[OpenShare](https://github.com/100apps/openshare)、[MonkeyKing](https://github.com/nixzhu/MonkeyKing)，但是面对重大更新（例如: `UniversalLink`），或者平台新增能力，却支持缓慢，无法及时响应变更，使得开发者被迫回滚使用官方支持。

## 解决的问题

- [x] 使用 Swift 接口
- [x] 同时支持 `SPM` 和 `CocoaPods`
- [x] 同时支持 **`ios-arm64`** 和 **`ios-arm64_x86_64-simulator`** 架构（封装各平台官方 OpenSDK）
- [x] **模块化**设计，可以仅导入需要的平台；也支持自主扩展其他第三方平台
- [x] 内建 `Concurrency` 和 `Combine` 支持
- [x] 已支持的平台：
    - [x] 微信（登录、分享、支付、小程序、平台功能）
    - [x] QQ（登录、分享）
    - [x] 微博（登录、分享）

## 部署要求

- iOS 13.0+
- Xcode 13.3+
- Swift 5.6+

## 安装

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "https://github.com/anotheren/SNSConnect.git", from: "1.0.0"),
],
targets: [
    .target(name: "YourAppOrFramework", dependencies: [
        .product(name: "SNSConnect", package: "SNSConnect"),
        .product(name: "SNSConnectWechat", package: "SNSConnect"),
        .product(name: "SNSConnectTencent", package: "SNSConnect"),
        .product(name: "SNSConnectWeibo", package: "SNSConnect"),
],
```

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
pod 'SNSConnect'
pod 'SNSConnectWechat'
pod 'SNSConnectTencent'
pod 'SNSConnectWeibo'
```

## 项目设置

### 1. 设置 Target -> Info

添加 `LSApplicationQueriesSchemes`，并设置必要的 Scheme

| 模块 | 平台 | Scheme |
| --- | --- | ---|
| SNSConnectWechat | 微信 | `weixin`, `weixinULAPI` |
| SNSConnectTencent | QQ | `mqqapi` |
| SNSConnectWeibo | 微博 | `weibosdk`, `weibosdk2.5`, `weibosdk3.3` | 

> 相关检查在 `DEBUG` 环境中会自动进行

### 2. 设置 Target -> Signing & Capabilities

在 Associated Domains 中添加你配置的 UniversalLink

> 如何部署 [Universal Links](https://developer.apple.com/ios/universal-links/)

### 3. 在工程中注册平台信息

```swift
// AppDelegate.swift
import SNSConnect
import SNSConnectWechat
import SNSConnectTencent
import SNSConnectWeibo

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // 注册需要的平台应用
    let wechat = WechatConnection(appID: "YOUR_WECAHT_APP_ID",
                                  universalLink: "https://YOUR_APP_UNIVERSAL_LINK")
    let tencent = TencentConnection(appID: "YOUR_TENCENT_APP_ID",
                                    universalLink: "https://YOUR_APP_UNIVERSAL_LINK")
    let weibo = WeiboConnection(appKey: "YOUR_WEIBO_APP_KEY",
                                universalLink: "https://YOUR_APP_UNIVERSAL_LINK")
    SNS.register(wechat, tencent, weibo)
    return true
}
```

> 对于 iOS14+ 的 SwiftUI 项目，请使用 [`UIApplicationDelegateAdaptor`](https://developer.apple.com/documentation/swiftui/uiapplicationdelegateadaptor) 来进行注册

### 4. 响应请求回调

```swift
// AppDelegate.swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if SNS.handleOpenURL(url) {
        return true
    }
    return false
}
    
func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if SNS.handleUserActivity(userActivity) {
        return true
    }
    return false
}
```

> 对于已使用 `UISceneDelegate` 的项目

```swift
// SceneDelegate.self
func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if SNS.handleUserActivity(userActivity) { ... }
}
```

> 对于 iOS14+ 的 SwiftUI 项目

```swift
@main
struct YourApp: App {
    
    @UIApplicationDelegateAdaptor
    private var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if SNS.handleOpenURL(url) { ... }
                }
        }
    }
}
```

## 接口设计

对登录(auth)、分享(share)、支付(pay)、小程序(launch)四个通用功能做了统一封装，默认以 Block 方式返回一个 `Result<SNSResponse, SNSError>`，同时，同名接口也支持 `Concurrency` 和 `Combine`。

```swift
// 登录
SNS.auth(.wechat()) { result in
    // handle result
}

// 分享
SNS.share(.wechat(scene: .session, ...)) { result in
    // handle result
}

// 支付
SNS.pay(.wechat(partnerId: "xxx", ...)) { result in
    // handle result
}

// 小程序
SNS.launch(.wechat(userName: "xxx", ...)) { result in
    // handle result
}
```

对于平台专有功能，统一封装在对应平台的 `only` 方法下，同时，同名接口也支持 `Concurrency` 和 `Combine`。

```swift
// 平台专有，微信客户服务
SNS.wechat.only(.customerService(corpID: "xxx", ...) { result in
    // handle result
}
```

## License

SNSConnect is released under the MIT license. See [LICENSE](./LICENSE) for details.