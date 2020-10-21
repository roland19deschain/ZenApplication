import Foundation

public protocol GroupedListSectionProtocol: Equatable where RowModel: Equatable {
	
	associatedtype RowModel
	
	var rows: [RowModel] { get }
	
}
