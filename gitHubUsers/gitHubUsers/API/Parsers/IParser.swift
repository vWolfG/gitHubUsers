//
//  IParser.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 08.05.2022.
//

import Foundation

protocol IParser: AnyObject {
    
    associatedtype Model
    func parse(_ data: Data) throws -> Model
}
