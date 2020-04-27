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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
