//
//  IRequestProcessorMock.swift
//  gitHubUsersTests
//
//  Created by Veronika Goreva on 11.06.2022.
//

@testable import gitHubUsers

final class IRequestProcessorMock: IRequestProcessor {

    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (request: IRequest, parser: Any)?
    var invokedExecuteParametersList = [(request: IRequest, parser: Any)]()
    var stubbedExecuteCompletionResult: (Result<(Any, ResponseHeaders), Swift.Error>, Void)?
    var stubbedExecuteResult: Cancellable!

    func execute<Model>(
        request: IRequest,
        parser: AnyParser<Model>,
        completion: @escaping (Result<(Model, ResponseHeaders), Swift.Error>) -> Void
    ) -> Cancellable? {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (request, parser)
        invokedExecuteParametersList.append((request, parser))
        if let result = stubbedExecuteCompletionResult {
            if case let .success((anyModel, header)) = result.0,
               let model = anyModel as? Model {
                completion(.success((model, header)))
            }
            if case let .failure(error) = result.0 {
                completion(.failure(error))
            }
        }
        return stubbedExecuteResult
    }
}
