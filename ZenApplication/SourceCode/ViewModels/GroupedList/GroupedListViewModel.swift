import UIKit

public struct GroupedListViewModel<
	RowModel,
	SectionModel: GroupedListSectionProtocol
> where SectionModel.RowModel == RowModel {
	
	// MARK: - Subscriptions
	
	public subscript(index: Int) -> SectionModel? {
		sections[safe: index]
	}
	
	public subscript(indexPath: IndexPath) -> RowModel? {
		sections[safe: indexPath.section]?
			.rows[safe: indexPath.row]
	}
	
	// MARK: - Computed Properties
	
	public var sectionsCount: Int {
		sections.count
	}
	
	public var rowsCount: Int {
		sections.map {
			$0.rows.count
		}.reduce(0, +)
	}
	
	// MARK: - Stored Properties
	
	private let sections: [SectionModel]
	
	// MARK: - Life Cycle
	
	public init(sections: [SectionModel]) {
		self.sections = sections
	}
	
}

// MARK: - Convenience

public extension GroupedListViewModel {
	
	static var empty: Self {
		GroupedListViewModel(sections: [])
	}
	
}
