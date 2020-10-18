import UIKit

public struct MutableGroupedListViewModel<
	RowModel: Equatable,
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
	
	private var sections: [SectionModel]
	
	// MARK: - Life Cycle
	
	public init(sections: [SectionModel]) {
		self.sections = sections
	}
	
}

// MARK: - Equatable

extension MutableGroupedListViewModel: Equatable {}

// MARK: - Introspection

public extension MutableGroupedListViewModel {
	
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
			guard let rowIndex = sectionModel.rows.firstIndex(of: rowModel),
				let sectionIndex = self.index(of: sectionModel) else {
					return nil
			}
			return IndexPath(row: rowIndex, section: sectionIndex)
		}.first
	}
	
	func indexPath(
		where predicate: @escaping (RowModel) -> Bool
	) -> IndexPath? {
		sections.lazy.compactMap { sectionModel -> IndexPath? in
			guard let rowIndex = sectionModel.rows.firstIndex(where: predicate),
				let sectionIndex = self.index(of: sectionModel) else {
					return nil
			}
			return IndexPath(row: rowIndex, section: sectionIndex)
		}.first
	}
	
}

// MARK: - Mutating

public extension MutableGroupedListViewModel {
	
	mutating func replace(
		rowModel: RowModel,
		with newRowModel: RowModel
	) {
		guard let indexPath = indexPath(of: rowModel) else {
			return
		}
		var sectionRows = sections[indexPath.section].rows
		sectionRows[indexPath.row] = newRowModel
		
		sections[indexPath.section] = SectionModel(rows: sectionRows)
	}
	
}

// MARK: - Convenience

public extension MutableGroupedListViewModel {
	
	static var empty: Self {
		MutableGroupedListViewModel(sections: [])
	}
	
}
