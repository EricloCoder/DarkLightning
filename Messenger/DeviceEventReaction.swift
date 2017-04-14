//
//  DeviceEventReaction.swift
//  DarkLightning
//
//  Created by Jens Meder on 14.04.17.
//
//

import Foundation
import DarkLightning

internal final class DeviceEventReaction: DeviceDelegate {

	// MARK: Init
    
    internal init() {
        
    }
    
    // MARK: DeviceDelegate
    
    public func device(didConnect device: Device) {
        device.writeData(data: "Yeehaa".data(using: .utf8)!)
    }
    
    func device(didFailToConnect device: Device) {
        
    }
    
    public func device(didDisconnect device: Device) {
        
    }
    
    func device(_ device: Device, didReceiveData data: OOData) {
        print(String(data: data.rawValue, encoding: .utf8)!)
        device.writeData(data: "Foo".data(using: .utf8)!)
        device.disconnect()
    }
}
