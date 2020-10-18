import Foundation

public protocol GroupedListSectionProtocol: Equatable {
	
	associatedtype RowModel
	
	var rows: [RowModel] { get }
	
	init(rows: [RowModel])
	
}
