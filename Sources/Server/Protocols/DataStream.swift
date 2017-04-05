//
//  DataStream.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

public protocol DataStream: class {
    func open(in queue: DispatchQueue)
	func close()
}

public final class DataStreamFake: DataStream {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - DataStream
    
	public func open(in queue: DispatchQueue) {
		
	}
	
	public func close() {
		
	}
}
