//
//  AttachReaction.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation
import DarkLightning

internal final class AttachReaction: DaemonDelegate {
    private var devices: [Device]
    
	// MARK: Init
    
    internal convenience init() {
        self.init(devices: [])
    }
    
    internal required init(devices: [Device]) {
        self.devices = devices
    }
    
    // MARK: DeviceDelegate
    
    func daemon(_ daemon: Daemon, didAttach device: Device) {
        //devices.append(device)
        //device.connect()
        print("Attach: ")
    }
    
    func daemon(_ daemon: Daemon, didDetach device: Device) {
        print("Detach: ")
        daemon.stop()
        daemon.start()
    }
}