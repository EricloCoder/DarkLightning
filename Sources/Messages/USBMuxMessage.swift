//
//  USBMuxMessage.swift
//  DarkLightning
//
//  Created by Jens Meder on 22/03/17.
//
//

import Foundation

internal protocol USBMuxMessage: class {
	func decode()
}

internal final class USBMuxMessageFake: USBMuxMessage {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - USBMuxMessage
    
	func decode() {
		
	}
}
