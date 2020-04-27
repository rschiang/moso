//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by Apostolos Papadopoulos on 4/13/18.
//  MIT, 2018 Apostolos Papadopoulos.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,
                             NSUserNotificationCenterDelegate {

    enum Status {
        case idle
        case task
        case recess
    }

    var count = 0
    var status = Status.idle
    var timer: Timer?
    var view: AppView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        view = AppView()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        view = nil
    }

    @objc func update(_ sender: Any?) {
        if status != .task {
            schedule(status: .task, count: 1500)
        } else {
            reset()
        }
        view?.update(status, count: count)
    }

    @objc func updateBreak(_ sender: Any?) {
        if status != .recess {
            schedule(status: .recess, count: 300)
        } else {
            reset()
        }
        view?.update(status, count: count)
    }

    func schedule(status: Status, count: Int) {
        timer?.invalidate()
        self.status = status
        self.count = count
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(runTimedCode),
                                     userInfo: nil,
                                     repeats: true)
    }

    func reset() {
        timer?.invalidate()
        status = .idle
        count = 0
    }

    @objc func runTimedCode() {
        if (count > 0) {
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            let countDownLabel = minutes + ":" + seconds
            count -= 1
            print(countDownLabel)
        } else {
            view?.showNotification(status)
            reset()
        }
        view?.update(status, count: count)
    }
}
