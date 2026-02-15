import Foundation

public enum LocalFilePathError: Error {
	case bundleResourceNotFound(String)
	case bundleURLGenerationFailure
	case invalidFormat(String)
	case unknownRoot(String)
}

extension LocalFilePathError: LocalizedError {
	
	public var errorDescription: String? {
		switch self {
		case .bundleResourceNotFound(let path):
			"Bundle resource not found: \(path)"
		case .bundleURLGenerationFailure:
			"Bundle URL generation failure"
		case .invalidFormat(let path):
			"Invalid LocalFilePath format: \(path)"
		case .unknownRoot(let root):
			"Unknown LocalFilePath root: \(root)"
		}
	}
	
}
