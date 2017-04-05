//
//  ConnectMessageData.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal final class ConnectMessageData: OODataWrap {

	private static let DictionaryKeyMessageType  = "MessageType"
	private static let MessageTypeConnect 		 = "Connect"
	private static let ProgNameValue             = "DarkLightning"
	private static let DictionaryKeyProgName     = "ProgName"
	private static let DictionaryKeyDeviceID 	 = "DeviceID"
	private static let DictionaryKeyPortNumber 	 = "PortNumber"
	
	// MARK: Init
	
	internal required init(deviceID: Int, port: UInt32) {
        let p: UInt32 = ((port<<8) & 0xFF00) | (port>>8)
		super.init(
			origin: MessageData(
				data: DictData(
					dict: [
						ConnectMessageData.DictionaryKeyMessageType: ConnectMessageData.MessageTypeConnect,
						ConnectMessageData.DictionaryKeyDeviceID: NSNumber(integerLiteral: deviceID),
						ConnectMessageData.DictionaryKeyPortNumber: NSNumber(integerLiteral: Int(p)),
						ConnectMessageData.DictionaryKeyProgName: ConnectMessageData.ProgNameValue
					]
				),
				packetType: 8,
				messageTag: 1,
				protocolType: 1
			)
		)
	}
}
