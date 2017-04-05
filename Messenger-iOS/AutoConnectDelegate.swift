//
//  AutoConnectDelegate.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation
import DarkLightning

internal final class AutoConnectDelegate: DarkLightning.PortDelegate {

	// MARK: Init
    
    internal init() {
        
    }
    
    // MARK: DevicePortDelegate
    
    public func port(didConnect port: DarkLightning.Port) {
        let hello = "Hello World".data(using: .utf8)!
        port.write(data: hello)
    }
    
    public func port(didDisconnect port: DarkLightning.Port) {
        
    }
    
    public func port(port: DarkLightning.Port, didReceiveData data: OOData) {
        
    }
}
