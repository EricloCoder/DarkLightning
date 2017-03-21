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
	
	internal required init(deviceID: UInt, port: UInt32) {
		super.init(
			origin: MessageData(
				data: DictData(
					dict: [
						ConnectMessageData.DictionaryKeyMessageType: ConnectMessageData.MessageTypeConnect,
						ConnectMessageData.DictionaryKeyDeviceID: String(deviceID),
						ConnectMessageData.DictionaryKeyPortNumber: String(port),
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
