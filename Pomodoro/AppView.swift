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
    let taskMenuItem, breakMenuItem: NSMenuItem

    override init() {
        statusItem = NSStatusBar.system.statusItem(
                                        withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(named:
                                   NSImage.Name("StatusBarButtonImage"))

        menu = NSMenu()

        taskMenuItem = NSMenuItem(title: "Start Task",
                                  action: #selector(AppDelegate.update(_:)),
                                  keyEquivalent: "t")
        breakMenuItem = NSMenuItem(title: "Start Break",
                                   action: #selector(AppDelegate.updateBreak(_:)),
                                   keyEquivalent: "b")

        menu.addItem(taskMenuItem)
        menu.addItem(breakMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Pomodoro",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))
        statusItem.menu = menu

        super.init()
    }

    func update(status: AppDelegate.Status) {
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
