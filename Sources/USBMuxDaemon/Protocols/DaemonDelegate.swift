//
//  DaemonDelegate.swift
//  DarkLightning
//
//  Created by Jens Meder on 14.04.17.
//
//

import Foundation

public protocol DaemonDelegate: class {
    func daemon(_ daemon: Daemon, didAttach device: Device)
    func daemon(_ daemon: Daemon, didDetach device: Device)
}

public final class DaemonDelegateFake: DaemonDelegate {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - DaemonDelegate
    
    public func daemon(_ daemon: Daemon, didAttach device: Device) {
        
    }
    
    public func daemon(_ daemon: Daemon, didDetach device: Device) {
        
    }
}
