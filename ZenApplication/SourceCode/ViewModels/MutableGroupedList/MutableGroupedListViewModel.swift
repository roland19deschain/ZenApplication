import UIKit

public struct MutableGroupedListViewModel<
	RowModel: Equatable,
	SectionModel: MutableGroupedListSectionProtocol
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
		guard let sectionModel = sections.first(where: {
			$0.rows.contains(rowModel)
		}) else {
			return
		}
		sectionModel.replace(
			rowModel: rowModel,
			with: newRowModel
		)
	}
	
	mutating func insert(
		_ section: SectionModel,
		at index: Int
	) {
		sections.insert(section, at: index)
	}
	
	mutating func append(_ section: SectionModel) {
		sections.append(section)
	}
	
	mutating func remove(_ section: SectionModel) {
		sections.remove(section)
	}
	
	mutating func remove(_ sections: [SectionModel]) {
		self.sections.remove(sections)
	}
	
}

// MARK: - Convenience

public extension MutableGroupedListViewModel {
	
	static var empty: Self {
		MutableGroupedListViewModel(sections: [])
	}
	
}
