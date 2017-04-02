//
//  DataDecoding.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

public protocol DataDecoding: class {
	func decode(data: OOData)
}

public final class DataDecodingFake: DataDecoding {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Decoding
    
	public func decode(data: OOData) {
		
	}
}
