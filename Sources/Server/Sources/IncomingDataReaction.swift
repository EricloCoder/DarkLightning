//
//  IncomingDataReaction.swift
//  DarkLightning
//
//  Created by Jens Meder on 08/04/17.
//
//

import Foundation

internal final class IncomingDataReaction: DataDecoding {
	private let delegate: PortDelegate
	private let port: Port
	
	// MARK: Init
    
	internal init(port: Port, delegate: PortDelegate) {
        self.port = port
		self.delegate = delegate
    }
    
    // MARK: DataDecoding
	
	func decode(data: OOData) {
		delegate.port(port: port, didReceiveData: data)
	}
}
