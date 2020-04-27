//
//  AppView.swift
//  Pomodoro
//
//  Created by Poren Chiang on 2020/4/27.
//  Copyright © 2020 Apostolos Papadopoulos. All rights reserved.
//

import Cocoa
import Foundation

class AppView: NSObject {

    let statusItem: NSStatusItem
    let menu: NSMenu
    let statMenuItem, statSeparatorItem: NSMenuItem
    let taskMenuItem, breakMenuItem: NSMenuItem

    override init() {
        statusItem = NSStatusBar.system.statusItem(
                                        withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(named:
                                   NSImage.Name("StatusBarButtonImage"))
        statusItem.isVisible = true
        if #available(OSX 10.12, *) {
            statusItem.behavior = NSStatusItem.Behavior.terminationOnRemoval
        }

        menu = NSMenu()

        statMenuItem = NSMenuItem(title: "Idle", action: nil, keyEquivalent: "")
        statMenuItem.isHidden = true

        statSeparatorItem = NSMenuItem.separator()
        statSeparatorItem.isHidden = true

        taskMenuItem = NSMenuItem(title: "Start Task",
                                  action: #selector(AppDelegate.update(_:)),
                                  keyEquivalent: "t")
        breakMenuItem = NSMenuItem(title: "Start Break",
                                   action: #selector(AppDelegate.updateBreak(_:)),
                                   keyEquivalent: "b")

        menu.addItem(statMenuItem)
        menu.addItem(statSeparatorItem)
        menu.addItem(taskMenuItem)
        menu.addItem(breakMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Pomodoro",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))
        statusItem.menu = menu

        super.init()
    }

    func update(_ status: AppDelegate.Status, count: Int) {
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
        notification.title = "Pomodoro"
        notification.informativeText = content
        notification.soundName = NSUserNotificationDefaultSoundName

        NSUserNotificationCenter.default.deliver(notification)
    }

    func showNotification(_ status: AppDelegate.Status) {
        switch status {
        case .task:
            showNotification(content: "Your task is over. Time for a break!")
        case .recess:
            showNotification(content: "Your break is over. Time for a new task!")
        default: break
        }
    }
}
