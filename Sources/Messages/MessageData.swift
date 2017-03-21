//
//  MessageData.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal final class MessageData: OODataWrap {
	
	// MARK: Init
    
	internal required init(data: OOData, packetType: UInt32, messageTag: UInt32, protocolType: UInt32) {
        super.init(
			origin: DataWithUInt32(
				value: UInt32(data.rawValue.count + 4*MemoryLayout<UInt32>.size),
				origin: DataWithUInt32(
					value: protocolType,
					origin: DataWithUInt32(
						value: packetType,
						origin: DataWithUInt32(
							value: messageTag,
							origin: data
						)
					)
				)
			)
		)
    }
}
