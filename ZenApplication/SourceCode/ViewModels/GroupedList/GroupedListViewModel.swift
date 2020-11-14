import UIKit

public struct GroupedListViewModel<
	SectionModel: GroupedListSectionProtocol
>: Equatable {
	
	// MARK: - Subscriptions
	
	public subscript(index: Int) -> SectionModel? {
		sections[safe: index]
	}
	
	public subscript(indexPath: IndexPath) -> SectionModel.RowModel? {
		sections[safe: indexPath.section]?.rows[safe: indexPath.row]
	}
	
	// MARK: - Computed Properties
	
	public var sectionsCount: Int {
		sections.count
	}
	
	public var rowsCount: Int {
		sections.reduce(0) {
			$0 + $1.rows.count
		}
	}
	
	// MARK: - Stored Properties
	
	public let sections: [SectionModel]
	
	// MARK: - Life Cycle
	
	public init(sections: [SectionModel]) {
		self.sections = sections
	}
	
}

// MARK: - Introspection

public extension GroupedListViewModel where
	SectionModel: Equatable,
	SectionModel.RowModel: Equatable {
	
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
		of rowModel: SectionModel.RowModel
	) -> IndexPath? {
		for sectionIndex in 0..<sections.count {
			guard
				let rowIndex = sections[sectionIndex].rows.firstIndex(of: rowModel)
			else {
				continue
			}
			return IndexPath(
				row: rowIndex,
				section: sectionIndex
			)
		}
		return nil
	}
	
	func indexPath(
		where predicate: @escaping (SectionModel.RowModel) -> Bool
	) -> IndexPath? {
		for sectionIndex in 0..<sections.count {
			guard
				let rowIndex = sections[sectionIndex].rows.firstIndex(where: predicate)
			else {
				continue
			}
			return IndexPath(
				row: rowIndex,
				section: sectionIndex
			)
		}
		return nil
	}
	
}

// MARK: - Convenience

public extension GroupedListViewModel {
	
	static var empty: Self {
		GroupedListViewModel(sections: [])
	}
	
}
