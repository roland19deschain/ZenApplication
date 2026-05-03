import Foundation

public struct FeedbackEmailModel: Sendable, Equatable, Hashable {
	
	// MARK: - Stored Properties / Values
	
	public let adress: String
	public let subject: String?
	public let body: String?
	
	// MARK: - Life Cycle
	
	public init(
		adress: String,
		subject: String? = nil,
		body: String? = nil
	) {
		self.adress = adress
		self.subject = subject
		self.body = body
	}
	
}
