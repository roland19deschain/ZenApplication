import Foundation

public enum ApplicationError: Error {
	case operationCanceled
	case mappingFailure
	case objectNotFound
	case incorrectData
	case prohibitedByUser
	case networkUnavailable
	case gameCenterUnavailable
	case invalidURL(String)
	case clientVersionIsDeprecated
	case deviceCannotSendEmail
	case missingPrivacyPolicy
	case missingPermissions
}
