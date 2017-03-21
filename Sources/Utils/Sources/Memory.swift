//
//  Memory.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 20/03/2017.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

public final class Memory<T> {
    private let buffer: UnsafeMutablePointer<T>
    
	// MARK: Init
    
    public convenience init(initialValue: T) {
        let buffer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        buffer.initialize(to: initialValue)
        self.init(buffer: buffer)
    }
    
    public required init(buffer: UnsafeMutablePointer<T>) {
        self.buffer = buffer
    }
    
    // MARK: Private
    
    deinit {
        buffer.deallocate(capacity: 1)
    }
    
    // MARK: Public
    
    public var rawValue: T {
        get {
            return buffer.pointee
        }
        set {
            buffer.pointee = newValue
        }
    }
}
