//
//  USBMuxMessageDataArray.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

internal final class USBMuxMessageDataArray: OODataArray {
	private let data: Data
	private let closure: (Data) -> (OOData)
	
	// MARK: Init
    
    internal required init(data: Data, closure: @escaping (Data) -> (OOData)) {
        self.data = data
		self.closure = closure
    }
	
	// MARK: Private
	
	private func messages() -> [Data] {
		var result: [Data] = []
		var origin = data
		let headerSize = 4 * MemoryLayout<UInt32>.size
		while origin.count >= headerSize {
			let size: UInt32 = origin.subdata(in: 0..<4).withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> UInt32 in
				return ptr.pointee
			}
			if Int(size) <= origin.count {
				let message = origin.subdata(in: headerSize..<Int(size))
				result.append(message)
				origin.removeSubrange(0..<Int(size))
			}
			else {
				origin = Data()
			}
		}
		return result
	}
    
    // MARK: OODataArray
	
	var count: UInt {
		return UInt(messages().count)
	}
	
	subscript(index: UInt) -> OOData {
		return closure(messages()[Int(index)])
	}
}
