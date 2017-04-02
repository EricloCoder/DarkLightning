//
//  USBMuxMessageWrap.swift
//  DarkLightning
//
//  Created by Jens Meder on 22/03/17.
//
//

import Foundation

internal class USBMuxMessageWrap: USBMuxMessage {
	private let origin: USBMuxMessage
	
	// MARK: Init
    
    internal init(origin: USBMuxMessage) {
        self.origin = origin
    }
    
    // MARK: USBMuxMessage
	
	func decode() {
		origin.decode()
	}
}
