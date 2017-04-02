//
//  Port.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

public protocol Port: class {
	func open()
	func close()
	func write(data: Data)
}

public final class PortFake: Port {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Port
    
	public func open() {
		
	}
	
	public func close() {
		
	}
	
	public func write(data: Data) {
		
	}
}

public class PortWrap: Port {
	private let origin: Port
	
	// MARK: - Init
	
	public init(origin: Port) {
		self.origin = origin
	}
	
	// MARK: - Port
	
	public func open() {
		origin.open()
	}
	
	public func close() {
		origin.close()
	}
	
	public func write(data: Data) {
		origin.write(data: data)
	}
}
