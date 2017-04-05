//
//  TCPMessage.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation

internal final class TCPMessage: DataDecoding {
    private let origin: DataDecoding
    private let tcpMode: Memory<Bool>
    
	// MARK: Init
    
    internal required init(origin: DataDecoding, tcpMode: Memory<Bool>) {
        self.origin = origin
        self.tcpMode = tcpMode
    }
    
    // MARK: DataDecoding
    
    func decode(data: OOData) {
        if tcpMode.rawValue {
            DispatchQueue.main.async {
                print(String(data: data.rawValue, encoding: .utf8)!)
            }
        }
        else {
            origin.decode(data: data)
        }
    }
}
