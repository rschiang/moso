//
//  AppDelegate.swift
//  Moso
//
//  Copyright © 2020 Poren Chiang et al.
//  Released under MIT License; refer to project LICENSE for details.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,
                             NSUserNotificationCenterDelegate {

    @IBOutlet weak var delegate: AppNotificationDelegate?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent
        notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate
        notification: NSUserNotification) {
        if notification.activationType == .actionButtonClicked {
            delegate?.notificationActionClicked(notification)
        }
        center.removeAllDeliveredNotifications()
    }
}

@objc protocol AppNotificationDelegate {
    func notificationActionClicked(_ notification: NSUserNotification)
}
