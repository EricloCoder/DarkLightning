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
    private let dataMapping: (Data) -> (OODataArray)
	
	// MARK: Init
    
    internal required init(mapping: @escaping ([String: Any]) -> (USBMuxMessage), dataMapping: @escaping (Data) -> (OODataArray)) {
        self.mapping = mapping
        self.dataMapping = dataMapping
    }
    
    // MARK: DataDecoding
	
	public func decode(data: OOData) {
        let messages = dataMapping(data.rawValue)
        for i in 0..<messages.count {
            do {
                let plist: [String: Any] = try PropertyListSerialization.propertyList(from: messages[i].rawValue, options: [], format: nil) as! [String : Any]
                let message = mapping(plist)
                message.decode()
            } catch {
                
            }
        }
	}
}
