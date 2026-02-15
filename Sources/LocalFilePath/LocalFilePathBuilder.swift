import Foundation

struct LocalFilePathBuilder {
	
	func normalizedPath(from raw: String) -> String {
		var string = raw.trimmingCharacters(in: .whitespacesAndNewlines)
		// Strip file:// if someone passes URL.absoluteString by mistake
		if string.hasPrefix("file://") {
			// Convert to URL then take path (best-effort)
			if let url = URL(string: string) {
				string = url.path
			}
		}
		// Normalize path separators
		string = string.replacingOccurrences(of: "\\", with: "/")
		// Remove leading "/" to keep it relative
		while string.hasPrefix("/") {
			string.removeFirst()
		}
		// Collapse multiple slashes
		while string.contains("//") {
			string = string.replacingOccurrences(of: "//", with: "/")
		}
		// Prevent path traversal
		// Very strict: if contains ".." segment, drop it (or you can fatal/throw)
		let parts: [String.SubSequence] = string.split(separator: "/").filter {
			$0 != "." && $0 != ".."
		}
		return parts.joined(separator: "/")
	}
	
}
