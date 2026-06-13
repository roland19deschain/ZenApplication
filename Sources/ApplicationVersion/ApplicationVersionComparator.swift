import Foundation

/// Compares app version strings by their dot-separated numeric components.
///
/// Use this comparator for versions such as `"1.2.3"` where each component is
/// ordered numerically instead of lexicographically. Missing components are
/// treated as zero, so `"1.2"` and `"1.2.0"` are equal.
public struct ApplicationVersionComparator: Sendable {
	
	// MARK: - Nested Types
	
	/// The ordering relationship between two application version strings.
	public enum ComparisonResult: Sendable, Equatable {
		/// The left-hand version is lower than the right-hand version.
		case orderedAscending
		/// Both versions have the same numeric value.
		case orderedSame
		/// The left-hand version is greater than the right-hand version.
		case orderedDescending
	}
	
	// MARK: - Life Cycle
	
	/// Creates a comparator for application version strings.
	public init() {}
	
	// MARK: - Prime
	
	/// Compares two application version strings.
	///
	/// Components are separated by periods and compared as non-negative decimal
	/// integers. Leading zeroes are ignored, and numeric components are compared
	/// without converting them to `Int`, so very large component values keep their
	/// correct ordering. Empty components, missing trailing components and
	/// components without a leading digit are treated as zero. If a component
	/// contains a suffix, only its leading decimal digits participate in the
	/// comparison; for example, `"1.2-beta"` compares as `"1.2"`.
	///
	/// - Parameters:
	///   - lhsVersion: The version on the left side of the comparison.
	///   - rhsVersion: The version on the right side of the comparison.
	/// - Returns: The ordering relationship between `lhsVersion` and `rhsVersion`.
	public func compare(
		_ lhsVersion: String,
		_ rhsVersion: String
	) -> ComparisonResult {
		let lhsVersionComponents = lhsVersion.versionComponents
		let rhsVersionComponents = rhsVersion.versionComponents
		let count: Int = max(
			lhsVersionComponents.count,
			rhsVersionComponents.count
		)
		for index in 0..<count {
			let lhsVersionComponent: VersionComponent = index < lhsVersionComponents.count
			? lhsVersionComponents[index]
			: .zero
			let rhsVersionComponent: VersionComponent = index < rhsVersionComponents.count
			? rhsVersionComponents[index]
			: .zero
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

private struct VersionComponent: Comparable {

	// MARK: - Static Properties

	static let zero = VersionComponent(normalizedNumericPrefix: "0")

	// MARK: - Stored Properties

	private let normalizedNumericPrefix: String

	// MARK: - Life Cycle

	init(_ rawComponent: Substring) {
		let numericPrefix = rawComponent.prefix {
			$0.isASCIIDigit
		}
		let normalizedNumericPrefix = numericPrefix.drop {
			$0 == "0"
		}
		self.normalizedNumericPrefix = normalizedNumericPrefix.isEmpty
		? Self.zero.normalizedNumericPrefix
		: String(normalizedNumericPrefix)
	}

	private init(normalizedNumericPrefix: String) {
		self.normalizedNumericPrefix = normalizedNumericPrefix
	}

	// MARK: - Comparable

	static func < (
		lhs: VersionComponent,
		rhs: VersionComponent
	) -> Bool {
		guard lhs.normalizedNumericPrefix.count == rhs.normalizedNumericPrefix.count else {
			return lhs.normalizedNumericPrefix.count < rhs.normalizedNumericPrefix.count
		}
		return lhs.normalizedNumericPrefix < rhs.normalizedNumericPrefix
	}

}

private extension String {

	var versionComponents: [VersionComponent] {
		split(
			separator: ".",
			omittingEmptySubsequences: false
		).map {
			VersionComponent($0)
		}
	}

}

private extension Character {

	var isASCIIDigit: Bool {
		guard let unicodeScalar = unicodeScalars.first else {
			return false
		}
		return unicodeScalars.dropFirst().isEmpty
		&& unicodeScalar.value >= 48
		&& unicodeScalar.value <= 57
	}

}
