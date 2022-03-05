// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "ZenApplication",
	platforms: [
		.macOS(.v10_13),
		.iOS(.v12),
		.tvOS(.v12),
		.watchOS(.v2)
	],
	products: [
		.library(
			name: "ZenApplication",
			type: .static,
			targets: ["ZenApplication"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/roland19deschain/ZenSwift.git", from: "2.1.0")
	],
	targets: [
		.target(
			name: "ZenApplication",
			dependencies: [
				.product(name: "ZenSwift", package: "zenswift")
			],
			path: "Sources/"
		)
		,
		.testTarget(
			name: "ZenApplicationTests",
			dependencies: ["ZenApplication"],
			path: "Tests/"
		)
	],
	swiftLanguageVersions: [.v5]
)
