import Foundation

public final class MemoryPressureMonitor {
	
	// MARK: - Stored Properties / Tools
	
	private let dispatchSource = DispatchSource.makeMemoryPressureSource(eventMask: .all)
	
	// MARK: - Life Cycle
	
	public init() {
		dispatchSource.setEventHandler { [weak self] in
			guard let self, dispatchSource.isCancelled == false else {
				return
			}
			switch dispatchSource.data {
			case .normal:
				print("MemoryPressureMonitor: Normal")
			case .warning:
				print("MemoryPressureMonitor: Low memory warning")
			case.critical:
				print("MemoryPressureMonitor: Critical memory warning")
			default:
				print("MemoryPressureMonitor: Unknown Event")
			}
		}
	}
	
	deinit {
		dispatchSource.cancel()
	}
	
}

public extension MemoryPressureMonitor {
	
	// MARK: - Controls
	
	func start() {
		dispatchSource.activate()
	}
	
	func stop() {
		dispatchSource.cancel()
	}
	
}
