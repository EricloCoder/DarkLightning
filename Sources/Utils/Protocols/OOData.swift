//
//  OOData.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

public protocol OOData: class {
	var rawValue: Data {get}
}

public final class OODataFake: OOData {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - OOData
    
	public var rawValue: Data {
		return Data()
	}
}

public class OODataWrap: OOData {
	private let origin: OOData
	
	// MARK: Init
	
	public init(origin: OOData) {
		self.origin = origin
	}
	
	// MARK: OOData
	
	public var rawValue: Data {
		return origin.rawValue
	}
}

