import UIKit

public struct GroupedListViewModel<
	RowModel,
	SectionModel: GroupedListSectionProtocol
>: Equatable where SectionModel.RowModel == RowModel {
	
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

// MARK: - Introspection

public extension GroupedListViewModel where RowModel: Equatable, SectionModel: Equatable {
	
	func index(
		of sectionModel: SectionModel
	) -> Int? {
		sections.firstIndex(of: sectionModel)
	}
	
	func index(
		where predicate: (SectionModel) -> Bool
	) -> Int? {
		sections.firstIndex(where: predicate)
	}
	
	func indexPath(
		of rowModel: RowModel
	) -> IndexPath? {
		sections.lazy.compactMap { sectionModel -> IndexPath? in
			guard
				let rowIndex = sectionModel.rows.firstIndex(of: rowModel),
				let sectionIndex = self.index(of: sectionModel)
			else {
				return nil
			}
			return IndexPath(row: rowIndex, section: sectionIndex)
		}.first
	}
	
	func indexPath(
		where predicate: @escaping (RowModel) -> Bool
	) -> IndexPath? {
		sections.lazy.compactMap { sectionModel -> IndexPath? in
			guard
				let rowIndex = sectionModel.rows.firstIndex(where: predicate),
				let sectionIndex = self.index(of: sectionModel)
			else {
				return nil
			}
			return IndexPath(row: rowIndex, section: sectionIndex)
		}.first
	}
	
}

// MARK: - Convenience

public extension GroupedListViewModel {
	
	static var empty: Self {
		GroupedListViewModel(sections: [])
	}
	
}
