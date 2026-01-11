// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SaveIt",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
    ],
    products: [
        .library(
            name: "SaveIt",
            targets: ["SaveIt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CreateWithPlayApp/PlaySDK.git", exact: "0.12.1-beta"),
    ],
    targets: [
        .target(
            name: "SaveIt",
            dependencies: [
                .product(name: "PlaySDK", package: "PlaySDK"),
                "SaveItFonts",
            "SaveItMedia",
            ],
            resources: [.copy("project.json")]
        ),
        .target(
            name: "SaveItFonts",
            resources: [
                .copy("NovaFlat.ttf"),
            ]
        ),
        .target(
            name: "SaveItMedia",
            resources: [
                .copy("Frame2xpng_2.png"),
                .copy("Frame2xpng_1.png"),
                .copy("Frame2xpng.png"),
                .copy("Pexels6963395.mp4"),
                .copy("Pexels7438482.mp4"),
            ]
        ),
    ]
)
