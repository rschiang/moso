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

    var count = 1500
    var countBreak = 300
    var status = Status.idle
    var timer: Timer?
    var breakTimer: Timer?

    var view: AppView?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        view = AppView()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        view = nil
    }

    @objc func update(_ sender: Any?) {
        if status != .task {
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(runTimedCode),
                                         userInfo: nil,
                                         repeats: true)
            breakTimer?.invalidate()
            status = .task
        } else {
            reset()
        }
        view?.update(status: status)
    }

    @objc func updateBreak(_ sender: Any?) {
        if status != .recess {
            breakTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(runBreakCode),
                                              userInfo: nil,
                                              repeats: true)
            timer?.invalidate()
            status = .recess
        } else {
            reset()
        }
        view?.update(status: status)
    }

    func reset() {
        timer?.invalidate()
        breakTimer?.invalidate()
        status = .idle
        count = 1500
        countBreak = 300
    }

    @objc func runTimedCode() {
        if (count > 0) {
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            let countDownLabel = minutes + ":" + seconds
            count -= 1
            print(countDownLabel)
        } else {
            showNotification(content: "Your task is over. Time for a break!")
            reset()
            view?.update(status: status)
        }
    }

    @objc func runBreakCode() {
        if (countBreak > 0) {
            let minutes = String(countBreak / 60)
            let seconds = String(countBreak % 60)
            let countDownLabel = minutes + ":" + seconds
            countBreak -= 1
            print(countDownLabel)
        } else {
            showNotification(content: "Your break is over. Time for a new task!")
            reset()
            view?.update(status: status)
        }
    }

    func showNotification(content: String) -> Void {
        let notification = NSUserNotification()
        let nuuid = UUID().uuidString

        notification.identifier = nuuid
        notification.title = "Pomodoro"
        notification.informativeText = content
        notification.soundName = NSUserNotificationDefaultSoundName

        _ = NSUserNotificationCenter.default.deliver(notification)
    }
}
