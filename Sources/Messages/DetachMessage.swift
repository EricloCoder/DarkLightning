//
//  DetachMessage.swift
//  DarkLightning
//
//  Created by Jens Meder on 22/03/17.
//
//

import Foundation

internal final class DetachMessage: USBMuxMessage {
	// MARK: Constants
	
	private static let MessageTypeDetached = "Detached"
	private static let MessageTypeKey = "MessageType"
	
	// MARK: Members
	
	private let origin: USBMuxMessage
	private let plist: [String: Any]
	private let devices: DictionaryReference<Int, Data>
	private let delegate: DevicesDelegate
	private let closure: (Int, DictionaryReference<Int, Data>) -> (Device)
	
	// MARK: Init
	
	internal init(origin: USBMuxMessage, plist: [String: Any], devices: DictionaryReference<Int, Data>, delegate: DevicesDelegate, closure: @escaping (Int, DictionaryReference<Int, Data>) -> (Device)) {
		self.origin = origin
		self.plist = plist
		self.devices = devices
		self.delegate = delegate
		self.closure = closure
	}
	
	// MARK: USBMuxMessage
	
	func decode() {
		let messageType: String = plist[DetachMessage.MessageTypeKey] as! String
		if messageType == DetachMessage.MessageTypeDetached {
			let deviceID: Int = plist["DeviceID"] as! Int
			delegate.device(didDetach: closure(deviceID, devices))
			devices[deviceID] = nil
		}
		else {
			origin.decode()
		}
	}
}
