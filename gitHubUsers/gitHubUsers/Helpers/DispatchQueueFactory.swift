//
//  DispatchQueueFactory.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 10.05.2022.
//

import Foundation

final class DispatchQueueFactory: IDispatchQueueFactory {
    
    func mainQueue() -> IDispatchQueue {
        DispatchQueue.main
    }
}
