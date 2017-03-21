//
//  ListeningMessageData.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal final class ListeningMessageData: OODataWrap {

	private static let DictionaryKeyMessageType  = "MessageType"
	private static let MessageTypeListen 		 = "Listen"
	private static let ProgNameValue             = "DarkLightning"
	private static let DictionaryKeyProgName     = "ProgName"
	
	// MARK: Init
    
    internal required init() {
        super.init(
			origin: MessageData(
				data: DictData(
					dict: [
						ListeningMessageData.DictionaryKeyMessageType: ListeningMessageData.MessageTypeListen,
						ListeningMessageData.DictionaryKeyProgName: ListeningMessageData.ProgNameValue
					]
				),
				packetType: 8,
				messageTag: 1,
				protocolType: 1
			)
		)
    }
}
