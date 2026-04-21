import Foundation

public enum UserType: String, CaseIterable, Sendable, Equatable, Hashable {
	case regular
	case subscriber
	case premium
}

// MARK: - Convenience

public extension UserType {
	
	var isRegular: Bool {
		self == .regular
	}
	
	var isSubscriber: Bool {
		self == .subscriber
	}
	
	var isPremium: Bool {
		self == .premium
	}
	
	var isPayer: Bool {
		switch self {
		case .regular:
			false
		case .subscriber, .premium:
			true
		}
	}
	
}
