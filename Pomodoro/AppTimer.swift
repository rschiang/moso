//
//  AppTimer.swift
//  Pomodoro
//
//  Created by Poren Chiang on 2020/4/27.
//  Copyright © 2020 Apostolos Papadopoulos. All rights reserved.
//

import Foundation

class AppTimer : NSObject {

    var timer: Timer?
    var status = AppStatus.idle
    var count = 0

    @IBOutlet weak var delegate: AppTimerDelegate?

    func schedule(status: AppStatus, count: Int) {
        timer?.invalidate()
        self.status = status
        self.count = count
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
    }

    func reset() {
        timer?.invalidate()
        status = .idle
        count = 0
    }

    @objc func tick() {
        if (count > 0) {
            count -= 1
        } else {
            delegate?.timerInvalidated(self)
            reset()
        }
        delegate?.timerDidUpdate(self)
    }
}

@objc protocol AppTimerDelegate {
    func timerDidUpdate(_ sender: AppTimer?)
    func timerInvalidated(_ sender: AppTimer?)
}

@objc enum AppStatus: Int {
    case idle
    case task
    case recess
}
