// swift-tools-version:6.0

import PackageDescription

let package = Package(
	name: "ZenApplication",
	platforms: [
		.iOS(.v14),
		.tvOS(.v14),
		.macOS(.v10_15),
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
		.package(url: "https://github.com/roland19deschain/ZenSwift.git", from: "2.1.13")
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
	swiftLanguageModes: [.v6]
)
