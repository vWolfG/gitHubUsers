//
//  IDispatchQueue.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 10.05.2022.
//

import Foundation

protocol IDispatchQueue: AnyObject {
    
    func executeAsync(block: @escaping () -> Void)
    func executeAsyncAfter(deadline: DispatchTime, work: DispatchWorkItem)
}

extension DispatchQueue: IDispatchQueue {

    func executeAsync(block: @escaping () -> Void) {
        async {
            block()
        }
    }
    
    func executeAsyncAfter(
        deadline: DispatchTime,
        work: DispatchWorkItem
    ) {
        asyncAfter(deadline: deadline, execute: work)
    }
}


protocol IDispatchQueueFactory: AnyObject {
    
    func mainQueue() -> IDispatchQueue
}
