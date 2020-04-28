//
//  AppTimer.swift
//  Moso
//
//  Copyright © 2020 Poren Chiang et al.
//  Released under MIT License; refer to project LICENSE for details.
//

import Foundation

class AppTimer : NSObject {

    var timer: Timer?
    var status = AppStatus.idle
    var target = Date.distantPast

    static let taskInterval = 1500
    static let breakInterval = 300
    var count : Int {
        let count = target.timeIntervalSinceNow
        return count > 0 ? Int(count.rounded(.up)) : 0
    }

    @IBOutlet weak var delegate: AppTimerDelegate?

    func schedule(status: AppStatus, count: Int) {
        timer?.invalidate()
        self.status = status
        self.target = Date(timeIntervalSinceNow: TimeInterval(count))
        timer = Timer(timeInterval: 1, target: self, selector: #selector(tick),
                      userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .eventTracking)
    }

    func reset() {
        timer?.invalidate()
        status = .idle
        target = .distantPast
    }

    @objc func tick() {
        if (count <= 0) {
            delegate?.timerInvalidated(self)
            reset()
        }
        delegate?.timerDidUpdate(self)
    }
}

@objc protocol AppTimerDelegate {
    func timerDidUpdate(_ sender: AppTimer)
    func timerInvalidated(_ sender: AppTimer)
}

@objc enum AppStatus: Int {
    case idle
    case task
    case recess
}
