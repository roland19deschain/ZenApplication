import Foundation
import ZenSwift

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
	
	public var isEmpty: Bool {
		sections.isEmpty
	}
	
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
		primaryModel: Self,
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

// MARK: - Sequence

extension GroupedListViewModel: Sequence {
	
	public func makeIterator() -> AnyIterator<SectionModel> {
		var iterator = sections.makeIterator()
		return AnyIterator {
			iterator.next()
		}
	}
	
}

// MARK: - ExpressibleByArrayLiteral

extension GroupedListViewModel: ExpressibleByArrayLiteral {
	
	public init(arrayLiteral elements: SectionModel...) {
		self.init(sections: elements)
	}
	
}

// MARK: - Convenience

public extension GroupedListViewModel {
	
	static var empty: Self {
		GroupedListViewModel(sections: [])
	}
	
}
