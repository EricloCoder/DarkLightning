//
//  AutoConnectDelegate.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation
import DarkLightning

internal final class AutoConnectDelegate: DevicesDelegate {
    private var devices: [Device]
    
	// MARK: Init
    
    internal convenience init() {
        self.init(devices: [])
    }
    
    internal required init(devices: [Device]) {
        self.devices = devices
    }
    
    // MARK: DeviceDelegate
    
    func device(didAttach device: Device) {
        devices.append(device)
        device.connect()
    }
    
    func device(didDetach device: Device) {
        
    }
}
