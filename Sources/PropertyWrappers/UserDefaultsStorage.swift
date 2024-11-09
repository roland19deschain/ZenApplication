import Foundation
import Combine
import ZenSwift

@propertyWrapper public struct UserDefaultsStorage<T> {
	
	// MARK: - Computed Properties / Convenience
	
	public var isDefault: Bool {
		storage.object(forKey: key) == nil
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
	private let subject = PassthroughSubject<T, Never>()
	private var storage: UserDefaults = .standard
	
	// MARK: - Stored Properties / Wrapped Value
	
	public var wrappedValue: T {
		get {
			storage.object(forKey: key) as? T ?? defaultValue
		}
		set {
			if let optional = newValue as? AnyOptional, optional.isNil {
				storage.removeObject(forKey: key)
			} else {
				storage.set(newValue, forKey: key)
			}
			subject.send(newValue)
		}
	}
	
	// MARK: - Life Cycle
	
	public init(wrappedValue: T, key: String) {
		self.defaultValue = wrappedValue
		self.key = key
	}
	
}

// MARK: - ExpressibleByNilLiteral

public extension UserDefaultsStorage where T: ExpressibleByNilLiteral {
	
	init(key: String) {
		self.init(wrappedValue: nil, key: key)
	}
	
}
