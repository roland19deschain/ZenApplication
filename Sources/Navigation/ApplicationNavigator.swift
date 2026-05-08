import Foundation
import UIKit

public struct ApplicationNavigator: Sendable, Equatable, Hashable {
	
	// MARK: - Life Cycle
	
	public init() {}
	
	// MARK: - Actions
	
	@MainActor public func openApplicationSettings() {
		guard let url = URL(string: UIApplication.openSettingsURLString) else {
			return
		}
		UIApplication.shared.open(url)
	}
	
}
