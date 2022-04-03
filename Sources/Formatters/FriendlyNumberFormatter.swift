import Foundation

public struct FriendlyNumberFormatter {
	
	// MARK: - Stored Properties
	
	private let thousand: CLongLong = .init(powl(10, 3))
	private let million: CLongLong = .init(powl(10, 6))
	private let billion: CLongLong = .init(powl(10, 9))
	private let trillion: CLongLong = .init(powl(10, 12))
	private let quadrillion: CLongLong = .init(powl(10, 15))
	private let quintillion: CLongLong = .init(powl(10, 18))
	
	// MARK: - Life Cycle
	
	public init() {}
	
}

// MARK: - Format

public extension FriendlyNumberFormatter {
	
	func string(from number: CLongLong) -> String {
		switch number {
		case thousand..<million:        return text(number: number, divider: thousand) + " K"
		case million..<billion:         return text(number: number, divider: million) + " M"
		case billion..<trillion:        return text(number: number, divider: billion) + " G"
		case trillion..<quadrillion:    return text(number: number, divider: trillion) + " T"
		case quadrillion..<quintillion: return text(number: number, divider: quadrillion) + " P"
		case quintillion...:            return text(number: number, divider: quintillion) + " E"
		default:                        return "\(number)"
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
