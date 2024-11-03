import Combine

public extension AnyPublisher where Failure == ApplicationError {
	
	init(error: ApplicationError) {
		self.init(
			Fail(error: error).eraseToAnyPublisher()
		)
	}
	
}
