import Foundation

public struct ExecutionTimeAuditor {
	
	// MARK: - Life Cycle
	
	public init() {}
	
}

// MARK: - Controls

public extension ExecutionTimeAuditor {
	
	@discardableResult func evaluate(
		iterations: Int = 1,
		reducePrinting: Bool = true,
		of closure: () -> Void
	) -> TimeInterval
	{
		var average: Double = 0.0
		for _ in 0..<iterations {
			average += evaluate(
				closure,
				reducePrinting: reducePrinting
			)
		}
		average /= TimeInterval(iterations)
		if !reducePrinting {
			print("Average execution took \(String(format: "%.10f", average)) seconds")
		}
		return average
	}
	
}

// MARK: - Evaluate

private extension ExecutionTimeAuditor {
	
	private func evaluate(
		_ closure: () -> Void,
		reducePrinting: Bool
		) -> TimeInterval
	{
		let start = Date()
		closure()
		let executionTime = Date().timeIntervalSince(start)
		if !reducePrinting {
			print("Execution took \(String(format: "%.10f", executionTime)) seconds)")
		}
		return executionTime
	}
	
}
