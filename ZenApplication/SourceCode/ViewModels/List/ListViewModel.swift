import Foundation

public struct ListViewModel<ItemModel> {
	
	// MARK: - Subscriptions
	
	public subscript(index: Int) -> ItemModel? {
		items[safe: index]
	}
	
	// MARK: - Computed Properties
	
	public var count: Int {
		items.count
	}
	
	// MARK: - Stored Properties
	
	private let items: [ItemModel]
	
	// MARK: - Life Cycle
	
	public init(items: [ItemModel]) {
		self.items = items
	}
	
}

// MARK: - Equatable

extension ListViewModel: Equatable where ItemModel: Equatable {}

// MARK: - Introspection

public extension ListViewModel {
	
	func firstIndex(
		where predicate: (ItemModel) -> Bool
	) -> Int? {
		items.firstIndex(where: predicate)
	}
	
	func first(
		where predicate: (ItemModel) -> Bool
	) -> ItemModel? {
		items.first(where: predicate)
	}
	
}

// MARK: - Convenience

public extension ListViewModel {
	
	static var empty: Self {
		ListViewModel(items: [])
	}
	
}
