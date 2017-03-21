//
//  StreamDelegates.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 18/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

internal final class StreamDelegates: NSObject, StreamDelegate {
	private let delegates: [StreamDelegate]
	
	// MARK: Init
    
	internal required init(delegates: [StreamDelegate]) {
        self.delegates = delegates
    }
    
    // MARK: StreamDelegate
	
	func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
		for delegate in delegates {
			delegate.stream!(aStream, handle: eventCode)
		}
	}
}
