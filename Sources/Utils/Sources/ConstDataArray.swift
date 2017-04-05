//
//  ConstDataArray.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation

internal final class ConstDataArray: OODataArray {
    private let data: Data
    
	// MARK: Init
    
    internal required init(data: Data) {
        self.data = data
    }
    
    // MARK: OODataArray
    
    var count: UInt {
        return 1
    }
    
    subscript(index: UInt) -> OOData {
        return RawData(data)
    }
}
