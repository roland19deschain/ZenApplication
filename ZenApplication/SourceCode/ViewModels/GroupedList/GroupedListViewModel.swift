import Foundation

public struct GroupedListViewModel<
	SectionModel: GroupedListSectionProtocol
>: Equatable {
	
	// MARK: - Subscriptions
	
	public subscript(index: Int) -> SectionModel? {
		sections[safe: index]
	}
	
	public subscript(indexPath: IndexPath) -> SectionModel.ItemModel? {
		guard
			let section = indexPath.first,
			let item = indexPath.last
		else {
			return nil
		}
		return sections[safe: section]?.items[safe: item]
	}
	
	// MARK: - Computed Properties
	
	public var sectionsCount: Int {
		sections.count
	}
	
	public var itemsCount: Int {
		sections.reduce(0) {
			$0 + $1.items.count
		}
	}
	
	// MARK: - Stored Properties
	
	private let sections: [SectionModel]
	
	// MARK: - Life Cycle
	
	public init(sections: [SectionModel]) {
		self.sections = sections
	}
	
	public init(
		primaryModel: Self,mapper
		builder: ([SectionModel]) -> [SectionModel]
	) {
		self.sections = builder(primaryModel.sections)
	}
	
}

// MARK: - Introspection

public extension GroupedListViewModel where
	SectionModel: Equatable,
	SectionModel.ItemModel: Equatable {
	
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
		of itemModel: SectionModel.ItemModel
	) -> IndexPath? {
		for sectionIndex in 0..<sections.count {
			guard
				let itemIndex = sections[sectionIndex].items.firstIndex(of: itemModel)
			else {
				continue
			}
			return [sectionIndex, itemIndex]
		}
		return nil
	}
	
	func indexPath(
		where predicate: @escaping (SectionModel.ItemModel) -> Bool
	) -> IndexPath? {
		for sectionIndex in 0..<sections.count {
			guard
				let itemIndex = sections[sectionIndex].items.firstIndex(where: predicate)
			else {
				continue
			}
			return [sectionIndex, itemIndex]
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
