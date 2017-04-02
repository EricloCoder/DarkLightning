//
//  DataWithUInt32.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal final class DataWithUInt32: OOData {
	private let value: UInt32
	private let origin: OOData
	
	// MARK: Init
    
    internal required init(value: UInt32, origin: OOData) {
        self.value = value
		self.origin = origin
    }
    
    // MARK: OOData
	
	var rawValue: Data {
		var aValue = value
		var data = withUnsafePointer(to: &aValue) {
			Data(bytes: UnsafePointer($0), count: MemoryLayout<UInt32>.size)
		}
		data.append(origin.rawValue)
		return data
	}
}
