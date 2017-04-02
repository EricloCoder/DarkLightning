//
//  ReceivingDataReaction.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

internal final class ReceivingDataReaction: DataDecoding {
	private let mapping: ([String: Any]) -> (USBMuxMessage)
	
	// MARK: Init
    
    internal required init(mapping: @escaping ([String: Any]) -> (USBMuxMessage)) {
        self.mapping = mapping
    }
    
    // MARK: DataDecoding
	
	public func decode(data: OOData) {
		do {
			let plist: [String: Any] = try PropertyListSerialization.propertyList(from: data.rawValue, options: [], format: nil) as! [String : Any]
			let message = mapping(plist)
			message.decode()
		} catch {

		}
	}
}
