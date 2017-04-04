//
//  OODataArray.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

internal protocol OODataArray: class {
	var count: UInt {get}
	subscript(index: UInt) -> OOData {get}
}

internal final class OODataArrayFake: OODataArray {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - OODataArray
    
	var count: UInt {
		return 0
	}
	
	subscript(index: UInt) -> OOData {
		return OODataFake()
	}
}
