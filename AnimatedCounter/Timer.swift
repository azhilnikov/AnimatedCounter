//
//  Timer.swift
//  AnimatedCounter
//
//  Created by Alexey on 3/06/2016.
//  Copyright © 2016 Alexey Zhilnikov. All rights reserved.
//

import Foundation

protocol TimerDelegate {
    func didTimerTimeOut()
}

class Timer {
    
    var delegate: TimerDelegate?
    private weak var timer: NSTimer?
    
    // MARK: - Public methods
    
    func start(interval: NSTimeInterval) {
        // Repeatedly reschedule timer for 'interval' seconds until invalidated
        timer = NSTimer.scheduledTimerWithTimeInterval(interval,
                                                       target: self,
                                                       selector: #selector(timeOut),
                                                       userInfo: nil,
                                                       repeats: true)
    }
    
    func stop() {
        // Stop timer
        timer?.invalidate()
        timer = nil
    }
    
    func updateInterval(interval: NSTimeInterval) {
        stop()
        start(interval)
    }
    
    // MARK: - Private methods
    
    @objc private func timeOut() {
        // Call delegate
        delegate?.didTimerTimeOut()
    }
}
