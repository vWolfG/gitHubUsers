//
//  AnyParser.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import Foundation

class AnyParser<Model>: IParser {
    
    // Properties
    private let _parse: (Data) throws -> Model
    
    // MARK: - Init

    init<Parser: IParser>(parser: Parser) where Parser.Model == Model {
        _parse = parser.parse
    }
    
    // MARK: - IParser

    func parse(_ data: Data) throws -> Model {
        try _parse(data)
    }
}

extension IParser {
    
    func typeErased() -> AnyParser<Model> {
        AnyParser<Model>(parser: self)
    }
}
