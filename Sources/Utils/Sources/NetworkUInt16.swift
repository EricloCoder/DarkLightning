//
//  NetworkUInt16.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 19/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

internal final class NetworkUInt16: OOUInt16 {
	private let byteOrder: Int32
	private let origin: UInt16
	
	// MARK: Init
	
	internal convenience init(origin: UInt16) {
		self.init(
			origin: origin,
			byteOrder: OSHostByteOrder()
		)
	}
	
    internal required init(origin: UInt16, byteOrder: Int32) {
        self.byteOrder = byteOrder
		self.origin = origin
    }
    
    // MARK: OOUInt16
	
	var rawValue: UInt16 {
		return Int(byteOrder) == OSLittleEndian ? _OSSwapInt16(origin) : origin
	}
}
