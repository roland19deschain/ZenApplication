import Foundation

/// Stable reference to a local file.
/// Designed to be persisted (e.g. in SQLite) without depending on sandbox absolute paths.
public struct LocalFilePath: Sendable, Equatable, Hashable, Codable {
	
	// MARK: - Nested Types
	
	public enum Root: String, Sendable, Codable, CaseIterable {
		case documents
		case caches
		case applicationSupport
		case bundle
	}
	
	// MARK: - Stored Properties
	
	public var root: Root
	/// POSIX-style relative path (no leading "/", no "..", no "file://")
	public var relativePath: String
	
	// MARK: - Life Cycle
	
	public init(root: Root, relativePath: String) {
		self.root = root
		self.relativePath = LocalFilePathBuilder().normalizedPath(
			from: relativePath
		)
	}
	
}

// MARK: - URL

public extension LocalFilePath {
	
	/// Absolute URL resolved for the current environment (sandbox / bundle).
	var url: URL {
		get throws {
			try url()
		}
	}
	
	/// Absolute URL resolved for the current environment (sandbox / bundle).
	func url(
		bundle: Bundle = .main,
		fileManager: FileManager = .default
	) throws -> URL {
		switch root {
		case .bundle:
			guard let url = bundle.url(
				forResource: relativePath,
				withExtension: nil
			) else {
				throw LocalFilePathError.bundleResourceNotFound(relativePath)
			}
			return url
		default:
			return try baseURL(
				fileManager: fileManager
			).appendingPathComponent(
				relativePath,
				isDirectory: false
			)
		}
	}
	
	private func baseURL(fileManager: FileManager) throws -> URL {
		let directory: FileManager.SearchPathDirectory = switch root {
		case .documents: .documentDirectory
		case .caches: .cachesDirectory
		case .applicationSupport: .applicationSupportDirectory
		case .bundle: throw LocalFilePathError.bundleURLGenerationFailure
		}
		return try fileManager.url(
			for: directory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
	}
	
}

// MARK: - Persistence

public extension LocalFilePath {
	
	/// A stable string suitable for persistence in DB.
	/// Example: "documents:images/abc.png"
	var persistedString: String {
		"\(root.rawValue):\(relativePath)"
	}
	
	init(persistedString: String) throws {
		guard let colon = persistedString.firstIndex(of: ":") else {
			throw LocalFilePathError.invalidFormat(persistedString)
		}
		let rootPart = String(persistedString[..<colon])
		let pathPart = String(
			persistedString[persistedString.index(after: colon)...]
		)
		guard let root = Root(rawValue: rootPart) else {
			throw LocalFilePathError.unknownRoot(rootPart)
		}
		self.root = root
		self.relativePath = LocalFilePathBuilder().normalizedPath(
			from: pathPart
		)
	}
	
}


// MARK: - Convenience

public extension LocalFilePath {
	
	static var empty: Self {
		LocalFilePath(
			root: .documents,
			relativePath: ""
		)
	}
	
}
