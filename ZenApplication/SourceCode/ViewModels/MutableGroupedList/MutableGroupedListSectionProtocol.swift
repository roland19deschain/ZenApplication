import Foundation

public protocol MutableGroupedListSectionProtocol: Equatable {
	associatedtype RowModel
	
	var rows: [RowModel] { get }
	
	func replace(
		rowModel: RowModel,
		with newRowModel: RowModel
	)
	
}
