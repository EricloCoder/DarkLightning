//
//  Device.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

public protocol Device: class {
	func connect()
	func disconnect()
	func writeData(data: Data)
}

public final class DeviceFake: Device {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Device
    
	public func connect() {
		
	}
	
	public func disconnect() {
		
	}
	
	public func writeData(data: Data) {
		
	}
}
