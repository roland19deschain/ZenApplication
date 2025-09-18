// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "ZenApplication",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v15),
		.tvOS(.v15),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "ZenApplication",
			type: .static,
			targets: ["ZenApplication"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/roland19deschain/ZenSwift.git", from: "2.1.15")
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
