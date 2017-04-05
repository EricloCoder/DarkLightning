//
//  StoppingUSBDaemon.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation

internal final class StoppingUSBDaemon: Daemon {
    private let origin: Daemon
    private let stream: Memory<DataStream?>
    private let handle: Memory<CFSocketNativeHandle>
    
	// MARK: Init
    
    internal required init(origin: Daemon, handle: Memory<CFSocketNativeHandle>, stream: Memory<DataStream?>) {
        self.origin = origin
        self.handle = handle
        self.stream = stream
    }
    
    // MARK: Daemon
    
    func start() {
        origin.start()
    }
    
    func stop() {
        if handle.rawValue != CFSocketInvalidHandle {
            stream.rawValue?.close()
            _ = Darwin.close(handle.rawValue)
            handle.rawValue = CFSocketInvalidHandle
            stream.rawValue = nil
        }
    }
}
