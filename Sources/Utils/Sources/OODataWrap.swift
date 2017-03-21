//
//  OODataWrap.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal class OODataWrap: OOData {
	private let origin: OOData
	
	// MARK: Init
    
    internal init(origin: OOData) {
        self.origin = origin
    }
    
    // MARK: OOData
	
	var rawValue: Data {
		return origin.rawValue
	}
}
