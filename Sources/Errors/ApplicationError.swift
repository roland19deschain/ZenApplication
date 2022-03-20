import Foundation

public enum ApplicationError: Error {
	case invalidURL(String)
	case clientVersionIsDeprecated
	case operationCanceled
	case mappingFailure
	case incorrectData
	case gameCenterUnavailable
	case networkUnavailable
	case deviceCannotSendEmail
	case missingPrivacyPolicy
	case missingPermissions
	case prohibitedByUser
}
