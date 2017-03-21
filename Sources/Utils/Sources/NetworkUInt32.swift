//
//  NetworkUInt32.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 19/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

internal final class NetworkUInt32: OOUInt32 {
	private let byteOrder: Int32
	private let origin: UInt32
	
	// MARK: Init
	
	internal convenience init(origin: UInt32) {
		self.init(
			origin: origin,
			byteOrder: OSHostByteOrder()
		)
	}
	
	internal required init(origin: UInt32, byteOrder: Int32) {
		self.byteOrder = byteOrder
		self.origin = origin
	}
	
    // MARK: OOUInt32
	
	var rawValue: UInt32 {
		return Int(byteOrder) == OSLittleEndian ? _OSSwapInt32(origin) : origin
	}
}
