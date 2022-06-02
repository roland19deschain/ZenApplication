import Foundation

/// Subclass of `Operation` created as a base class for asynchronous operations.
/// - Override `main()` to implement the work logic.
/// - Use the `workQueue` field to handle responses.
/// - Call `notify(progress: Progress)` when part of the work is done.
/// - Call `finish(_ value: Value)` or `finish(_ error: Error)` when async work is finished or cancelled.
open class AsyncOperation<Value, Progress>: Operation {

	// MARK: - Nested Types

	private enum State: String {
		case ready = "isReady"
		case executing = "isExecuting"
		case finished = "isFinished"
	}

	// MARK: - Computed Properties - Models

	private var state: State {
			get {
				stateQueue.sync {
					_state
				}
			}
			set {
				let oldValue = state
				willChangeValue(forKey: state.rawValue)
				willChangeValue(forKey: newValue.rawValue)
				stateQueue.sync(flags: .barrier) {
					_state = newValue
				}
				didChangeValue(forKey: state.rawValue)
				didChangeValue(forKey: oldValue.rawValue)
			}
		}

	// MARK: - Stored Properties - Models

	private var _state: State = .ready

	// MARK: - Stored Properties - Queues

	private let stateQueue: DispatchQueue
	public let workQueue: DispatchQueue

	// MARK: - Stored Properties - Closures

	private let progressHandler: (Progress) -> Void
	private let completionHandler: (Result<Value, Error>) -> Void

	// MARK: - Life Cycle

	public init(
		progressHandler: @escaping (Progress) -> Void,
		completionHandler: @escaping (Result<Value, Error>) -> Void
	) {
		let description = String(describing: Self.self)
		self.stateQueue = .init(label: description + "StateQueue", attributes: .concurrent)
		self.workQueue = .init(label: description + "WorkQueue" )

		self.progressHandler = progressHandler
		self.completionHandler = completionHandler
	}

	// MARK: - Overriding

	open override var isReady: Bool {
		super.isReady && state == .ready
	}

	open override var isExecuting: Bool {
		state == .executing
	}

	open override var isAsynchronous: Bool {
		true
	}

	open override var isFinished: Bool {
		state == .finished
	}

	open override func start() {
		state = .executing

		guard !isCancelled else {
			finish(ApplicationError.operationCanceled)
			return
		}

		main()
	}

	open override func cancel() {
		super.cancel()

		finish(ApplicationError.operationCanceled)
	}

}

// MARK: - Controls

public extension AsyncOperation {

	func notify(progress: Progress) {
		progressHandler(progress)
	}

	func finish(_ value: Value) {
		guard isExecuting else {
			return
		}
		state = .finished

		completionHandler(.success(value))
	}

	func finish(_ error: Error) {
		guard isExecuting else {
			return
		}
		state = .finished

		completionHandler(.failure(error))
	}

}
