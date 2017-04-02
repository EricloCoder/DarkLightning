//
//  USBMuxMessageData.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

internal final class USBMuxMessageData: OOData {
	private let origin: Data

	// MARK: Init
    
	internal required init(origin: Data) {
        self.origin = origin
    }
    
    // MARK: OOData
	
	var rawValue: Data {
		var result = Data()
		if origin.count > 4 * MemoryLayout<UInt32>.size {
			var size: UInt32 = origin.subdata(in: 12..<16).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
				return ptr.pointee
			}
			size += UInt32(4 * MemoryLayout<UInt32>.size)
			if Int(size) < origin.count {
				result = origin.subdata(in: 16..<origin.count)
			}
		}
		return result
	}
}
