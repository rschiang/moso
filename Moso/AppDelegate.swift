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

    func applicationWillTerminate(_ notification: Notification) {
        // Clean up all notifications before exit
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent
        notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate
        notification: NSUserNotification) {
        switch notification.activationType {
        case .actionButtonClicked:
            delegate?.notificationActionClicked(notification)
            fallthrough
        case .additionalActionClicked:
            center.removeAllDeliveredNotifications()
        default: break
        }
    }
}

@objc protocol AppNotificationDelegate {
    func notificationActionClicked(_ notification: NSUserNotification)
}
