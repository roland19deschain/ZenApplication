import Foundation

public enum ApplicationError: Error {
	case operationCanceled
	case operationImpossible
	case mappingFailure
	case objectNotFound
	case objectAlreadyExist
	case incorrectData
	case prohibitedByUser
	case networkUnavailable
	case clientVersionIsDeprecated
	case missingPermissions
	case invalidURL(String)
}

// MARK: - Equatable

extension ApplicationError: Equatable {
	
	public static func ==(lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
		case (.operationCanceled, .operationCanceled),
			(.operationImpossible, .operationImpossible),
			(.mappingFailure, .mappingFailure),
			(.objectNotFound, .objectNotFound),
			(.objectAlreadyExist, .objectAlreadyExist),
			(.incorrectData, .incorrectData),
			(.prohibitedByUser, .prohibitedByUser),
			(.networkUnavailable, .networkUnavailable),
			(.clientVersionIsDeprecated, .clientVersionIsDeprecated),
			(.missingPermissions, .missingPermissions):
			return true
		case let (.invalidURL(lhsUrl), .invalidURL(rhsUrl)):
			return lhsUrl == rhsUrl
		default:
			return false
		}
	}
	
}
