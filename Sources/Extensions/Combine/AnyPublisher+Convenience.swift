import Combine

public extension AnyPublisher where Failure == Error {
	
	init(error: ApplicationError) {
		self.init(
			Fail(error: error).eraseToAnyPublisher()
		)
	}
	
}
