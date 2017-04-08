//
//  AppDelegate.swift
//  Messenger-iOS
//
//  Created by Jens Meder on 05.04.17.
//
//

import UIKit
import DarkLightning

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var port: DarkLightning.Port?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        port = DevicePort(delegate: AutoConnectDelegate())
        port?.open()
        return true
    }


}

