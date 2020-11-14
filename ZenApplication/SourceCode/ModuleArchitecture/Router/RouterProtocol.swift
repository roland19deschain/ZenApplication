import UIKit
import SafariServices

public protocol RouterProtocol {
	
	func open(
		_ url: URL,
		in view: UIViewController,
		animated: Bool,
		completion: (() -> Void)?
	)
	
}

public extension RouterProtocol {
	
	func open(
		_ url: URL,
		in view: UIViewController,
		animated: Bool,
		completion: (() -> Void)?
	) {
		guard UIApplication.shared.canOpenURL(url) else {
			completion?()
			return
		}
		UIApplication.shared.open(
			url,
			options: [.universalLinksOnly: true]
		) { success in
			guard !success else {
				completion?()
				return
			}
			view.present(
				SFSafariViewController(url: url),
				animated: animated,
				completion: completion
			)
		}
	}
	
}
