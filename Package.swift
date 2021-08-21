// swift-tools-version:5.3

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
		)
	],
	dependencies: [],
	targets: [
		.target(
			name: "ZenApplication",
			dependencies: [],
			path: "ZenApplication/SourceCode/"
		)
	]
)
