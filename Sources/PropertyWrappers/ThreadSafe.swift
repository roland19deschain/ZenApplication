import Foundation

@propertyWrapper public struct ThreadSafe<T> {
	
	// MARK: - Computed Properties / Convenience
	
	public var projectedValue: ThreadSafe<T> {
		self
	}
	
	// MARK: - Stored Properties / Values
	
	private var value: T
	
	// MARK: - Stored Properties / Tools
	
	private let lock = NSRecursiveLock()
	
	// MARK: - Stored Properties / Wrapped Value
	
	public var wrappedValue: T {
		get {
			synchronize {
				value
			}
		}
		set {
			synchronize {
				value = newValue
			}
		}
	}
	
	// MARK: - Life Cycle
	
	public init(wrappedValue: T) {
		self.value = wrappedValue
	}
	
}

// MARK: - Atomic Operations

public extension ThreadSafe {
	
	@discardableResult mutating func mutate<U>(
		_ action: (inout T) throws -> U
	) rethrows -> U {
		try synchronize {
			try action(&value)
		}
	}
	
}

// MARK: - Synchronization

private extension ThreadSafe {
	
	@discardableResult private func synchronize<U>(
		_ execute: () throws -> U
	) rethrows -> U {
		lock.lock()
		defer {
			lock.unlock()
		}
		return try execute()
	}
	
}

// MARK: - Sendable

extension ThreadSafe: @unchecked Sendable where T: Sendable {}
