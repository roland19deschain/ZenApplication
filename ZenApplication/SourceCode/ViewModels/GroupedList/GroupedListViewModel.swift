import UIKit

public struct GroupedListViewModel<
	SectionModel: GroupedListSectionProtocol
>: Equatable {
	
	// MARK: - Subscriptions
	
	public subscript(index: Int) -> SectionModel? {
		sections[safe: index]
	}
	
	public subscript(indexPath: IndexPath) -> SectionModel.ItemModel? {
		sections[safe: indexPath.section]?.items[safe: indexPath.item]
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
	
	public let sections: [SectionModel]
	
	// MARK: - Life Cycle
	
	public init(sections: [SectionModel]) {
		self.sections = sections
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
			return IndexPath(
				item: itemIndex,
				section: sectionIndex
			)
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
			return IndexPath(
				item: itemIndex,
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
