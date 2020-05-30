import Foundation

public protocol GroupedListSectionProtocol {
	associatedtype RowModel
	
	var rows: [RowModel] { get }
}
