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
    private static let DeviceIDKey = "DeviceID"
    private static let PropertiesKey = "Properties"
	
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
		let messageType: String = plist[AttachMessage.MessageTypeKey] as! String
		if messageType == AttachMessage.MessageTypeAttached {
			let deviceID: Int = plist[AttachMessage.DeviceIDKey] as! Int
			do {
                let properties = plist[AttachMessage.PropertiesKey] as! [String : Any]
				let data = try PropertyListSerialization.data(fromPropertyList: properties, format: .xml, options: 0)
				devices[deviceID] = data
				delegate.device(didAttach: closure(deviceID, devices))
			} catch {
    
			}
		}
		else {
			origin.decode()
		}
	}
}
