import Foundation

public enum ApplicationError: Sendable, Error {
	case earlyDeallocation
	case operationCanceled
	case operationImpossible
	case mappingFailure(String)
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
		case (.earlyDeallocation, .earlyDeallocation),
			(.operationCanceled, .operationCanceled),
			(.operationImpossible, .operationImpossible),
			(.objectNotFound, .objectNotFound),
			(.objectAlreadyExist, .objectAlreadyExist),
			(.incorrectData, .incorrectData),
			(.prohibitedByUser, .prohibitedByUser),
			(.networkUnavailable, .networkUnavailable),
			(.clientVersionIsDeprecated, .clientVersionIsDeprecated),
			(.missingPermissions, .missingPermissions):
			true
		case let (.invalidURL(lhsUrl), .invalidURL(rhsUrl)):
			lhsUrl == rhsUrl
		case let (.mappingFailure(lhsKeyPath), .mappingFailure(rhsKeyPath)):
			lhsKeyPath == rhsKeyPath
		default:
			false
		}
	}
	
}
