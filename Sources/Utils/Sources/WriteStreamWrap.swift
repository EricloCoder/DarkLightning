//
//  WriteStreamWrap.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 19/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

public class WriteStreamWrap: WriteStream {
	private let origin: WriteStream
	
	// MARK: Init
    
	internal init(origin: WriteStream) {
        self.origin = origin
    }
    
    // MARK: WriteStream
	
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
