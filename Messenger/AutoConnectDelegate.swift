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
    
    public func device(didConnect device: Device) {
        device.writeData(data: "Yeehaa".data(using: .utf8)!)
    }
    
    public func device(didDisconnect device: Device) {
        
    }
	
	func device(_ device: Device, didReceiveData data: OOData) {
        print(String(data: data.rawValue, encoding: .utf8)!)
        device.writeData(data: "Foo".data(using: .utf8)!)
        //device.disconnect()
	}
}
