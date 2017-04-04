//
//  DevicesDelegate.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

public protocol DevicesDelegate: class {
	func device(didAttach device: Device)
	func device(didDetach device: Device)
}

public final class DevicesDelegateFake: DevicesDelegate {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - DevicesDelegate
    
	public func device(didAttach device: Device) {
		print(device)
	}
	
	public func device(didDetach device: Device) {
		
	}
}
