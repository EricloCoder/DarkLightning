//
//  ResultMessage.swift
//  DarkLightning
//
//  Created by Jens Meder on 22/03/17.
//
//

import Foundation

internal final class ResultMessage: USBMuxMessage {
	
	// MARK: Constants
	
	private static let MessageTypeResult = "Result"
	private static let MessageTypeKey = "MessageType"
	
	// MARK: Members
	
	private let origin: USBMuxMessage
	private let plist: [String: Any]
    private let tcpMode: Memory<Bool>
	
	// MARK: Init
	
    internal convenience init(plist: [String: Any], tcpMode: Memory<Bool>) {
        self.init(
            origin: USBMuxMessageFake(),
            plist: plist,
            tcpMode: tcpMode
        )
    }
    
	internal required init(origin: USBMuxMessage, plist: [String: Any], tcpMode: Memory<Bool>) {
		self.origin = origin
		self.plist = plist
        self.tcpMode = tcpMode
	}
	
	// MARK: USBMuxMessage
	
	func decode() {
		let messageType: String = plist[ResultMessage.MessageTypeKey] as! String
		if messageType == ResultMessage.MessageTypeResult {
			let number = plist["Number"] as! Int
            if number == 0 {
                tcpMode.rawValue = true
            }
		}
		else {
			origin.decode()
		}
	}
}
