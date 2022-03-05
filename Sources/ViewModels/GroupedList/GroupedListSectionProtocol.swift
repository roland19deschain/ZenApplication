import Foundation

public protocol GroupedListSectionProtocol: Equatable where ItemModel: Equatable {
	associatedtype ItemModel
	var items: [ItemModel] { get }
}
