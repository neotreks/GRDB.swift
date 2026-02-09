// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

var swiftSettings: [SwiftSetting] = [
    .define("SQLITE_ENABLE_FTS5"),
]
var cSettings: [CSetting] = []

var swiftSettingsCipher: [SwiftSetting] = [
    .define("SQLITE_ENABLE_FTS5"),
    .define("SQLITE_HAS_CODEC"),
    .define("GRDBCIPHER"),
]

var cSettingsCipher: [CSetting] = [
    .define("SQLITE_HAS_CODEC"),
    .define("GRDBCIPHER"), 
    .define("SQLITE_ENABLE_FTS5"),
    .define("GRDB_SQLITE_ENABLE_PREUPDATE_HOOK")
]

var dependencies: [PackageDescription.Package.Dependency] = [
    .package(url: "https://github.com/neotreks/sqlcipher-distribution", from: "4.5.7")
]

// Don't rely on those environment variables. They are ONLY testing conveniences:
// $ SQLITE_ENABLE_PREUPDATE_HOOK=1 make test_SPM
if ProcessInfo.processInfo.environment["SQLITE_ENABLE_PREUPDATE_HOOK"] == "1" {
    swiftSettings.append(.define("SQLITE_ENABLE_PREUPDATE_HOOK"))
    cSettings.append(.define("GRDB_SQLITE_ENABLE_PREUPDATE_HOOK"))
    
    swiftSettingsCipher.append(.define("SQLITE_ENABLE_PREUPDATE_HOOK"))
    cSettingsCipher.append(.define("GRDB_SQLITE_ENABLE_PREUPDATE_HOOK"))
}

// The SPI_BUILDER environment variable enables documentation building
// on <https://swiftpackageindex.com/groue/GRDB.swift>. See
// <https://github.com/SwiftPackageIndex/SwiftPackageIndex-Server/issues/2122>
// for more information.
//
// SPI_BUILDER also enables the `make docs-localhost` command.
if ProcessInfo.processInfo.environment["SPI_BUILDER"] == "1" {
    dependencies.append(.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"))
}

let package = Package(
    name: "ATGRDB",
    defaultLocalization: "en", // for tests
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v7),
    ],
    products: [
        .library(name: "ATGRDB", targets: ["ATGRDB"]),
        .library(name: "ATGRDB-dynamic", type: .dynamic, targets: ["ATGRDB"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "ATGRDB",
            dependencies: [
                .product(name: "AccuTerraSQLCipher", package: "sqlcipher-distribution")
            ],
            path: "GRDB",
            resources: [.copy("PrivacyInfo.xcprivacy")],
            cSettings: cSettingsCipher,
            swiftSettings: swiftSettingsCipher
        ),
        .testTarget(
            name: "GRDBTests",
            dependencies: ["ATGRDB"],
            path: "Tests",
            exclude: [
                "CocoaPods",
                "Crash",
                "CustomSQLite",
                "GRDBManualInstall",
                "GRDBTests/getThreadsCount.c",
                "Info.plist",
                "Performance",
                "SPM",
                "Swift6Migration",
                "generatePerformanceReport.rb",
                "parsePerformanceTests.rb",
            ],
            resources: [
                .copy("GRDBTests/Betty.jpeg"),
                .copy("GRDBTests/InflectionsTests.json"),
                .copy("GRDBTests/Issue1383.sqlite"),
            ],
            cSettings: cSettingsCipher,
            swiftSettings: swiftSettingsCipher + [
                // Tests still use the Swift 5 language mode.
                .swiftLanguageMode(.v5),
                .enableUpcomingFeature("InferSendableFromCaptures"),
                .enableUpcomingFeature("GlobalActorIsolatedTypesUsability"),
            ])
    ],
    swiftLanguageModes: [.v6]
)
