import Foundation
import Combine
import ZenSwift

@propertyWrapper public struct UserDefaultsStorage<T> {
	
	// MARK: - Computed Properties / Convenience
	
	public var isDefault: Bool {
		recursiveLock.lock()
		defer {
			recursiveLock.unlock()
		}
		return storage.object(forKey: key) == nil
	}
	
	public var publisher: AnyPublisher<T, Never> {
		subject.eraseToAnyPublisher()
	}
	
	public var projectedValue: UserDefaultsStorage<T> {
		self
	}
	
	// MARK: - Stored Properties / Tools
	
	private let key: String
	private let defaultValue: T
	private let subject: CurrentValueSubject<T, Never>
	private var storage: UserDefaults = .standard
	private let recursiveLock = NSRecursiveLock()
	
	// MARK: - Stored Properties / Wrapped Value
	
	public var wrappedValue: T {
		get {
			recursiveLock.lock()
			defer {
				recursiveLock.unlock()
			}
			return storage.object(forKey: key) as? T ?? defaultValue
		}
		set {
			recursiveLock.lock()
			if let optional = newValue as? AnyOptional, optional.isNil {
				storage.removeObject(forKey: key)
			} else {
				storage.set(newValue, forKey: key)
			}
			recursiveLock.unlock()
			subject.send(newValue)
		}
	}
	
	// MARK: - Life Cycle
	
	public init(wrappedValue: T, key: String) {
		self.defaultValue = wrappedValue
		self.key = key
		self.subject = CurrentValueSubject(
			storage.object(forKey: key) as? T ?? wrappedValue
		)
	}
	
}

// MARK: - ExpressibleByNilLiteral

public extension UserDefaultsStorage where T: ExpressibleByNilLiteral {
	
	init(key: String) {
		self.init(wrappedValue: nil, key: key)
	}
	
}
