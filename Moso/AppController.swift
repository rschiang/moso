//
//  AppView.swift
//  Moso
//
//  Copyright © 2020 Poren Chiang et al.
//  Released under MIT License; refer to project LICENSE for details.
//

import Cocoa
import Foundation

class AppController: NSObject, AppTimerDelegate, AppNotificationDelegate {

    var statusItem: NSStatusItem!
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var statMenuItem: NSMenuItem!
    @IBOutlet weak var statSeparatorItem: NSMenuItem!
    @IBOutlet weak var taskMenuItem: NSMenuItem!
    @IBOutlet weak var breakMenuItem: NSMenuItem!
    @IBOutlet weak var timer: AppTimer!

    override func awakeFromNib() {
        statusItem = NSStatusBar.system.statusItem(
                                        withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(named: "StatusBarButtonImage")
        statusItem.isVisible = true
        if #available(OSX 10.12, *) {
            statusItem.behavior = NSStatusItem.Behavior.terminationOnRemoval
        }
        statusItem.menu = menu
    }

    @IBAction func taskClicked(sender: NSMenuItem) {
        if timer.status != .task {
            timer.schedule(status: .task, count: AppTimer.taskInterval)
        } else {
            timer.reset()
        }
        update()
    }

    @IBAction func breakClicked(sender: NSMenuItem) {
        if timer.status != .recess {
            timer.schedule(status: .recess, count: AppTimer.breakInterval)
        } else {
            timer.reset()
        }
        update()
    }

    func timerDidUpdate(_ sender: AppTimer) {
        update()
    }

    func timerInvalidated(_ sender: AppTimer) {
        let notification = NSUserNotification()
        let nuuid = UUID().uuidString
        let time = DateFormatter.localizedString(from: sender.target,
                                                 dateStyle: .none,
                                                 timeStyle: .short)
        switch sender.status {
        case .task:
            let mindfulness = [
                "Do some stretches!", "Get some fresh air!",
                "Take a deep breath!", "Better stay hydrated!"
                ].randomElement()!

            notification.title = mindfulness
            notification.informativeText = String(format:
                "Task is over at %@. Time for a break!", time)
        case .recess:
            notification.title = "Get prepared!"
            notification.informativeText = String(format:
                "Break is over at %@. Time for a task!", time)
        default: break
        }

        notification.actionButtonTitle = "Start"
        notification.otherButtonTitle = "Dismiss"
        notification.userInfo = ["type": sender.status.rawValue]
        notification.identifier = nuuid
        notification.soundName = "Glass"

        NSUserNotificationCenter.default.deliver(notification)
    }

    func notificationActionClicked(_ notification: NSUserNotification) {
        if let type = notification.userInfo?["type"] as? Int {
            switch AppStatus(rawValue: type) {
            case .task:
                timer.schedule(status: .recess, count: AppTimer.breakInterval)
            case .recess:
                timer.schedule(status: .task, count: AppTimer.taskInterval)
            default: break
            }
        }
    }

    func update() {
        let status = timer.status
        let count = timer.count

        if count > 0 {
            statMenuItem.title = String(format: "%02d:%02d %@",
                                        count / 60, count % 60,
                                        status == .task ? "Task" : "Break")
        } else {
            statMenuItem.title = "Idle"
        }

        statMenuItem.isHidden = (status == .idle)
        statSeparatorItem.isHidden = (status == .idle)

        if status == .task {
            taskMenuItem.title = "Stop Task"
        } else {
            taskMenuItem.title = "Start Task"
        }

        if status == .recess {
            breakMenuItem.title = "Stop Break"
        } else {
            breakMenuItem.title = "Start Break"
        }
    }
}
