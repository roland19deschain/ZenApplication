import Dispatch

public struct Dispatcher {
	
	// MARK: - Stored Properties
	
	private static var onceTokens: [String] = []
	private static let dispatchSemaphore = DispatchSemaphore(value: 1)
	
	// MARK: - Dispatch
	
	/**
	Executes a block of code, associated with a unique token, only once. The code is thread safe and will
	only execute the code once even in the presence of multithreaded calls.
	- parameter token: A unique reverse DNS style name or a GUID
	- parameter block: Block to execute once
	*/
	public static func executeOnce(
		token: String,
		block: () -> Void
	) {
		dispatchSemaphore.wait()
		
		defer {
			dispatchSemaphore.signal()
		}
		
		guard !onceTokens.contains(token) else {
			return
		}
		onceTokens.append(token)
		
		block()
	}
	
}
