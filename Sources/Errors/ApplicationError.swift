import Foundation

public enum ApplicationError: Error {
	case operationCanceled
	case mappingFailure
	case objectNotFound
	case incorrectData
	case prohibitedByUser
	case networkUnavailable
	case gameCenterUnavailable
	case clientVersionIsDeprecated
	case deviceCannotSendEmail
	case missingPrivacyPolicy
	case missingPermissions
	case invalidURL(String)
}

// MARK: - Equatable

extension ApplicationError: Equatable {
	
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.operationCanceled, .operationCanceled),
			(.mappingFailure, .mappingFailure),
			(.objectNotFound, .objectNotFound),
			(.incorrectData, .incorrectData),
			(.prohibitedByUser, .prohibitedByUser),
			(.networkUnavailable, .networkUnavailable),
			(.gameCenterUnavailable, .gameCenterUnavailable),
			(.clientVersionIsDeprecated, .clientVersionIsDeprecated),
			(.deviceCannotSendEmail, .deviceCannotSendEmail),
			(.missingPrivacyPolicy, .missingPrivacyPolicy),
			(.missingPermissions, .missingPermissions):
			return true
		case let (.invalidURL(lhsUrl), .invalidURL(rhsUrl)):
			return lhsUrl == rhsUrl
		default:
			return false
		}
	}
	
}
