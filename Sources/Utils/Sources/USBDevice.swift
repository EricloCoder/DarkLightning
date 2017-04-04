//
//  USBDevice.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

public final class USBDevice: Device, CustomStringConvertible {
	private let dictionary: DictionaryReference<Int, Data>
	private let deviceID: Int
	
	// MARK: Init
    
    public required init(deviceID: Int, dictionary: DictionaryReference<Int, Data>) {
        self.deviceID = deviceID
		self.dictionary = dictionary
    }
    
    // MARK: Device
	
	public func connect() {
		
	}
	
	public func disconnect() {
		
	}
	
	public func writeData(data: Data) {
		
	}
	
	public var description: String {
		var result = ""
		do {
			let plist: [String: Any] = try PropertyListSerialization.propertyList(from: dictionary[deviceID]!, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! [String : Any]
			result = String(format: "%@", plist)
		} catch {
			
		}
		return result
	}
}
