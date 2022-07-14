// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SNSConnect",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "SNSConnect", targets: ["SNSConnect"]),
        .library(name: "SNSConnectTencent", targets: ["SNSConnectTencent"]),
        .library(name: "SNSConnectWechat", targets: ["SNSConnectWechat"]),
        .library(name: "SNSConnectWeibo", targets: ["SNSConnectWeibo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/anotheren/SNSConnectTencentRebuild.git", from: "1.0.0"),
        .package(url: "https://github.com/anotheren/SNSConnectWechatRebuild.git", from: "1.0.0"),
        .package(url: "https://github.com/anotheren/SNSConnectWeiboRebuild.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SNSConnect",
                dependencies: []),
        .target(name: "SNSConnectTencent",
                dependencies: [
                    "SNSConnect",
                    "SNSConnectTencentRebuild",
                ]),
        .target(name: "SNSConnectWechat",
                dependencies: [
                    "SNSConnect",
                    "SNSConnectWechatRebuild",
                ]),
        .target(name: "SNSConnectWeibo",
                dependencies: [
                    "SNSConnect",
                    "SNSConnectWeiboRebuild",
                ]),
    ]
)
