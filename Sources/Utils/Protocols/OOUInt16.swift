//
//  OOUInt16.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 19/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

internal protocol OOUInt16: class {
	var rawValue: UInt16 {get}
}

internal final class OOUInt16Fake: OOUInt16 {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - OOUInt16
    
	var rawValue: UInt16 {
		return 0
	}
}
