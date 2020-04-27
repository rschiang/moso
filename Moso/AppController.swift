//
//  AppView.swift
//  Moso
//
//  Copyright © 2020 Poren Chiang et al.
//  Released under MIT License; refer to project LICENSE for details.
//

import Cocoa
import Foundation

class AppController: NSObject, AppTimerDelegate {

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
            timer.schedule(status: .task, count: 1500)
        } else {
            timer.reset()
        }
        update()
    }

    @IBAction func breakClicked(sender: NSMenuItem) {
        if timer.status != .recess {
            timer.schedule(status: .recess, count: 300)
        } else {
            timer.reset()
        }
        update()
    }

    func timerDidUpdate(_ sender: AppTimer?) {
        update()
    }

    func timerInvalidated(_ sender: AppTimer?) {
        switch sender!.status {
        case .task:
            showNotification(content: "Your task is over. Time for a break!")
        case .recess:
            showNotification(content: "Your break is over. Time for a new task!")
        default: break
        }
    }

    func update() {
        let status = timer.status, count = timer.count

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

    func showNotification(content: String) {
        let notification = NSUserNotification()
        let nuuid = UUID().uuidString

        notification.identifier = nuuid
        notification.title = "Moso"
        notification.informativeText = content
        notification.soundName = "Glass"

        NSUserNotificationCenter.default.deliver(notification)
    }
}
