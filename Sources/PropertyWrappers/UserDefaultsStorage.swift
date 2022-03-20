import Foundation
import Combine
import ZenSwift

@propertyWrapper public struct UserDefaultsStorage<T> {
	
	// MARK: - Computed Properties - Convenience
	
	public var isDefault: Bool {
		storage.object(forKey: key) == nil
	}
	
	public var projectedValue: AnyPublisher<T, Never> {
		publisher.eraseToAnyPublisher()
	}
	
	// MARK: - Stored Properties - Tools
	
	private let key: String
	private let defaultValue: T
	private let publisher: PassthroughSubject<T, Never> = .init()
	private var storage: UserDefaults = .standard
	
	// MARK: - Stored Properties - Wrapped Value
	
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
			publisher.send(newValue)
		}
	}
	
	// MARK: - Life Cycle
	
	public init(wrappedValue: T, key: String) {
		self.defaultValue = wrappedValue
		self.key = key
	}
	
}

// MARK: - Oprtional

public extension UserDefaultsStorage where T: ExpressibleByNilLiteral {
	
	init(key: String) {
		self.init(wrappedValue: nil, key: key)
	}
	
}
