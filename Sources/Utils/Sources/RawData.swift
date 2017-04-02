//
//  RawData.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

public final class RawData: OOData {
	private let origin: Data
	
	// MARK: Init
    
    public required init(_ origin: Data) {
        self.origin = origin
    }
    
    // MARK: OOData
	
	public var rawValue: Data {
		return origin
	}
}
