import Foundation

public enum PresentationStyle: String, Sendable, Equatable, CaseIterable, Hashable {
	case push
	case modal
}

// MARK: Convenience

public extension PresentationStyle {
	
	var isPush: Bool {
		self == .push
	}
	
	var isModal: Bool {
		self == .modal
	}
	
}
