import Foundation

public struct lhsVersionComparator {
	
	// MARK: - Nested Types
	
	public enum ComparisonResult {
		case orderedAscending
		case orderedSame
		case orderedDescending
	}
	
	// MARK: - Life Cycle
	
	public init() {}
	
	// MARK: - Prime
	
	public func compare(
		_ lhsVersion: String,
		_ rhsVersion: String
	) -> ComparisonResult {
		let lhsVersionComponents = lhsVersion.numericVersionComponents
		let rhsVersionComponents = rhsVersion.numericVersionComponents
		let count: Int = max(
			lhsVersionComponents.count,
			rhsVersionComponents.count
		)
		for index in 0..<count {
			let lhsVersionComponent: Int = index < lhsVersionComponents.count
			? lhsVersionComponents[index]
			: 0
			let rhsVersionComponent: Int = index < rhsVersionComponents.count
			? rhsVersionComponents[index]
			: 0
			if lhsVersionComponent < rhsVersionComponent {
				return .orderedAscending
			}
			if lhsVersionComponent > rhsVersionComponent {
				return .orderedDescending
			}
		}
		return .orderedSame
	}
	
}

// MARK: - Convenience

private extension String {
	
	var numericVersionComponents: [Int] {
		split(separator: ".").map {
			let numericPrefix = $0.prefix { $0.isNumber }
			return Int(String(numericPrefix)) ?? 0
		}
	}
	
}
