import Dispatch
import ZenSwift

public struct Dispatcher {
	
	// MARK: - Stored Properties
	
	private static var objects: [Weak<AnyObject>] = []
	private static var tokens: [String] = []
	private static let dispatchSemaphore = DispatchSemaphore(value: 1)
	
	// MARK: - Dispatch
	
	/// Executes a `block` of code, associated with a unique `token`, only once. The code is
	/// thread safe and will only execute the code once even in the presence of multithreaded calls.
	/// - Parameters:
	///   - token: A unique reverse DNS style name or a GUID
	///   - block: Block to execute once
	public static func executeOnce(
		token: String,
		block: () -> Void
	) {
		dispatchSemaphore.wait()
		defer {
			dispatchSemaphore.signal()
		}
		guard !tokens.contains(token) else {
			return
		}
		tokens.append(token)
		block()
	}
	
	/// Executes a `block` of code, associated with an `object`, only once. The code is
	/// thread safe and will only execute the code once even in the presence of multithreaded calls.
	/// - Parameters:
	///   - object: An object the address of which will be used to check uniqueness
	///   - block: Block to execute once
	public static func executeOnce(
		for object: AnyObject,
		block: () -> Void
	) {
		dispatchSemaphore.wait()
		defer {
			dispatchSemaphore.signal()
		}
		objects.cleanUp()
		guard !objects.contains(object) else {
			return
		}
		objects.append(Weak(object))
		block()
	}
	
}
