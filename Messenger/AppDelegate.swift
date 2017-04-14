//
//  AppDelegate.swift
//  Messenger
//
//  Created by Jens Meder on 02/04/17.
//
//

import Cocoa
import DarkLightning

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!
	var daemon: Daemon?


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
        daemon = USBDaemon(delegate: AttachReaction(), deviceDelegate: DeviceEventReaction())
		daemon?.start()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

