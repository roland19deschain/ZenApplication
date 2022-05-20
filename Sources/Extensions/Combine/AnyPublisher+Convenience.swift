import Combine

public extension AnyPublisher where Failure == Error {
	
	static var operationCanceled: AnyPublisher<Output, Error> {
		Fail(
			error: ApplicationError.operationCanceled
		).eraseToAnyPublisher()
	}
	
}

