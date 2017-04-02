//
//  Daemon.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

public protocol Daemon: class {
	func start()
	func stop()
}

public final class DaemonFake: Daemon {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Daemon
    
	public func start() {
		
	}
	
	public func stop() {
		
	}
}

public class DaemonWrap: Daemon {
	private let origin: Daemon
	
	// MARK: - Init
	
	public init(origin: Daemon) {
		self.origin = origin
	}
	
	// MARK: - Daemon
	
	public func start() {
		origin.start()
	}
	
	public func stop() {
		origin.stop()
	}
}
