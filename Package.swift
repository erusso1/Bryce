// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BryceNetworking",
    platforms: [
        .iOS(.v12),
        .watchOS(.v5),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "BryceNetworking",
            targets: ["BryceNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/erusso1/AlamofireNetworkActivityLogger.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        .target(
            name: "BryceNetworking",
            dependencies: [
                "Alamofire",
                "AlamofireNetworkActivityLogger"
            ],
            path: "Bryce"),
        .testTarget(
            name: "BryceNetworkingTests",
            dependencies: ["BryceNetworking"]),
    ],
    swiftLanguageVersions: [.v5]
)
