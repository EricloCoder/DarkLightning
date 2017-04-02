//
//  DisconnectReaction.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

internal final class DisconnectReaction: NSObject, StreamDelegate {
	private let handle: Memory<CFSocketNativeHandle>
	private let state: Memory<Int>
	
	// MARK: Init
    
	internal required init(handle: Memory<CFSocketNativeHandle>, state: Memory<Int>) {
        self.handle = handle
		self.state = state
    }
    
    // MARK: StreamDelegate
	
	func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
		if eventCode == .endEncountered || eventCode == .errorOccurred {
			handle.rawValue = -1
			state.rawValue = 0
		}
	}
}
