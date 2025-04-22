import Foundation

public struct FriendlyNumberFormatter {
	
	// MARK: - Stored Properties / Values
	
	private let thousand = CLongLong(powl(10, 3))
	private let million = CLongLong(powl(10, 6))
	private let billion = CLongLong(powl(10, 9))
	private let trillion = CLongLong(powl(10, 12))
	private let quadrillion = CLongLong(powl(10, 15))
	private let quintillion = CLongLong(powl(10, 18))
	
	// MARK: - Life Cycle
	
	public init() {}
	
}

// MARK: - Format

public extension FriendlyNumberFormatter {
	
	func string(from number: CLongLong) -> String {
		switch number {
		case thousand..<million:
			text(number: number, divider: thousand) + " K"
		case million..<billion:
			text(number: number, divider: million) + " M"
		case billion..<trillion:
			text(number: number, divider: billion) + " G"
		case trillion..<quadrillion:
			text(number: number, divider: trillion) + " T"
		case quadrillion..<quintillion:
			text(number: number, divider: quadrillion) + " P"
		case quintillion...:
			text(number: number, divider: quintillion) + " E"
		default:
			"\(number)"
		}
	}
	
}

// MARK: - Text

private extension FriendlyNumberFormatter {
	
	func text(
		number: CLongLong,
		divider: CLongLong
	) -> String {
		String(format: "%.1f", Double(number) / Double(divider))
	}
	
}
