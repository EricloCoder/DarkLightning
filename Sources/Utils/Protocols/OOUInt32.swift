//
//  OOUInt32.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 19/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

internal protocol OOUInt32: class {
	var rawValue: UInt32 {get}
}

internal final class OOUInt32Fake: OOUInt32 {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - OOUInt32
    
	var rawValue: UInt32 {
		return 0
	}
}
