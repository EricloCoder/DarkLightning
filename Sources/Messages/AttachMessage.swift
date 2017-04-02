//
//  AttachMessage.swift
//  DarkLightning
//
//  Created by Jens Meder on 22/03/17.
//
//

import Foundation

internal final class AttachMessage: USBMuxMessage {
	
	// MARK: Constants
	
	private static let MessageTypeAttached = "Attached"
	private static let MessageTypeKey = "MessageType"
	
	// MARK: Members
	
	private let origin: USBMuxMessage
	private let plist: [String: Any]
	
	// MARK: Init
	
	internal init(origin: USBMuxMessage, plist: [String: Any]) {
		self.origin = origin
		self.plist = plist
	}
	
    // MARK: USBMuxMessage
	
	func decode() {
		let messageType: String = plist[AttachMessage.MessageTypeKey] as! String
		if messageType == AttachMessage.MessageTypeAttached {
			print("Attached")
		}
		else {
			origin.decode()
		}
	}
}
