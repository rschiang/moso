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
    
    let statusItem = NSStatusBar.system.statusItem(
        withLength:NSStatusItem.squareLength)

    var count = 1500
    var countBreak = 300
    var status = Status.idle
    var timer: Timer?
    var breakTimer: Timer?

    let menu = NSMenu()
    var taskMenuItem: NSMenuItem?
    var breakMenuItem: NSMenuItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
        constructMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        taskMenuItem = NSMenuItem(title: "Start Task",
                                  action: #selector(AppDelegate.update(_:)),
                                  keyEquivalent: "t")
        breakMenuItem = NSMenuItem(title: "Start Break",
                                   action: #selector(AppDelegate.updateBreak(_:)),
                                   keyEquivalent: "b")

        menu.addItem(taskMenuItem!)
        menu.addItem(breakMenuItem!)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Pomodoro",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))

        statusItem.menu = menu
    }

    func updateMenu() {
        if status == .task {
            taskMenuItem!.title = "Stop Task"
        } else {
            taskMenuItem!.title = "Start Task"
        }

        if status == .recess {
            breakMenuItem!.title = "Stop Break"
        } else {
            breakMenuItem!.title = "Start Break"
        }
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
        updateMenu()
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
        updateMenu()
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
            updateMenu()
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
            updateMenu()
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

