// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BryceNetworking",
    platforms: [
        .iOS(.v10),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "BryceNetworking",
            targets: ["BryceNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", .upToNextMajor(from: "4.1.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.0.0-rc.3")),
        .package(url: "https://github.com/erusso1/AlamofireNetworkActivityLogger.git", .upToNextMajor(from: "3.0.1")),
        .package(url: "https://github.com/Otbivnoe/CodableAlamofire.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "BryceNetworking",
            dependencies: [
                "KeychainAccess",
                "Alamofire",
                "AlamofireNetworkActivityLogger",
                "CodableAlamofire"
            ],
            path: "Bryce"),
        .testTarget(
            name: "BryceNetworkingTests",
            dependencies: ["BryceNetworking"],
            path: "Example/Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
