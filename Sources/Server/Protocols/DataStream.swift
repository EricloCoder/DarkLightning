//
//  DataStream.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

public protocol DataStream: class {
	func open()
	func close()
}

public final class DataStreamFake: DataStream {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - DataStream
    
	public func open() {
		
	}
	
	public func close() {
		
	}
}
