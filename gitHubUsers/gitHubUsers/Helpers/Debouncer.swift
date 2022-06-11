//
//  Debouncer.swift
//  gitHubUsers
//
//  Created by Veronika Goreva on 16.05.2022.
//

import Foundation
import Dispatch

protocol IDebouncer: AnyObject {
    
    func debounce(_ block: @escaping () -> Void)
}

/// Debouncer implementation based on a dispatch queue.
class Debouncer: IDebouncer {
    
    // Properties
    private var workItem: DispatchWorkItem?
    private let timeInterval: DispatchTimeInterval
    private let queue: IDispatchQueue
    
    // MARK: - Init

    init(
        timeInterval: DispatchTimeInterval,
        queue: IDispatchQueue = DispatchQueue.main
    ) {
        self.timeInterval = timeInterval
        self.queue = queue
    }

    func debounce(_ block: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem {
            block()
        }
        queue.executeAsyncAfter(deadline: .now() + timeInterval, work: workItem!)
    }
}
