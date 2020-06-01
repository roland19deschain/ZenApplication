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
	
	private let rows: [RowModel]
	
	// MARK: - Life Cycle
	
	public init(rows: [RowModel]) {
		self.rows = rows
	}
	
}

// MARK: - Convenience

public extension ListViewModel {
	
	static var empty: Self {
		ListViewModel(rows: [])
	}
	
}
