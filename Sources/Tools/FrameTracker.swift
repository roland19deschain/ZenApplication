#if !os(OSX)
import Foundation
import UIKit

public final class FrameTracker {
	
	// MARK: - Computed Properties
	
	private var timePerFrame: TimeInterval {
		1 / preferredFramesPerSecond * 1_000
	}
	
	// MARK: - Stored Properties / Values
	
	private let preferredFramesPerSecond: Double
	private var firstCheckTime: TimeInterval = 0
	private var lastCheckTime: TimeInterval = 0
	
	// MARK: - Stored Properties / Tools
	
	private lazy var link = CADisplayLink(
		target: self,
		selector: #selector(update(link:))
	)
	
	// MARK: - Life Cycle
	
	public init() {
		preferredFramesPerSecond = Double(UIScreen.main.maximumFramesPerSecond)
	}
	
}

// MARK: - Controls

public extension FrameTracker {
	
	func start() {
		link.add(
			to: .main,
			forMode: .common
		)
	}
	
	func stop() {
		link.invalidate()
		firstCheckTime = 0
		lastCheckTime = 0
	}
	
}

// MARK: - Update

private extension FrameTracker {
	
	@objc func update(link: CADisplayLink) {
		if lastCheckTime == 0 {
			firstCheckTime = link.timestamp
			lastCheckTime = link.timestamp
		}
		let currentTime = link.timestamp
		let elapsedTime = floor((currentTime - lastCheckTime) * 10_000) / 10
		let totalElapsedTime = currentTime - firstCheckTime
		
		if elapsedTime > timePerFrame {
			let delta = elapsedTime - timePerFrame
			print("Frame(s) was dropped with elapsed time of \(elapsedTime) at \(totalElapsedTime), delta: \(delta), duration: \(link.duration)")
		}
		lastCheckTime = link.timestamp
	}
	
}
#endif
