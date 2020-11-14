import Foundation

public struct ListViewModel<RowModel> {
	
	// MARK: - Subscriptions
	
	public subscript(index: Int) -> RowModel? {
		rows[safe: index]
	}
	
	// MARK: - Computed Properties
	
	public var count: Int {
		rows.count
	}
	
	// MARK: - Stored Properties
	
	public let rows: [RowModel]
	
	// MARK: - Life Cycle
	
	public init(rows: [RowModel]) {
		self.rows = rows
	}
	
}

// MARK: - Equatable

extension ListViewModel: Equatable where RowModel: Equatable {}

// MARK: - Introspection

public extension ListViewModel {
	
	func firstIndex(
		where predicate: (RowModel) -> Bool
	) -> Int? {
		rows.firstIndex(where: predicate)
	}
	
	func first(
		where predicate: (RowModel) -> Bool
	) -> RowModel? {
		rows.first(where: predicate)
	}
	
}

// MARK: - Convenience

public extension ListViewModel {
	
	static var empty: Self {
		ListViewModel(rows: [])
	}
	
}
