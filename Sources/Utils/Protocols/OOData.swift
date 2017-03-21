//
//  OOData.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal protocol OOData: class {
	var rawValue: Data {get}
}

internal final class OODataFake: OOData {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - OOData
    
	var rawValue: Data {
		return Data()
	}
}
