// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Bryce",
    platforms: [
        .iOS(.v12),
        .watchOS(.v5),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Bryce",
            targets: ["Bryce"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/erusso1/AlamofireNetworkActivityLogger.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .upToNextMajor(from: "4.2.2")),
        .package(url: "https://github.com/hmlongco/Resolver.git", from: "1.4.1"),
    ],
    targets: [
        .target(
            name: "Bryce",
            dependencies: [
                "Alamofire",
                "AlamofireNetworkActivityLogger",
                "KeychainAccess",
                "Resolver"
            ]),
        .testTarget(
            name: "BryceTests",
            dependencies: ["Bryce"],
            resources: [
                .process("Resources")]),
    ],
    swiftLanguageVersions: [.v5]
)
